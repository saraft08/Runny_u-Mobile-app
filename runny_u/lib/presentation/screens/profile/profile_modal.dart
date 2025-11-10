// lib/presentation/screens/profile/profile_modal.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({super.key});

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  bool _isEditing = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _fullnameController = TextEditingController(text: user?.fullname ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final data = <String, dynamic>{
      'fullname': _fullnameController.text.trim(),
      'email': _emailController.text.trim(),
    };

    if (_passwordController.text.isNotEmpty) {
      data['password'] = _passwordController.text;
    }

    final success = await authProvider.updateProfile(data);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Error al actualizar perfil'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Mi Perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppTheme.lightPink,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: 'Nombre completo',
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
                    const SizedBox(height: 20),
                    if (_isEditing)
                      CustomTextField(
                        label: 'Nueva contraseña (opcional)',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        hint: 'Dejar en blanco para no cambiar',
                        validator: (value) {
                          if (value != null && value.isNotEmpty && value.length < 8) {
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
                    const SizedBox(height: 32),
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        if (_isEditing) {
                          return Column(
                            children: [
                              CustomButton(
                                text: 'Guardar cambios',
                                onPressed: _updateProfile,
                                isLoading: auth.isLoading,
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  final user = auth.currentUser;
                                  _fullnameController.text = user?.fullname ?? '';
                                  _emailController.text = user?.email ?? '';
                                  _passwordController.clear();
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: AppTheme.mediumGray),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return CustomButton(
                            text: 'Editar perfil',
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}