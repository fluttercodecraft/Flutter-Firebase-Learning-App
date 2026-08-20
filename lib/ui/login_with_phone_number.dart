import 'package:app/ui/auth/verify_code.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            builder: (context) => VerifyCodeScreen(verificationId: verificationId),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Login with Phone')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+1 234 3455 234',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 50),
            RoundButton(
              title: 'Send Verification Code',
              loading: _loading,
              onTap: _verifyPhone,
            ),
          ],
        ),
      ),
    );
  }
}