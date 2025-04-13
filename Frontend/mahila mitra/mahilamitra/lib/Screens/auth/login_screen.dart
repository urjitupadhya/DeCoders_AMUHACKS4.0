import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:mahilamitra/widgets/custom_text_field.dart';
import 'package:mahilamitra/widgets/primary_button.dart';
import 'package:mahilamitra/Screens/home/home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful! 🚀")),
        );
       // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
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
            opacity: 0.1, // Low opacity for background effect
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
                      // Title
                      Text(
                        "Welcome Back! 👋",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Login to continue",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 24),

                      // Email Field
                      CustomTextField(
                        controller: emailController,
                        labelText: "Email",
                        hintText: "Enter your email",
                        icon: Icons.email,
                        validator: (value) =>
                            value!.isEmpty ? "Enter a valid email" : null,
                      ),
                      SizedBox(height: 12),

                      // Password Field
                      CustomTextField(
                        controller: passwordController,
                        labelText: "Password",
                        hintText: "Enter your password",
                        icon: Icons.lock,
                        isPassword: true,
                        validator: (value) => value!.length < 6
                            ? "Password must be at least 6 characters"
                            : null,
                      ),
                      SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Add Forgot Password Navigation
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.pinkAccent),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Login Button
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : PrimaryButton(
                              text: "Login",
                              onPressed: _login,
                            ),

                      SizedBox(height: 20),

                      // Navigate to SignUp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => SignupScreen()),
                              );
                            },
                            child: Text(
                              "Sign Up",
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
