import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:mahilamitra/widgets/custom_text_field.dart';
import 'package:mahilamitra/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void _signup() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup Successful! 🎉")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background logo with opacity
          Opacity(
            opacity: 0.1, // Adjust opacity here
            child: Center(
              child: Image.asset(
                "assets/images/logo.jpg",
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Foreground content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Text(
                        "Create an Account 🎉",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Join us and stay safe!",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 24),

                      // Email
                      CustomTextField(
                        controller: emailController,
                        labelText: "Email",
                        hintText: "Enter your email",
                        icon: Icons.email,
                        validator: (value) =>
                            value!.isEmpty ? "Enter a valid email" : null,
                      ),
                      SizedBox(height: 12),

                      // Password
                      CustomTextField(
                        controller: passwordController,
                        labelText: "Password",
                        hintText: "Enter your password",
                        icon: Icons.lock,
                        isPassword: true,
                        validator: (value) =>
                            value!.length < 6 ? "Minimum 6 characters" : null,
                      ),
                      SizedBox(height: 12),

                      // Confirm Password
                      CustomTextField(
                        controller: confirmPasswordController,
                        labelText: "Confirm Password",
                        hintText: "Re-enter your password",
                        icon: Icons.lock,
                        isPassword: true,
                        validator: (value) => value != passwordController.text
                            ? "Passwords do not match!"
                            : null,
                      ),
                      SizedBox(height: 24),

                      // Button
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : PrimaryButton(
                              text: "Sign Up",
                              onPressed: _signup,
                            ),
                      SizedBox(height: 16),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => LoginScreen()),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.pinkAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
