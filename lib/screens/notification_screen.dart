/*
=========================================
Notification Screen

Purpose:
- Display claim notifications.
- Show Accepted / Rejected / Pending.

Viva:
ListView.builder -> Efficient list
Card -> Display notification
=========================================
*/

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Sample Notifications
    final notifications = [

      {
        "title":"Wallet Claim",
        "message":"Your claim is Pending",
        "icon":Icons.access_time,
        "color":Colors.orange,
      },

      {
        "title":"Laptop Claim",
        "message":"Claim Accepted",
        "icon":Icons.check_circle,
        "color":Colors.green,
      },

      {
        "title":"Bag Claim",
        "message":"Claim Rejected",
        "icon":Icons.cancel,
        "color":Colors.red,
      },

    ];

    return Scaffold(

      appBar: AppBar(

        title: const Text("Notifications"),

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

      ),

      body: ListView.builder(

        itemCount: notifications.length,

        itemBuilder: (context,index){

          final notification = notifications[index];

          return Card(

            margin: const EdgeInsets.all(10),

            elevation: 3,

            child: ListTile(

              leading: Icon(

                notification["icon"] as IconData,

                color: notification["color"] as Color,

                size: 35,

              ),

              title: Text(

                notification["title"].toString(),

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                ),

              ),

              subtitle: Text(

                notification["message"].toString(),

              ),

            ),

          );

        },

      ),

    );

  }

}