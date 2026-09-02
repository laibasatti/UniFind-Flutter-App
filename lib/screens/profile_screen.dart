/*
=========================================
Profile Screen

Purpose:
- Show logged-in user's email.
- Logout from Firebase.
- Return to Login Screen.

Viva:
FirebaseAuth.currentUser -> Current User
signOut() -> Logout
CircleAvatar -> Profile Picture
=========================================
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Current Logged-in User
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(

        title: const Text("Profile"),

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height:20),

            // Profile Avatar
            const CircleAvatar(

              radius: 50,

              backgroundColor: AppColors.primary,

              child: Icon(

                Icons.person,

                size: 60,

                color: Colors.white,

              ),

            ),

            const SizedBox(height:20),

            // User Email
            Text(

              user?.email ?? "No Email",

              style: const TextStyle(

                fontSize:20,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height:40),

            ListTile(

              leading: const Icon(Icons.email),

              title: const Text("Email"),

              subtitle: Text(user?.email ?? ""),

            ),

            const Divider(),

            ListTile(

              leading: const Icon(Icons.logout,color: Colors.red),

              title: const Text("Logout"),

              onTap: () async {

                await FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (context)=>const LoginScreen(),

                  ),

                );

              },

            ),

          ],

        ),

      ),

    );

  }

}