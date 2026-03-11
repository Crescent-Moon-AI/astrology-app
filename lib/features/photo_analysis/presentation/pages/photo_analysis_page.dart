import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';

class PhotoAnalysisPage extends StatefulWidget {
  const PhotoAnalysisPage({super.key});

  @override
  State<PhotoAnalysisPage> createState() => _PhotoAnalysisPageState();
}

class _PhotoAnalysisPageState extends State<PhotoAnalysisPage> {
  final _picker = ImagePicker();
  final _questionController = TextEditingController();
  XFile? _pickedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image != null && mounted) {
        setState(() => _pickedImage = image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('图片选择失败: $e')),
        );
      }
    }
  }

  void _showImageSourceSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CosmicColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded,
                    color: CosmicColors.primary),
                title: Text(l10n.photoAnalysisTakePhoto,
                    style:
                        const TextStyle(color: CosmicColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded,
                    color: CosmicColors.primary),
                title: Text(l10n.photoAnalysisGallery,
                    style:
                        const TextStyle(color: CosmicColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startAnalysis() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoAnalysisNoImage)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bytes = await File(_pickedImage!.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      final ext = _pickedImage!.path.split('.').last.toLowerCase();
      final mediaType = ext == 'png' ? 'image/png' : 'image/jpeg';

      final question = _questionController.text.trim().isEmpty
          ? l10n.photoAnalysisDefaultQuestion
          : _questionController.text.trim();

      if (!mounted) return;

      context.push(
        '/chat',
        extra: {
          'initial_message': question,
          'image_data': base64Image,
          'image_media_type': mediaType,
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('图片处理失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(
          l10n.photoAnalysisTitle,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CosmicColors.background.withValues(alpha: 0.95),
        centerTitle: true,
      ),
      body: StarfieldBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Container(
                      decoration: BoxDecoration(
                        color: CosmicColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _pickedImage != null
                              ? CosmicColors.primary.withValues(alpha: 0.6)
                              : CosmicColors.borderGlow,
                          width: _pickedImage != null ? 2 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _pickedImage != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(_pickedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: _showImageSourceSheet,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: CosmicColors.background
                                            .withValues(alpha: 0.8),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                            color: CosmicColors.borderGlow),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.refresh_rounded,
                                            color: CosmicColors.textSecondary,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.photoAnalysisPickImage,
                                            style: const TextStyle(
                                              color:
                                                  CosmicColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      CosmicColors.primaryGradient
                                          .createShader(bounds),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 56,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.photoAnalysisPickImage,
                                  style: const TextStyle(
                                    color: CosmicColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: CosmicColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CosmicColors.borderGlow),
                  ),
                  child: TextField(
                    controller: _questionController,
                    maxLines: 3,
                    minLines: 1,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.photoAnalysisQuestionHint,
                      hintStyle: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: CosmicColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _startAnalysis,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.photoAnalysisSend,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
