import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class ChatInput extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool enabled;

  const ChatInput({super.key, required this.onSend, this.enabled = true});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canSend = _hasText && widget.enabled;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: CosmicColors.background,
        border: Border(
          top: BorderSide(color: CosmicColors.borderGlow, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: l10n?.chatInputHint ?? '在这里写下你的问题...',
                hintStyle: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: CosmicColors.borderGlow),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: CosmicColors.borderGlow),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: CosmicColors.primary,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: CosmicColors.surfaceElevated,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: canSend ? CosmicColors.primaryGradient : null,
              color: canSend ? null : CosmicColors.surface,
            ),
            child: IconButton(
              onPressed: canSend ? _send : null,
              icon: Icon(
                Icons.send_rounded,
                size: 20,
                color: canSend
                    ? CosmicColors.textPrimary
                    : CosmicColors.textTertiary,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
