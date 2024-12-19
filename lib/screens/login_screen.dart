import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/primary_button.dart';
import 'package:nummlk/widgets/primary_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      color: ColorPalette.primaryBlue,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        height: 100,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DraggableScrollableSheet(
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
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.41,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 80),
                                    PrimaryTextfield(
                                      hintText: "Name",
                                      backgroundColor:
                                          ColorPalette.mainBlue[100]!,
                                      borderColor: ColorPalette.white,
                                    ),
                                    const SizedBox(height: 20),
                                    PrimaryTextfield(
                                      hintText: "Password",
                                      backgroundColor:
                                          ColorPalette.mainBlue[100]!,
                                      borderColor: ColorPalette.white,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    PrimaryButton(
                                      text: "Log In",
                                      onPressed: () {},
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                    const SizedBox(height: 20),
                                    PrimaryButton(
                                      text: "Sign in with Google",
                                      onPressed: () {},
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
