/*
========================================
Report Item Screen

Purpose:
- Report Lost / Found Item
- Pick Image
- Preview Image
- Save Details in Firestore

NOTE:
For demo purposes we DO NOT upload image to
Firebase Storage because Storage requires
additional billing configuration.

We only save item details in Firestore.

========================================
*/

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final contactController = TextEditingController();
  final ownerController = TextEditingController();


  // Dropdown values
  String category = "Mobile";
  String status = "Lost";

  // Selected Image
  XFile? image;

  bool loading = false;

  // Pick Image
  Future<void> pickImage() async {

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  // Save Item
  Future<void> uploadItem() async {

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        locationController.text.isEmpty ||
        ownerController.text.isEmpty ||
        contactController.text.isEmpty ||
        image == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await FirebaseFirestore.instance.collection("items").add({

        "title": titleController.text.trim(),

        "description": descriptionController.text.trim(),

        "location": locationController.text.trim(),
        "ownerName": ownerController.text.trim(),

        "contact": contactController.text.trim(),
        "ownerId": FirebaseAuth.instance.currentUser!.uid,

        "category": category,

        "status": status,

        // Local path only (Demo)
        "imagePath": image!.path,

        "createdAt": Timestamp.now(),

      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item Reported Successfully"),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Report Item"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Item Title",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: ownerController,
              decoration: const InputDecoration(
                labelText: "Owner Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Contact Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),


            DropdownButtonFormField(

              value: category,

              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),

              items: ["Mobile","Wallet","Bag","Others"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),

              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },

            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(

              value: status,

              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),

              items: ["Lost","Found"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),

              onChanged: (value) {
                setState(() {
                  status = value.toString();
                });
              },

            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(

              onPressed: pickImage,

              icon: const Icon(Icons.image),

              label: const Text("Select Image"),

            ),

            const SizedBox(height: 20),

            image == null
                ? const Text("No Image Selected")
                : Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  "Image Selected Successfully",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed: loading ? null : uploadItem,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),

                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Report Item"),

              ),

            ),

          ],

        ),

      ),

    );

  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    ownerController.dispose();
    contactController.dispose();
    super.dispose();
  }
}