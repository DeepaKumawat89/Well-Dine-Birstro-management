// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserAttendance extends StatefulWidget {
//   @override
//   State<UserAttendance> createState() => _UserAttendanceState();
// }
//
// class _UserAttendanceState extends State<UserAttendance> {
//   late String? currentUserEmail;
//
//   @override
//   void initState() {
//     super.initState();
//     // Assuming you have a way to get the current user's email
//     FirebaseAuth auth=FirebaseAuth.instance;
//     User? user=auth.currentUser;
//     currentUserEmail = user!.email; // Replace this with your method to get current user's email
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User Attendance"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(currentUserEmail)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
//           if (userSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (userSnapshot.hasError) {
//             return Center(child: Text('Error: ${userSnapshot.error}'));
//           } else if (!userSnapshot.hasData) {
//             return Center(child: Text('No data available'));
//           }
//
//           final ownerEmail = userSnapshot.data!['messName'];
//
//           return StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("messOwner")
//                 .doc(ownerEmail)
//                 .collection("attendance")
//                 .snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> attendanceSnapshot) {
//               if (attendanceSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (attendanceSnapshot.hasError) {
//                 return Center(child: Text('Error: ${attendanceSnapshot.error}'));
//               } else if (attendanceSnapshot.data!.docs.isEmpty) {
//                 return Center(child: Text('No attendance data available'));
//               }
//
//               final List<DocumentSnapshot> dates = attendanceSnapshot.data!.docs;
//
//               return ListView.builder(
//                 itemCount: dates.length,
//                 itemBuilder: (context, index) {
//                   final date = dates[index].id;
//                   final users = dates[index].data() as Map<String, dynamic>;
//                   // Check if the current user's email is present under the date
//                   final presence = users.containsKey(currentUserEmail) ? "Present" : "Absent";
//
//                   return ListTile(
//                     title: Text(date),
//                     trailing: Text(presence),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAttendance extends StatefulWidget {
  @override
  State<UserAttendance> createState() => _UserAttendanceState();
}

class _UserAttendanceState extends State<UserAttendance> {
  late String? currentUserEmail;
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    // Assuming you have a way to get the current user's email
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    currentUserEmail = user!.email; // Replace this with your method to get current user's email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(" Attendance"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 55,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUserEmail)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else if (!userSnapshot.hasData) {
                  return Center(child: Text('No data available'));
                }

                final ownerEmail = userSnapshot.data!['messName'];

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("messOwner")
                      .doc(ownerEmail)
                      .collection("attendance")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> attendanceSnapshot) {
                    if (attendanceSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (attendanceSnapshot.hasError) {
                      return Center(child: Text('Error: ${attendanceSnapshot.error}'));
                    } else if (attendanceSnapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No attendance data available'));
                    }

                    List<DocumentSnapshot> dates = attendanceSnapshot.data!.docs;

                    // Filter the list based on search text
                    dates = dates.where((doc) => doc.id.toLowerCase().contains(_searchText)).toList();

                    // Sort the list by date in descending order
                    dates.sort((a, b) => _compareDatesDescending(a.id, b.id));

                    return ListView.builder(
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final date = dates[index].id;
                        final users = dates[index].data() as Map<String, dynamic>;
                        // Check if the current user's email is present under the date
                        final presence = users.containsKey(currentUserEmail) ? "Present" : "Absent";

                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(date, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            trailing: Text(
                              presence,
                              style: TextStyle(
                                fontSize: 15,
                                color: presence == "Present" ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Compare two date strings in descending order (recent to old)
  int _compareDatesDescending(String date1, String date2) {
    List<int> dateList1 = date1.split('-').map(int.parse).toList();
    List<int> dateList2 = date2.split('-').map(int.parse).toList();

    // Compare years
    if (dateList1[2] != dateList2[2]) {
      return dateList2[2].compareTo(dateList1[2]);
    }
    // Compare months
    else if (dateList1[1] != dateList2[1]) {
      return dateList2[1].compareTo(dateList1[1]);
    }
    // Compare days
    else {
      return dateList2[0].compareTo(dateList1[0]);
    }
  }
}



