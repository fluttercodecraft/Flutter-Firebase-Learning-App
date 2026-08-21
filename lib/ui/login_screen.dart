import 'package:app/ui/fogot_password.dart';
import 'package:app/ui/login_with_phone_number.dart';
import 'package:app/ui/post_screen.dart';
import 'package:app/ui/signup_screen.dart';
import 'package:app/widgets/round_button.dart';
import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Shared design tokens — reuse these constants across all redesigned pages
// to keep the app visually consistent.
class AppColors {
  static const Color primary = Colors.blue;
  static const Color primaryDark = Color(0xff1355D6);
  static const Color background = Color(0xffF5F7FB);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xff1A1D29);
  static const Color textSecondary = Color(0xff8A8D9F);
  static const Color inputFill = Color(0xffF0F3F9);
  static const Color border = Color(0xffE3E7EF);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PostScreen(),
        ),
      );
    } catch (error) {
      Utils().toastMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 15,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.textSecondary,
        size: 22,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.6,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SizedBox.expand(
          child: Stack(
            children: [
              // -----------------------------------------------------------
              // Gradient Header
              // -----------------------------------------------------------
              Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primary,
                    ],
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -60,
                      right: -50,
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: -60,
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      right: 60,
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.07),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // -----------------------------------------------------------
              // Main Content
              // -----------------------------------------------------------
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        // -------------------------------------------------
                        // Logo
                        // -------------------------------------------------
                        Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // -------------------------------------------------
                        // Welcome Text
                        // -------------------------------------------------
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Login to continue where you left off',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),

                        const SizedBox(height: 26),

                        // -------------------------------------------------
                        // Form Card
                        // -------------------------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(
                            22,
                            28,
                            22,
                            24,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // -------------------------------------------------
                              // Form
                              // -------------------------------------------------
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Email
                                    TextFormField(
                                      keyboardType:
                                      TextInputType.emailAddress,
                                      controller: _emailController,
                                      style: const TextStyle(
                                        color: AppColors.textDark,
                                      ),
                                      decoration: _inputDecoration(
                                        hint: 'Email',
                                        icon:
                                        Icons.alternate_email,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'Enter email';
                                        }

                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 16),

                                    // Password
                                    TextFormField(
                                      controller:
                                      _passwordController,
                                      obscureText:
                                      _obscurePassword,
                                      style: const TextStyle(
                                        color: AppColors.textDark,
                                      ),
                                      decoration: _inputDecoration(
                                        hint: 'Password',
                                        icon: Icons
                                            .lock_outline_rounded,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                              !_obscurePassword;
                                            });
                                          },
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons
                                                .visibility_off_outlined
                                                : Icons
                                                .visibility_outlined,
                                            color: AppColors
                                                .textSecondary,
                                            size: 21,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'Enter password';
                                        }

                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // -------------------------------------------------
                              // Forgot Password
                              // -------------------------------------------------
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding:
                                    const EdgeInsets.only(
                                      top: 8,
                                    ),
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight:
                                      FontWeight.w600,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // -------------------------------------------------
                              // Login Button
                              // -------------------------------------------------
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: RoundButton(
                                  title: 'Login',
                                  loading: _loading,
                                  onTap: _login,
                                ),
                              ),

                              const SizedBox(height: 22),

                              // -------------------------------------------------
                              // Sign Up
                              // -------------------------------------------------
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color:
                                      AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      minimumSize:
                                      const Size(0, 0),
                                      tapTargetSize:
                                      MaterialTapTargetSize
                                          .shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color:
                                        AppColors.primary,
                                        fontWeight:
                                        FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // -------------------------------------------------
                              // OR Divider
                              // -------------------------------------------------
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.border,
                                      thickness: 1,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                    EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: AppColors
                                            .textSecondary,
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.border,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // -------------------------------------------------
                              // Phone Login
                              // -------------------------------------------------
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const LoginWithPhoneNumber(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.phone_outlined,
                                    color:
                                    AppColors.primary,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Login with phone',
                                    style: TextStyle(
                                      color:
                                      AppColors.primary,
                                      fontWeight:
                                      FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  style:
                                  OutlinedButton.styleFrom(
                                    backgroundColor:
                                    AppColors.cardBackground,
                                    side: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),

                        // Bottom spacing
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}