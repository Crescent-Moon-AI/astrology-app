import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../scenario/presentation/providers/scenario_providers.dart';
import '../providers/auth_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    ref.read(authProvider.notifier).clearError();

    final ok = await ref.read(authProvider.notifier).register(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
          username: _usernameCtrl.text.trim().isNotEmpty
              ? _usernameCtrl.text.trim()
              : null,
        );

    if (mounted) setState(() => _loading = false);
    if (ok && mounted) {
      ref.invalidate(scenarioListProvider);
      ref.invalidate(scenarioCategoriesProvider);
      ref.invalidate(hotScenariosProvider);
      context.go('/scenarios');
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
    final l10n = AppLocalizations.of(context)!;

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
                      '\u2728', // ✨
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.authCreateAccount,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CosmicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email
                    TextFormField(
                      controller: _emailCtrl,
                      style:
                          const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: l10n.authEmail,
                        prefixIcon: Icons.email_outlined,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return l10n.authRequired;
                        if (!v.contains('@')) return l10n.authInvalidEmail;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Username
                    TextFormField(
                      controller: _usernameCtrl,
                      style:
                          const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: l10n.authUsername,
                        prefixIcon: Icons.person_outline,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordCtrl,
                      style:
                          const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: l10n.authPassword,
                        prefixIcon: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: CosmicColors.textTertiary,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      obscureText: _obscure,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.authRequired;
                        if (v.length < 8) return l10n.authPasswordMin;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmCtrl,
                      style:
                          const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: l10n.authConfirmPassword,
                        prefixIcon: Icons.lock_outline,
                      ),
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (v) {
                        if (v != _passwordCtrl.text) {
                          return l10n.authPasswordMismatch;
                        }
                        return null;
                      },
                    ),

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

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: _loading
                              ? null
                              : CosmicColors.primaryGradient,
                          color: _loading
                              ? CosmicColors.surfaceElevated
                              : null,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: _loading
                              ? null
                              : [
                                  BoxShadow(
                                    color: CosmicColors.primary
                                        .withValues(alpha: 0.3),
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
                                  : Text(
                                      l10n.authRegister,
                                      style: const TextStyle(
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

                    // Login link
                    TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(
                        foregroundColor: CosmicColors.primaryLight,
                      ),
                      child:
                          Text(l10n.authHaveAccount),
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
