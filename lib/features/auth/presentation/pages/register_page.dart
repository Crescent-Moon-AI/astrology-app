import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  bool _loading = false;
  bool _sending = false;
  int _countdown = 0;
  Timer? _timer;
  String? _sendError;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _usernameCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _countdown = 60);
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
      setState(() => _sendError = '请输入手机号');
      return;
    }
    setState(() {
      _sending = true;
      _sendError = null;
    });
    final err = await ref.read(authProvider.notifier).sendSMSOTP(phone);
    if (!mounted) return;
    setState(() => _sending = false);
    if (err != null) {
      setState(() => _sendError = err);
    } else {
      _startCountdown();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    ref.read(authProvider.notifier).clearError();

    final ok = await ref
        .read(authProvider.notifier)
        .smsRegister(
          _phoneCtrl.text.trim(),
          _codeCtrl.text.trim(),
          username: _usernameCtrl.text.trim().isNotEmpty
              ? _usernameCtrl.text.trim()
              : null,
        );

    if (mounted) setState(() => _loading = false);
    if (ok && mounted) {
      ref.invalidate(scenarioListProvider);
      ref.invalidate(scenarioCategoriesProvider);
      ref.invalidate(hotScenariosProvider);
      context.go('/home');
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
                      '\u2728', // ✨
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '注册新账号',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CosmicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Phone
                    TextFormField(
                      controller: _phoneCtrl,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: '手机号',
                        prefixIcon: Icons.phone_outlined,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ],
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return '请输入手机号';
                        if (v.trim().length < 8) return '手机号格式不正确';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // OTP
                    TextFormField(
                      controller: _codeCtrl,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: '验证码',
                        prefixIcon: Icons.password_outlined,
                        suffix: _countdown > 0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '${_countdown}s',
                                  style: const TextStyle(
                                    color: CosmicColors.textTertiary,
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
                                        '获取验证码',
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
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return '请输入验证码';
                        if (v.length != 6) return '验证码为6位数字';
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

                    const SizedBox(height: 16),

                    // Username (optional)
                    TextFormField(
                      controller: _usernameCtrl,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _inputDecoration(
                        label: '昵称（可选）',
                        prefixIcon: Icons.person_outline,
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
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
                                      '注册',
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

                    // Login link
                    TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(
                        foregroundColor: CosmicColors.primaryLight,
                      ),
                      child: const Text('已有账号？去登录'),
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
