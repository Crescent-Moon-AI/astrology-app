package com.crescentmoon.astrology_app

import android.annotation.SuppressLint
import android.os.Handler
import android.os.Looper
import android.webkit.JavascriptInterface
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * WebSocket plugin that uses Android WebView's network stack.
 *
 * WebView uses Chrome's BoringSSL with a browser-like TLS fingerprint,
 * which bypasses ISP DPI that blocks non-browser TLS connections based
 * on SNI fingerprinting. OkHttp/Conscrypt get blocked even with TLS 1.3
 * because their ClientHello fingerprint differs from a browser.
 */
class NativeWebSocketPlugin(private val appContext: android.content.Context) : MethodChannel.MethodCallHandler {
    private var webView: WebView? = null
    private var eventSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    val streamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }
        override fun onCancel(arguments: Any?) {
            eventSink = null
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "connect" -> {
                val url = call.argument<String>("url")
                if (url == null) {
                    result.error("INVALID_ARG", "url is required", null)
                    return
                }
                connect(url, result)
            }
            "send" -> {
                val message = call.argument<String>("message")
                if (message == null) {
                    result.error("INVALID_ARG", "message is required", null)
                    return
                }
                send(message, result)
            }
            "disconnect" -> {
                disconnect(result)
            }
            else -> result.notImplemented()
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun connect(url: String, result: MethodChannel.Result) {
        mainHandler.post {
            try {
                // Clean up previous WebView
                webView?.destroy()

                // Create headless WebView with Chrome's network stack
                val wv = WebView(appContext)
                webView = wv

                wv.settings.javaScriptEnabled = true
                wv.settings.domStorageEnabled = true
                wv.settings.cacheMode = WebSettings.LOAD_NO_CACHE

                // Bridge: JS -> Kotlin
                wv.addJavascriptInterface(WsBridge(), "NativeBridge")

                wv.webViewClient = object : WebViewClient() {
                    override fun onPageFinished(view: WebView?, pageUrl: String?) {
                        // Page loaded, now open WebSocket via JS
                        val escapedUrl = url.replace("'", "\\'")
                        wv.evaluateJavascript("""
                            (function() {
                                try {
                                    window._ws = new WebSocket('$escapedUrl');
                                    window._ws.onopen = function() {
                                        NativeBridge.onOpen();
                                    };
                                    window._ws.onmessage = function(e) {
                                        NativeBridge.onMessage(e.data);
                                    };
                                    window._ws.onclose = function(e) {
                                        NativeBridge.onClosed(e.code, e.reason || '');
                                    };
                                    window._ws.onerror = function(e) {
                                        NativeBridge.onError('WebSocket error');
                                    };
                                } catch(err) {
                                    NativeBridge.onError(err.message || 'Failed to create WebSocket');
                                }
                            })();
                        """.trimIndent(), null)
                    }
                }

                // Load a blank page to initialize the WebView JS environment
                wv.loadDataWithBaseURL(
                    // Use the same origin as the WS URL for cookie/CORS purposes
                    url.replace("wss://", "https://").replace("ws://", "http://").split("/ws")[0],
                    "<html><body></body></html>",
                    "text/html",
                    "UTF-8",
                    null
                )

                result.success(null)
            } catch (e: Exception) {
                result.error("CONNECT_FAILED", e.message, null)
            }
        }
    }

    private fun send(message: String, result: MethodChannel.Result) {
        mainHandler.post {
            val wv = webView
            if (wv == null) {
                result.error("SEND_FAILED", "WebSocket not connected", null)
                return@post
            }
            val escaped = message
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
            wv.evaluateJavascript(
                "if(window._ws && window._ws.readyState === 1) window._ws.send('$escaped');",
                null
            )
            result.success(null)
        }
    }

    private fun disconnect(result: MethodChannel.Result?) {
        mainHandler.post {
            webView?.evaluateJavascript(
                "if(window._ws) { window._ws.close(1000, 'client disconnect'); window._ws = null; }",
                null
            )
            webView?.destroy()
            webView = null
            result?.success(null)
        }
    }

    /** JavaScript interface bridging WebSocket events from WebView to Flutter. */
    inner class WsBridge {
        @JavascriptInterface
        fun onOpen() {
            mainHandler.post {
                eventSink?.success(mapOf("type" to "open"))
            }
        }

        @JavascriptInterface
        fun onMessage(data: String) {
            mainHandler.post {
                eventSink?.success(mapOf("type" to "message", "data" to data))
            }
        }

        @JavascriptInterface
        fun onClosed(code: Int, reason: String) {
            mainHandler.post {
                eventSink?.success(mapOf("type" to "closed", "code" to code, "reason" to reason))
            }
        }

        @JavascriptInterface
        fun onError(message: String) {
            mainHandler.post {
                eventSink?.success(mapOf("type" to "error", "message" to message))
            }
        }
    }
}
