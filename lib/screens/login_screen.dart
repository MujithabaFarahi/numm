import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/custom_toast.dart';
import 'package:nummlk/widgets/primary_button.dart';
import 'package:nummlk/widgets/primary_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loginWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _navigateToHome(userCredential.user!);
    } catch (e) {
      _showError("Login failed: $e");
    }
  }

  Future<void> _registerWithEmailPassword() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email ?? '',
      });

      await _navigateToHome(userCredential.user!);
    } catch (e) {
      _showError("Registration failed: $e");
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await _navigateToHome(userCredential.user!);
    } catch (e) {
      _showError("Google Sign-In failed: $e");
    }
  }

  Future<void> _navigateToHome(User user) async {
    final userDoc = _firestore.collection('Users').doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'email': user.email ?? '',
      });
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showError("Please enter your email address to reset your password.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      CustomToast.show(
        "Password reset email has been sent. Please check your inbox.",
        bgColor: Colors.green,
      );
    } catch (e) {
      _showError("Password reset failed: $e");
    }
  }

  void _showError(String message) {
    CustomToast.show(
      message,
      bgColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(
                height: 200,
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                      ),
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: ColorPalette.primaryBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 80),
                                PrimaryTextfield(
                                  hintText: "Email",
                                  backgroundColor: ColorPalette.mainBlue[100]!,
                                  borderColor: ColorPalette.white,
                                  controller: _emailController,
                                ),
                                const SizedBox(height: 20),
                                PrimaryTextfield(
                                  hintText: "Password",
                                  backgroundColor: ColorPalette.mainBlue[100]!,
                                  borderColor: ColorPalette.white,
                                  controller: _passwordController,
                                  obscureText: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Column(
                              children: [
                                PrimaryButton(
                                  text: "Log In",
                                  onPressed: _loginWithEmailPassword,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                                const SizedBox(height: 20),
                                PrimaryButton(
                                  text: "Register",
                                  onPressed: _registerWithEmailPassword,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                                const SizedBox(height: 20),
                                PrimaryButton(
                                  text: "Sign in with Google",
                                  icon: 'assets/icons/google.png',
                                  onPressed: _loginWithGoogle,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
