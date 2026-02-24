import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    print(
      '🟢 [LOGIN] Toggling mode from ${_isLogin ? "Login" : "Sign Up"} to ${!_isLogin ? "Login" : "Sign Up"}',
    );
    setState(() {
      _isLogin = !_isLogin;
      // Clear validation errors when switching modes
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleSubmit() async {
    print('🟢 [LOGIN] Submit button pressed');
    print('🟢 [LOGIN] Mode: ${_isLogin ? "Login" : "Sign Up"}');

    // Validate form
    if (!_formKey.currentState!.validate()) {
      print('⚠️ [LOGIN] Form validation failed');
      return;
    }
    print('✅ [LOGIN] Form validation passed');

    // Check password match for signup
    if (!_isLogin &&
        _passwordController.text != _confirmPasswordController.text) {
      print('❌ [LOGIN] Passwords do not match');
      _showErrorDialog('Passwords do not match');
      return;
    }

    print('🟢 [LOGIN] Email: ${_emailController.text.trim()}');
    print('🟢 [LOGIN] Password length: ${_passwordController.text.length}');

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        print('🟢 [LOGIN] Attempting login...');
        // Login
        await _authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        print('✅ [LOGIN] Login completed successfully');
      } else {
        print('🟢 [LOGIN] Attempting registration...');
        // Register
        await _authService.register(
          _emailController.text.trim(),
          _passwordController.text,
        );
        print('✅ [LOGIN] Registration completed successfully');
      }

      // Navigate to home screen on success
      if (mounted) {
        print('🟢 [LOGIN] Navigating to home screen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print('❌ [LOGIN] Error occurred: $e');
      if (mounted) {
        _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('🟢 [LOGIN] Loading state cleared');
      }
    }
  }

  void _showErrorDialog(String message) {
    print('❌ [LOGIN] Showing error dialog: $message');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Error',
          style: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.sora(fontSize: 14, color: const Color(0xFFA9A9A9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFC67C4E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Coffee icon/logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC67C4E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.coffee,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Welcome text
                  Center(
                    child: Text(
                      _isLogin ? 'Welcome Back!' : 'Create Account',
                      style: GoogleFonts.sora(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      _isLogin
                          ? 'Sign in to continue your coffee journey'
                          : 'Join us for the best coffee experience',
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFA9A9A9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email field
                  _buildInputField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password field
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: _isLogin
                        ? 'Enter your password'
                        : 'Min 8 chars, 1 upper, 1 lower, 1 digit',
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!_isLogin) {
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!value.contains(RegExp(r'[A-Z]'))) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!value.contains(RegExp(r'[a-z]'))) {
                          return 'Password must contain at least one lowercase letter';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Password must contain at least one digit';
                        }
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFFA9A9A9),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  // Password requirements hint (only for sign up)
                  if (!_isLogin) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        'Password must contain:\n• At least 8 characters\n• One uppercase letter (A-Z)\n• One lowercase letter (a-z)\n• One digit (0-9)',
                        style: GoogleFonts.sora(
                          fontSize: 11,
                          color: const Color(0xFF7D7D7D),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                  // Confirm password field (only for sign up)
                  if (!_isLogin) ...[
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      icon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFFA9A9A9),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ],
                  // Forgot password (only for login)
                  if (_isLogin) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFC67C4E),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC67C4E),
                        disabledBackgroundColor: const Color(0xFF8D6A4E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isLogin ? 'Sign In' : 'Sign Up',
                              style: GoogleFonts.sora(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Divider with "OR"
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFF2A2A2A),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFA9A9A9),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFF2A2A2A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Social login buttons
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    label: 'Continue with Google',
                    onPressed: () {
                      // TODO: Implement Google sign in
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                    icon: Icons.facebook,
                    label: 'Continue with Facebook',
                    onPressed: () {
                      // TODO: Implement Facebook sign in
                    },
                  ),
                  const SizedBox(height: 32),
                  // Toggle between login and sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? "Don't have an account? "
                            : 'Already have an account? ',
                        style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFA9A9A9),
                        ),
                      ),
                      TextButton(
                        onPressed: _toggleMode,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          _isLogin ? 'Sign Up' : 'Sign In',
                          style: GoogleFonts.sora(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFC67C4E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.sora(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.sora(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.sora(
              fontSize: 14,
              color: const Color(0xFFA9A9A9),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFFA9A9A9), size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            errorStyle: GoogleFonts.sora(fontSize: 12, color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF2A2A2A), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
