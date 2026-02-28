import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/social_providers.dart';

class ShareButton extends ConsumerStatefulWidget {
  final String cardType;
  final Map<String, dynamic> sourceData;

  const ShareButton({
    super.key,
    required this.cardType,
    required this.sourceData,
  });

  @override
  ConsumerState<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends ConsumerState<ShareButton> {
  bool _loading = false;

  Future<void> _onShare() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final repo = ref.read(socialRepositoryProvider);
      final card = await repo.generateCard(
        cardType: widget.cardType,
        sourceData: widget.sourceData,
      );
      if (mounted) {
        context.pushNamed(
          'sharePreview',
          extra: card,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onShare,
      icon: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.share),
    );
  }
}
