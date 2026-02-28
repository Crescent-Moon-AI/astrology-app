import 'package:flutter/material.dart';

class PresetQuestionChip extends StatelessWidget {
  final String question;
  final VoidCallback? onTap;

  const PresetQuestionChip({
    super.key,
    required this.question,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        question,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onPressed: onTap,
      avatar: const Icon(Icons.chat_bubble_outline, size: 16),
    );
  }
}
