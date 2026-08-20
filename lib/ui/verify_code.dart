
import 'package:app/ui/post_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool _loading = false;
  final _verificationCodeController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final smsCode = _verificationCodeController.text.trim();
    if (smsCode.isEmpty) {
      Utils().toastMessage('Please enter verification code');
      return;
    }

    setState(() => _loading = true);

    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PostScreen()),
            (route) => false,
      );
    } catch (e) {
      Utils().toastMessage(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            TextFormField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '6-digit code',
                prefixIcon: Icon(Icons.security),
              ),
            ),
            const SizedBox(height: 50),
            RoundButton(
              title: 'Verify',
              loading: _loading,
              onTap: _verifyCode,
            ),
          ],
        ),
      ),
    );
  }
}