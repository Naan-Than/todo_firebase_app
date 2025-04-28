import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/utility.dart';
import 'package:todo/view_models/authenticationViewModel.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Color greenColor = const Color(0xFF4ddcd6);

    AuthenticationViewModel authenticationViewModel =
        context.watch<AuthenticationViewModel>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: Colors.red,
              // width: screenWidth * 2,
              height: screenHeight / 2.5,
              child: Stack(
                children: [
                  Container(
                    height: screenHeight * 0.07,
                    width: screenWidth,
                    color: Utility.primaryColor,
                    // color: Colors.purple,
                  ),
                  Positioned(
                    left: -screenWidth * 0.05,
                    top: -screenHeight * 0.033,
                    // bottom: -screenHeight / 5,
                    child: Card(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Utility.primaryColor,
                        // backgroundColor: Colors.purple,
                        radius: 90,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -screenHeight * 0.077,
                    right: -screenHeight * 0.1,
                    child: Card(
                      shape: CircleBorder(),
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: CircleAvatar(
                        backgroundColor: Utility.primaryColor,
                        radius: 180,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight / 2.6,
              width: screenWidth,
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              color: Utility.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(thickness: 1, color: Utility.primaryColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Utility.customTextField(
                      context: context,
                      controller: authenticationViewModel.nameController,
                      label: 'Name',
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    Utility.customTextField(
                      context: context,
                      controller: authenticationViewModel.emailController,
                      label: 'Email',
                      prefixIcon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    Utility.customTextField(
                      context: context,
                      controller: authenticationViewModel.passwordController,
                      label: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: authenticationViewModel.isHiddenPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          authenticationViewModel.isHiddenPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Utility.primaryColor,
                        ),
                        onPressed: () {
                          authenticationViewModel.togglePasswordVisibility();
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                        // print('press');
                      },
                      child: Text(
                        "Already have an account!",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            // padding: EdgeInsets
                            //     .zero, // Ensure the button size matches the container
                            backgroundColor: Utility.primaryColor,
                            elevation: 10,
                          ),
                          onPressed: () async {
                            print('press');
                            await authenticationViewModel.register(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:authenticationViewModel.isLoading
                                ? const Center(child: CircularProgressIndicator(color: Colors.white,
                              constraints: BoxConstraints(minHeight: 20,minWidth: 20),))
                                :  Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        width: screenWidth,
        height: screenHeight / 6,
        child: Stack(
          children: [
            Container(
              height: 20,
              width: screenWidth,
              // color: Utility.primaryColor,
              // color: Colors.purple,
            ),
            Positioned(
              left: -screenWidth * 0.05,
              bottom: -screenHeight * 0.035,
              // bottom: -screenHeight / 5,
              child: Card(
                elevation: 10,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Utility.primaryColor,
                  // backgroundColor: Colors.purple,
                  radius: 70,
                ),
              ),
            ),
            Positioned(
              // top: screenHeight * 0.04,
              left: screenHeight * 0.12,
              child: Card(
                shape: CircleBorder(),
                elevation: 5,
                shadowColor: Colors.black,
                child: CircleAvatar(
                  backgroundColor: Utility.primaryColor,
                  radius: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
