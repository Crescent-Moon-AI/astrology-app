import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../scenario/presentation/providers/scenario_providers.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  bool _sending = false;
  int _countdown = 0;
  Timer? _timer;
  String? _sendError;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    setState(() => _countdown = seconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _countdown--;
        if (_countdown <= 0) t.cancel();
      });
    });
  }

  Future<void> _sendCode() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      setState(() => _sendError = '\u8BF7\u8F93\u5165\u624B\u673A\u53F7');
      return;
    }
    setState(() {
      _sending = true;
      _sendError = null;
    });

    final (cooldown, err) = await ref
        .read(authProvider.notifier)
        .sendSMSOTP(phone);
    if (!mounted) return;
    setState(() => _sending = false);
    if (err != null) {
      setState(() => _sendError = err);
    } else {
      _startCountdown(cooldown ?? 60);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    ref.read(authProvider.notifier).clearError();

    final ok = await ref
        .read(authProvider.notifier)
        .smsVerify(_phoneCtrl.text.trim(), _codeCtrl.text.trim());

    if (mounted) setState(() => _loading = false);
    if (ok && mounted) {
      ref.invalidate(scenarioListProvider);
      ref.invalidate(scenarioCategoriesProvider);
      ref.invalidate(hotScenariosProvider);
      final needsOnboarding = ref.read(authProvider).needsOnboarding;
      context.go(needsOnboarding ? '/onboarding' : '/home');
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: CosmicColors.textSecondary),
      prefixIcon: Icon(prefixIcon, color: CosmicColors.textSecondary),
      suffixIcon: suffix,
      filled: true,
      fillColor: CosmicColors.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.borderGlow),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.borderGlow),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '\uD83C\uDF19', // moon emoji
                      style: TextStyle(fontSize: 56),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '\u661F\u89C1',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: CosmicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Phone
                    TextFormField(
                      controller: _phoneCtrl,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: '\u624B\u673A\u53F7',
                        prefixIcon: Icons.phone_outlined,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ],
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return '\u8BF7\u8F93\u5165\u624B\u673A\u53F7';
                        }
                        if (v.trim().length < 8) {
                          return '\u624B\u673A\u53F7\u683C\u5F0F\u4E0D\u6B63\u786E';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // OTP code
                    TextFormField(
                      controller: _codeCtrl,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: '\u9A8C\u8BC1\u7801',
                        prefixIcon: Icons.password_outlined,
                        suffix: _countdown > 0
                            ? Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: CosmicColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${_countdown}s',
                                  style: const TextStyle(
                                    color: CosmicColors.textTertiary,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: _sending ? null : _sendCode,
                                child: _sending
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: CosmicColors.primary,
                                        ),
                                      )
                                    : const Text(
                                        '\u83B7\u53D6\u9A8C\u8BC1\u7801',
                                        style: TextStyle(
                                          color: CosmicColors.primary,
                                        ),
                                      ),
                              ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return '\u8BF7\u8F93\u5165\u9A8C\u8BC1\u7801';
                        }
                        if (v.length != 6) {
                          return '\u9A8C\u8BC1\u7801\u4E3A6\u4F4D\u6570\u5B57';
                        }
                        return null;
                      },
                    ),

                    if (_sendError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _sendError!,
                        style: const TextStyle(
                          color: CosmicColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ],

                    // Error
                    if (authState.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        authState.error!,
                        style: const TextStyle(
                          color: CosmicColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: _loading
                              ? null
                              : CosmicColors.primaryGradient,
                          color: _loading ? CosmicColors.surfaceElevated : null,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: _loading
                              ? null
                              : [
                                  BoxShadow(
                                    color: CosmicColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _loading ? null : _submit,
                            borderRadius: BorderRadius.circular(24),
                            child: Center(
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: CosmicColors.textPrimary,
                                      ),
                                    )
                                  : const Text(
                                      '\u767B\u5F55',
                                      style: TextStyle(
                                        color: CosmicColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      '\u672A\u6CE8\u518C\u624B\u673A\u53F7\u5C06\u81EA\u52A8\u521B\u5EFA\u8D26\u53F7',
                      style: TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
