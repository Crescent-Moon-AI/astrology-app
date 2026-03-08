import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../providers/diary_providers.dart';

/// Diary entry editor — matches the real app's "添加新日记" page.
class DiaryEditPage extends ConsumerStatefulWidget {
  const DiaryEditPage({super.key});

  @override
  ConsumerState<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends ConsumerState<DiaryEditPage> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _pickedImages = [];
  bool _isPublishing = false;
  static const _maxLength = 1000;
  static const _maxImages = 9;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CosmicColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: Cancel / Publish
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      l10n.cancel,
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isPublishing ? null : _onPublish,
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, _) {
                        final hasContent = value.text.trim().isNotEmpty ||
                            _pickedImages.isNotEmpty;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: hasContent && !_isPublishing
                                ? const LinearGradient(
                                    colors: [
                                      CosmicColors.primary,
                                      CosmicColors.primaryLight,
                                    ],
                                  )
                                : null,
                            color: hasContent && !_isPublishing
                                ? null
                                : CosmicColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _isPublishing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: CosmicColors.textTertiary,
                                  ),
                                )
                              : Text(
                                  l10n.diaryPublish,
                                  style: TextStyle(
                                    color: hasContent
                                        ? CosmicColors.textPrimary
                                        : CosmicColors.textTertiary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Text input area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLength: _maxLength,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 16,
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.diaryEditHint,
                          hintStyle: TextStyle(
                            color: CosmicColors.textTertiary.withAlpha(150),
                            fontSize: 16,
                            height: 1.6,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),

                    // Character count
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (context, value, _) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${value.text.length}/$_maxLength',
                              style: const TextStyle(
                                color: CosmicColors.textTertiary,
                                fontSize: 13,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Image thumbnails + add button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Existing picked images
                          for (int i = 0; i < _pickedImages.length; i++)
                            _buildImageThumbnail(i),
                          // Add photo button (if under limit)
                          if (_pickedImages.length < _maxImages)
                            GestureDetector(
                              onTap: _onAddPhoto,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: CosmicColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: CosmicColors.borderGlow,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: CosmicColors.textTertiary,
                                  size: 28,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(_pickedImages[index].path),
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        // Remove button
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => setState(() => _pickedImages.removeAt(index)),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: CosmicColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onAddPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: CosmicColors.backgroundDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: CosmicColors.textPrimary),
              title: const Text('拍照',
                  style: TextStyle(color: CosmicColors.textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: CosmicColors.textPrimary),
              title: const Text('从相册选择',
                  style: TextStyle(color: CosmicColors.textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (picked != null && _pickedImages.length < _maxImages) {
      setState(() => _pickedImages.add(picked));
    }
  }

  Future<void> _onPublish() async {
    final content = _controller.text.trim();
    if (content.isEmpty && _pickedImages.isEmpty) return;

    setState(() => _isPublishing = true);

    try {
      final api = ref.read(diaryApiProvider);

      // Upload images first
      final imageUrls = <String>[];
      for (final img in _pickedImages) {
        final url = await api.uploadImage(img.path);
        imageUrls.add(url);
      }

      // Create diary entry with content + image URLs
      await api.create(
        content: content,
        images: imageUrls.isNotEmpty ? imageUrls : null,
      );
      ref.invalidate(diaryListProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }
}
