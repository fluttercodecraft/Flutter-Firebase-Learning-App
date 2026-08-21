import 'package:app/ui/verify_code.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Shared design tokens — kept identical to the other redesigned screens
// so the whole app stays visually consistent.
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

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool _loading = false;
  final _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _verifyPhone() {
    if (_phoneController.text.trim().isEmpty) return;

    setState(() => _loading = true);

    _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (_) {
        if (mounted) setState(() => _loading = false);
      },
      verificationFailed: (e) {
        if (mounted) setState(() => _loading = false);
        Utils().toastMessage(e.message ?? e.toString());
      },
      codeSent: (String verificationId, int? token) {
        if (!mounted) return;
        setState(() => _loading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerifyCodeScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (e) {
        if (mounted) setState(() => _loading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Shrink the gradient header when the keyboard is open so the form
    // never gets pushed off-screen.
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final headerHeight = keyboardOpen ? 130.0 : 240.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: SizedBox.expand(
          child: Stack(
            children: [
              // Gradient hero header with decorative circles
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: headerHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -60,
                      right: -50,
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -40,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Back button, floating on the gradient
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 44),

                      // Logo / brand mark
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
                          Icons.phone_iphone_rounded,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Verify your phone',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        "We'll send a verification code by SMS",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Floating form card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phone number',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                color: AppColors.textDark,
                              ),
                              decoration: InputDecoration(
                                hintText: '+1 234 3455 234',
                                hintStyle: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                ),
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: AppColors.textSecondary,
                                  size: 22,
                                ),
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
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Include your country code, e.g. +1',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 26),

                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: RoundButton(
                                title: 'Send Verification Code',
                                loading: _loading,
                                onTap: _verifyPhone,
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
            ],
          ),
        ),
      ),
    );
  }
}