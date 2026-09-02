import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClaimRequestsScreen extends StatelessWidget {
  const ClaimRequestsScreen({super.key});

  Future<void> updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection("claims")
        .doc(docId)
        .update({
      "status": status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Claim Requests"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("claims")
              .where(
            "ownerId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,)
              .snapshots(),
        builder: (context, snapshot) {

          print("CURRENT USER UID:");
          print(FirebaseAuth.instance.currentUser?.uid);

          print("CLAIMS COUNT:");
          print(snapshot.data?.docs.length);

          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              print(doc.data());
            }
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Claim Requests",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final claims = snapshot.data!.docs;

          // your ListView.builder comes here


          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: claims.length,

            itemBuilder: (context, index) {

              final claim = claims[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 3,

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Item : ${claim["itemTitle"] ?? ""}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Claimed By : ${claim["claimerName"] ?? ""}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Contact : ${claim["claimerContact"] ?? ""}",
                      ),

                      const Divider(),

                      Text("Color : ${claim["color"]}"),

                      Text("Unique Marks : ${claim["marks"]}"),

                      Text("Details : ${claim["details"]}"),

                      const SizedBox(height: 10),

                      Text(
                        "Status : ${claim["status"]}",
                        style: TextStyle(
                          color: claim["status"] == "Pending"
                              ? Colors.orange
                              : claim["status"] == "Accepted"
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),

                              onPressed: () async {

                                await updateStatus(
                                  claim.id,
                                  "Accepted",
                                );

                              },

                              child: const Text("Accept"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),

                              onPressed: () async {

                                await updateStatus(
                                  claim.id,
                                  "Rejected",
                                );

                              },

                              child: const Text("Reject"),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}