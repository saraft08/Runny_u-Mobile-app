import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text,
      _fullnameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Error al crear cuenta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Runny ',
                          style: TextStyle(
                            color: AppTheme.darkGray,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'U',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Crea tu cuenta con tu correo institucional',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.mediumGray,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Nombre completo',
                  hint: 'Ej: María González',
                  controller: _fullnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu nombre completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Correo electrónico',
                  hint: 'tucorreo@isoyudemedellin.edu.co',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    if (!value.contains('@')) {
                      return 'Correo inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'Asegúrate de no usar tildes ni mayúsculas. No se aceptan correos personales como Gmail, Outlook, etc.',
                  style: TextStyle(
                    color: AppTheme.mediumGray,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Contraseña',
                  hint: 'Crea una contraseña segura',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una contraseña';
                    }
                    if (value.length < 8) {
                      return 'Mínimo 8 caracteres';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.mediumGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mínimo 8 caracteres, incluye números y letras.',
                  style: TextStyle(
                    color: AppTheme.mediumGray,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Confirmar contraseña',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirma tu contraseña';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.mediumGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: AppTheme.primaryOrange,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptTerms = !_acceptTerms;
                          });
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: AppTheme.darkGray,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(text: 'Acepto los '),
                              TextSpan(
                                text: 'términos y condiciones',
                                style: TextStyle(
                                  color: AppTheme.primaryOrange,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' (obligatorio)'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return CustomButton(
                      text: 'Crear Cuenta',
                      onPressed: _signUp,
                      isLoading: auth.isLoading,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes una cuenta? '),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Solo para miembros de la universidad.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.mediumGray,
                      fontSize: 12,
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