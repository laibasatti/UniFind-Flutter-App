/*
=========================================
Claim Verification Screen

Purpose:
- User claims an item.
- Fill verification form.
- Save answers in Firestore.

Viva:
Form -> Validate input
TextEditingController -> Read answers
Firestore add() -> Save claim
=========================================
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';

class ClaimVerificationScreen extends StatefulWidget {

  final String itemId;

  const ClaimVerificationScreen({

    super.key,

    required this.itemId,

  });

  @override
  State<ClaimVerificationScreen> createState() =>
      _ClaimVerificationScreenState();
}

class _ClaimVerificationScreenState
    extends State<ClaimVerificationScreen> {

  final _formKey = GlobalKey<FormState>();

  final colorController = TextEditingController();

  final marksController = TextEditingController();

  final detailsController = TextEditingController();
  final claimantNameController = TextEditingController();
  final claimantPhoneController = TextEditingController();




  bool loading = false;

  // Submit Claim
  // Submit Claim
  Future<void> submitClaim() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      // Get item details
      DocumentSnapshot itemDoc = await FirebaseFirestore.instance
          .collection("items")
          .doc(widget.itemId)
          .get();

      Map<String, dynamic> item = itemDoc.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance
          .collection("claims")
          .add({

        "itemId": widget.itemId,
        "itemTitle": item["title"],
        "ownerName": item["ownerName"],
        "ownerContact": item["contact"],
        "ownerId": item["ownerId"],

        // Person claiming the item
        "claimerName": claimantNameController.text.trim(),
        "claimerContact": claimantPhoneController.text.trim(),

        // Verification Answers
        "color": colorController.text.trim(),
        "marks": marksController.text.trim(),
        "details": detailsController.text.trim(),

        "status": "Pending",
        "createdAt": Timestamp.now(),

      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Claim Submitted Successfully"),
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

        title: const Text("Claim Verification"),

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              // Claimant Name
              TextFormField(
                controller: claimantNameController,
                decoration: const InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Your Name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Claimant Contact
              TextFormField(
                controller: claimantPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Your Contact Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Contact Number";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Item Color
              TextFormField(

                controller: colorController,


                decoration: const InputDecoration(

                  labelText: "Item Color",

                  border: OutlineInputBorder(),

                ),

                validator: (value){

                  if(value==null || value.isEmpty){

                    return "Enter Item Color";

                  }

                  return null;

                },

              ),

              const SizedBox(height:15),

              TextFormField(

                controller: marksController,

                decoration: const InputDecoration(

                  labelText: "Unique Marks / Stickers",

                  border: OutlineInputBorder(),

                ),

                validator: (value){

                  if(value==null || value.isEmpty){

                    return "Enter Unique Marks";

                  }

                  return null;

                },

              ),

              const SizedBox(height:15),

              TextFormField(

                controller: detailsController,

                maxLines:3,

                decoration: const InputDecoration(

                  labelText: "Additional Details",

                  border: OutlineInputBorder(),

                ),

                validator: (value){

                  if(value==null || value.isEmpty){

                    return "Enter Details";

                  }

                  return null;

                },

              ),

              const SizedBox(height:30),

              SizedBox(

                width: double.infinity,

                height:50,

                child: ElevatedButton(

                  onPressed: loading ? null : submitClaim,

                  style: ElevatedButton.styleFrom(

                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,

                  ),

                  child: loading

                      ? const CircularProgressIndicator(

                    color: Colors.white,

                  )

                      : const Text("Submit Claim"),

                ),

              )

            ],

          ),

        ),

      ),

    );

  }

  @override
  void dispose() {

    colorController.dispose();

    marksController.dispose();

    detailsController.dispose();
    claimantNameController.dispose();
    claimantPhoneController.dispose();

    super.dispose();

  }

}