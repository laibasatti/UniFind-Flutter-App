/*
=========================================
Screen : Signup Screen

Purpose:
- Create a new account using Firebase Authentication.
- Save user profile in Firestore.
- Navigate to Dashboard after successful signup.

=========================================
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import 'dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  // ==========================
  // Signup Function
  // ==========================
  Future<void> signupUser() async {

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Empty fields
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    // Password match
    if (password != confirmPassword) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      // Create account
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user profile
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({

        "uid": userCredential.user!.uid,
        "name": name,
        "email": email,
        "role": "student",
        "createdAt": Timestamp.now(),

      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created Successfully"),
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

        case "email-already-in-use":
          message = "This email is already registered.";
          break;

        case "weak-password":
          message = "Password should be at least 6 characters.";
          break;

        case "invalid-email":
          message = "Please enter a valid email.";
          break;

        case "operation-not-allowed":
          message = "Email/Password Authentication is disabled.";
          break;

        default:
          message = e.message ?? "Signup Failed";
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

        title: const Text("Create Account"),

        centerTitle: true,

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            children: [

              const SizedBox(height: 40),

              TextField(

                controller: nameController,

                decoration: const InputDecoration(

                  labelText: "Full Name",

                  border: OutlineInputBorder(),

                  prefixIcon: Icon(Icons.person),

                ),

              ),

              const SizedBox(height: 20),

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

              TextField(

                controller: passwordController,

                obscureText: true,

                decoration: const InputDecoration(

                  labelText: "Password",

                  border: OutlineInputBorder(),

                  prefixIcon: Icon(Icons.lock),

                ),

              ),

              const SizedBox(height: 20),

              TextField(

                controller: confirmPasswordController,

                obscureText: true,

                decoration: const InputDecoration(

                  labelText: "Confirm Password",

                  border: OutlineInputBorder(),

                  prefixIcon: Icon(Icons.lock_outline),

                ),

              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed: isLoading ? null : signupUser,

                  style: ElevatedButton.styleFrom(

                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,

                  ),

                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16),
                  ),

                ),

              ),

              const SizedBox(height: 20),

              TextButton(

                onPressed: () {

                  Navigator.pop(context);

                },

                child: const Text(
                  "Already have an account? Login",
                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

  @override
  void dispose() {

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();

  }

}