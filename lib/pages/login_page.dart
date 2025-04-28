import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utility.dart';
import '../view_models/authenticationViewModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              height: screenHeight / 2.4,
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
              height: screenHeight / 2.7,
              width: screenWidth,

              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
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
                    SizedBox(height: 10),
                    Container(
                      width: Utility.getWidth(context) / 1.33,
                      child: TextFormField(
                        controller: authenticationViewModel.emailController,
                        validator: (mail) {
                          if (mail!.isEmpty) {
                            return "Please Enter email";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Utility.primaryColor,
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Utility.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: Utility.getWidth(context) / 1.33,
                      child: TextFormField(
                        controller: authenticationViewModel.passwordController,
                        validator: (pass) {
                          if (pass!.isEmpty) {
                            return "Please Enter password";
                          } else if (pass.length < 6) {
                            return "Password must be at least 6 characters long";
                          } else {
                            return null;
                          }
                        },
                        obscureText: authenticationViewModel.isHiddenPassword,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),

                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Utility.primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authenticationViewModel.isHiddenPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Utility.primaryColor,
                            ),
                            onPressed: () {
                              authenticationViewModel
                                  .togglePasswordVisibility();
                            },
                          ),

                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Utility.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                        // Navigator.pushNamed(context, "/home");
                        // print('press');
                      },
                      child: Text(
                        "Create a new account",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 10),
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
                            await authenticationViewModel.login(context);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context)=>MyHomePage()));
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
