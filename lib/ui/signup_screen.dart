import 'package:app/ui/login_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _loading = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // SIGN UP FUNCTION
  // =========================================================

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Utils().toastMessage(
        'Account created successfully',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      String message;

      switch (error.code) {
        case 'weak-password':
          message = 'Password is too weak.';
          break;

        case 'email-already-in-use':
          message = 'An account already exists with this email.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'operation-not-allowed':
          message = 'Email/password authentication is not enabled.';
          break;

        default:
          message = error.message ??
              'Account creation failed. Please try again.';
      }

      Utils().toastMessage(message);
    } catch (error) {
      Utils().toastMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================

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

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // =====================================================
              // BLUE HEADER
              // =====================================================

              Container(
                width: double.infinity,
                height: 290,

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
                  children: [

                    // Decorative circle 1
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

                    // Decorative circle 2
                    Positioned(
                      top: 30,
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

                    // Decorative circle 3
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

                    // =================================================
                    // BACK BUTTON
                    // =================================================

                    Positioned(
                      top: 8,
                      left: 8,

                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    // =================================================
                    // HEADER CONTENT
                    // =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const SizedBox(height: 55),

                          // Logo
                          Container(
                            height: 76,
                            width: 76,

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                              BorderRadius.circular(22),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                  Colors.black.withOpacity(0.18),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),

                            child: const Icon(
                              Icons.person_add_alt_1_rounded,

                              color: AppColors.primary,

                              size: 34,
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Create account',

                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Sign up to get started',

                            style: TextStyle(
                              fontSize: 15,
                              color:
                              Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // SIGN UP CARD
              // =====================================================

              Transform.translate(
                offset: const Offset(0, -20),

                child: Container(
                  width: double.infinity,

                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  padding: const EdgeInsets.fromLTRB(
                    22,
                    28,
                    22,
                    26,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,

                    borderRadius:
                    BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      children: [

                        // =================================================
                        // EMAIL
                        // =================================================

                        TextFormField(
                          controller: _emailController,

                          keyboardType:
                          TextInputType.emailAddress,

                          textInputAction:
                          TextInputAction.next,

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
                                value.trim().isEmpty) {
                              return 'Enter email';
                            }

                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // =================================================
                        // PASSWORD
                        // =================================================

                        TextFormField(
                          controller: _passwordController,

                          obscureText:
                          _obscurePassword,

                          textInputAction:
                          TextInputAction.done,

                          style: const TextStyle(
                            color: AppColors.textDark,
                          ),

                          decoration: _inputDecoration(
                            hint: 'Password',

                            icon:
                            Icons.lock_outline_rounded,

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

                                color:
                                AppColors.textSecondary,

                                size: 21,
                              ),
                            ),
                          ),

                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Enter password';
                            }

                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }

                            return null;
                          },

                          onFieldSubmitted: (_) {
                            if (!_loading) {
                              _signUp();
                            }
                          },
                        ),

                        const SizedBox(height: 26),

                        // =================================================
                        // SIGN UP BUTTON
                        // =================================================

                        SizedBox(
                          width: double.infinity,
                          height: 56,

                          child: ElevatedButton(
                            onPressed:
                            _loading ? null : _signUp,

                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              AppColors.primary,

                              foregroundColor:
                              Colors.white,

                              disabledBackgroundColor:
                              AppColors.primary
                                  .withOpacity(0.6),

                              elevation: 3,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                            ),

                            child: _loading
                                ? const SizedBox(
                              height: 25,
                              width: 25,

                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                                : const Text(
                              'Sign Up',

                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // =====================================================
              // LOGIN PROMPT
              // =====================================================

              Transform.translate(
                offset: const Offset(0, -8),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Text(
                      "Already have an account?",

                      style: TextStyle(
                        color:
                        AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                            const LoginScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        'Login',

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
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}