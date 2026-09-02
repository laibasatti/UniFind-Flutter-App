/*
=========================================
Item Details Screen

Purpose:
- Show complete item information.
- Show placeholder image.
- Show owner details.
- Show contact number.
- Navigate to Claim Screen.

=========================================
*/

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'claim_verification_screen.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;
  final Map<String, dynamic> itemData;

  const ItemDetailsScreen({
    super.key,
    required this.itemId,
    required this.itemData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Placeholder Image
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),

              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 90,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Title
            Text(
              itemData["title"] ?? "",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Category
            Row(
              children: [
                const Icon(Icons.category,
                    color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Category : ${itemData["category"] ?? ""}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Status
            Row(
              children: [
                const Icon(Icons.info,
                    color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Status : ${itemData["status"] ?? ""}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Location : ${itemData["location"] ?? ""}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Owner Name
            Row(
              children: [
                const Icon(Icons.person,
                    color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Owner : ${itemData["ownerName"] ?? "Not Available"}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Contact Number
            Row(
              children: [
                const Icon(Icons.phone,
                    color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Contact : ${itemData["contact"] ?? "Not Available"}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              itemData["description"] ?? "",
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClaimVerificationScreen(
                        itemId: itemId,
                      ),
                    ),
                  );
                },

                child: const Text(
                  "This is Mine",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}