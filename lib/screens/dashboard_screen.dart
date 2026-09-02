/*
========================================
Dashboard Screen

Purpose:
- Display all Lost & Found items.
- Read data from Firestore.
- Search items.
- Open Report Screen.
- Open Details Screen.

========================================
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'item_details_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'report_item_screen.dart';
import 'claim_request_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final TextEditingController searchController = TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        title: const Text("UniFind"),

        centerTitle: true,

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

        actions: [

          // Claim Requests
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClaimRequestsScreen(),
                ),
              );
            },
          ),

          // Notifications
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),

          // Profile
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),

        ],

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: AppColors.primary,

        child: const Icon(Icons.add,color: Colors.white),

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (context)=>const ReportItemScreen(),

            ),

          );

        },

      ),

      body: Padding(

        padding: const EdgeInsets.all(15),

        child: Column(

          children: [

            TextField(

              controller: searchController,

              onChanged: (value){

                setState(() {

                  searchText=value.toLowerCase();

                });

              },

              decoration: InputDecoration(

                hintText: "Search Item",

                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(12),

                ),

              ),

            ),

            const SizedBox(height:20),

            Expanded(

              child: StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore.instance
                    .collection("items")
                    .snapshots(),

                builder: (context,snapshot){

                  if(snapshot.connectionState==ConnectionState.waiting){

                    return const Center(
                      child:CircularProgressIndicator(),
                    );

                  }

                  if(!snapshot.hasData || snapshot.data!.docs.isEmpty){

                    return const Center(
                      child: Text("No Items Found"),
                    );

                  }

                  final items = snapshot.data!.docs;

                  final filteredItems = items.where((doc){

                    final data = doc.data() as Map<String,dynamic>;

                    return data["title"]
                        .toString()
                        .toLowerCase()
                        .contains(searchText);

                  }).toList();

                  return ListView.builder(

                    itemCount: filteredItems.length,

                    itemBuilder:(context,index){

                      final item = filteredItems[index];

                      final data = item.data() as Map<String,dynamic>;

                      return Card(

                        elevation:3,

                        margin: const EdgeInsets.only(bottom:12),

                        child: ListTile(

                          // Since Firebase Storage is removed,
                          // show default image icon.

                          leading: const CircleAvatar(

                            radius:30,

                            child: Icon(Icons.image),

                          ),

                          title: Text(

                            data["title"],

                            style: const TextStyle(

                              fontWeight: FontWeight.bold,

                            ),

                          ),

                          subtitle: Text(

                            "${data["category"]}\nStatus : ${data["status"]}",

                          ),

                          trailing: const Icon(

                            Icons.arrow_forward_ios,

                          ),

                          onTap: (){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(context)=>ItemDetailsScreen(

                                  itemId:item.id,

                                  itemData:data,

                                ),

                              ),

                            );

                          },

                        ),

                      );

                    },

                  );

                },

              ),

            ),

          ],

        ),

      ),

    );

  }

  @override
  void dispose(){

    searchController.dispose();

    super.dispose();

  }

}