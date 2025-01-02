import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/custom_alert.dart';
import 'package:nummlk/widgets/custom_toast.dart';
import 'package:nummlk/widgets/select_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      Navigator.pop(context);

      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      CustomToast.show(
        'Failed to log out: $e',
        bgColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'More',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          child: Wrap(
            runSpacing: 12,
            children: [
              SelectCard(
                title: 'My Profile',
                icon: 'assets/icons/user.png',
                onTap: () {
                  // Navigator.of(context).pushNamed('/myprofile');
                },
                isBordered: true,
              ),
              SelectCard(
                title: 'Orders',
                icon: 'assets/icons/order-outline.png',
                onTap: () {
                  Navigator.of(context).pushNamed('/orders');
                },
                isBordered: true,
              ),
              SelectCard(
                title: 'Add Bags',
                icon: 'assets/icons/bag-outline.png',
                onTap: () {
                  Navigator.of(context).pushNamed('/addBag');
                },
                isBordered: true,
              ),
              SelectCard(
                title: 'Add Return',
                icon: 'assets/icons/sync.png',
                onTap: () {
                  Navigator.of(context).pushNamed('/addreturn');
                },
                isBordered: true,
              ),
              SelectCard(
                title: 'Returns',
                icon: 'assets/icons/return.png',
                onTap: () {
                  // Navigator.of(context).pushNamed('/myprofile');
                },
                isBordered: true,
              ),
              SelectCard(
                title: 'Log Out',
                icon: 'assets/icons/logout.png',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlert(
                        iconPath: 'assets/icons/logout.png',
                        title: 'Logout',
                        message:
                            'Are you sure you want to Logout of your account?',
                        onConfirm: () => _logout(context),
                      );
                    },
                  );
                },
                isBordered: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
