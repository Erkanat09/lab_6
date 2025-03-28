import 'package:flutter/material.dart';
import 'package:registration_app/model/user.dart';
import 'user_info_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

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
        title: const Text('Register Form'),
        backgroundColor: Colors.blue,
        centerTitle: true,
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
                      label: "Full Name *",
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty ? "Имя не может быть пустым" : null,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number *",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) return "Номер телефона не может быть пустым";
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Разрешены только цифры.";
                        return null;
                      },
                      helperText: "Phone format: (XXX) XXX-XXXX",
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    _buildMultilineTextField(
                      controller: _storyController,
                      label: "История жизни",
                      helperText: "Будьте кратки, это всего лишь демо.",
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: _passwordController,
                      label: "Password *",
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
                      label: "Confirm Password *",
                      obscureText: _obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "Подтвердите пароль";
                        if (value != _passwordController.text) return "Пароли не совпадают";
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserInfoPage(userInfo: newUser),
                              ),
                            );
                          }
                        },
                        child: const Text("Submit Form", style: TextStyle(fontSize: 16, color: Colors.white)),
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
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        helperText: helperText,
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
        if (value!.isEmpty) return "Пароль не может быть пустым";
        if (value.length < 6) return "Пароль должен быть длиной не менее 6 символов.";
        return null;
      },
    );
  }

  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String label,
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
    );
  }
}
