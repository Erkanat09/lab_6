import 'package:flutter/material.dart';
import 'package:registration_app/model/user.dart';
import 'package:easy_localization/easy_localization.dart';

class RegistrationPage extends StatefulWidget {
  final void Function(User) onUserRegistered;

  const RegistrationPage({Key? key, required this.onUserRegistered}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register_form'.tr()),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final newLocale = context.locale.languageCode == 'en' ? const Locale('ru') : const Locale('en');
              context.setLocale(newLocale);
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: "full_name".tr(),
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "name_empty".tr();
                        }
                        if (value.trim().split(RegExp(r'\s+')).length < 2) {
                          return "name_min_words".tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _phoneController,
                      label: "phone_number".tr(),
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) return "phone_empty".tr();
                        if (!RegExp(r'^[0-9]+\$').hasMatch(value)) return "phone_invalid".tr();
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _emailController,
                      label: "email".tr(),
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "email_empty".tr();
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "email_invalid".tr();
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildMultilineTextField(
                      controller: _storyController,
                      label: "life_story".tr(),
                      helperText: "story_hint".tr(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "story_empty".tr();
                        }
                        if (value.trim().split(RegExp(r'\s+')).length < 20) {
                          return "story_min_words".tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: _passwordController,
                      label: "password".tr(),
                      obscureText: _obscurePassword,
                      onToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: "confirm_password".tr(),
                      obscureText: _obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "confirm_empty".tr();
                        if (value != _passwordController.text) return "passwords_no_match".tr();
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final newUser = User(
                              name: _nameController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              story: _storyController.text,
                            );
                            widget.onUserRegistered(newUser);
                          }
                        },
                        child: Text("submit_form".tr(), style: const TextStyle(fontSize: 16, color: Colors.white)),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator ?? (value) {
        if (value!.isEmpty) return "password_empty".tr();
        if (value.length < 6) return "password_short".tr();
        return null;
      },
    );
  }

  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        helperText: helperText,
      ),
      validator: validator,
    );
  }
}
