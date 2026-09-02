/*
=========================================
Screen : Login Screen

Purpose:
- Login user using Firebase Authentication.
- If login succeeds -> Dashboard.
- If login fails -> Show proper error.

Firebase:
FirebaseAuth.signInWithEmailAndPassword()

=========================================
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  // ===========================
  // Login Function
  // ===========================
  Future<void> loginUser() async {

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Check Empty Fields
    if (email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      // Login from Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );

    }

    on FirebaseAuthException catch (e) {

      String message;

      switch (e.code) {

        case "invalid-credential":
          message = "Incorrect email or password.";
          break;

        case "user-not-found":
          message = "No account found with this email.";
          break;

        case "wrong-password":
          message = "Incorrect password.";
          break;

        case "invalid-email":
          message = "Invalid email format.";
          break;

        case "too-many-requests":
          message = "Too many attempts. Try again later.";
          break;

        default:
          message = e.message ?? "Login Failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }

    finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        title: const Text("Login"),

        centerTitle: true,

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // Email
            TextField(

              controller: emailController,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(

                labelText: "Email",

                border: OutlineInputBorder(),

                prefixIcon: Icon(Icons.email),

              ),

            ),

            const SizedBox(height: 20),

            // Password
            TextField(

              controller: passwordController,

              obscureText: true,

              decoration: const InputDecoration(

                labelText: "Password",

                border: OutlineInputBorder(),

                prefixIcon: Icon(Icons.lock),

              ),

            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                onPressed: isLoading ? null : loginUser,

                style: ElevatedButton.styleFrom(

                  backgroundColor: AppColors.primary,

                  foregroundColor: Colors.white,

                ),

                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),

              ),

            ),

            const SizedBox(height: 15),

            TextButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => const SignupScreen(),

                  ),

                );

              },

              child: const Text(
                "Don't have an account? Sign Up",
              ),

            ),

          ],

        ),

      ),

    );

  }

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();

  }

}