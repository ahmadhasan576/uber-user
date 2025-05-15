// import 'package:flutter/material.dart';
// import 'package:user_app/global/global.dart'; // استيراد البيانات العالمية
// import 'package:user_app/authentication/login_screen.dart';

// class ProfileTabPage extends StatefulWidget {
//   const ProfileTabPage({super.key});

//   @override
//   State<ProfileTabPage> createState() => _ProfileTabPageState();
// }

// class _ProfileTabPageState extends State<ProfileTabPage> {
//   // استخراج بيانات المستخدم من النموذج العالمي
//   String? userName = currentFirebaseUser?.name ?? "User Name";
//   String? userEmail = currentFirebaseUser?.email ?? "user@example.com";
//   String? userPhone = userModelCurrentInfo?.phone ?? "Not Available";
//   String? userLatitude = userModelCurrentInfo?.latitude?.toStringAsFixed(4) ??
//       "Not Available";
//   String? userLongitude =
//       userModelCurrentInfo?.longitude?.toStringAsFixed(4) ?? "Not Available";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Account Dashboard"),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               fAuth.signOut(); // تسجيل الخروج
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // قسم صورة المستخدم
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 70, // حجم الصورة
//                       backgroundImage: NetworkImage(
//                           "https://via.placeholder.com/150"), // صورة افتراضية
//                       backgroundColor: Colors.grey[300],
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       userName!,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // قسم بيانات الحساب
//             Card(
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Account Information",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Divider(),
//                     ListTile(
//                       leading: const Icon(Icons.person),
//                       title: const Text("Name"),
//                       subtitle: Text(userName!),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.email),
//                       title: const Text("Email"),
//                       subtitle: Text(userEmail!),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.phone),
//                       title: const Text("Phone"),
//                       subtitle: Text(userPhone!),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.location_on),
//                       title: const Text("Location"),
//                       subtitle: Text("Latitude: $userLatitude, Longitude: $userLongitude"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // زر تسجيل الخروج
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   fAuth.signOut(); // تسجيل الخروج
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   "Sign Out",
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileTabPage extends StatefulWidget {
  @override
  _ProfileTabPage createState() => _ProfileTabPage();
}

class _ProfileTabPage extends State<ProfileTabPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance
      .ref()
      .child('users');

  User? _currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getUserData();
  }

  void _getCurrentUser() {
    setState(() {
      _currentUser = _auth.currentUser;
    });
  }

  void _getUserData() async {
    if (_currentUser != null) {
      final snapshot = await _databaseReference.child(_currentUser!.uid).get();
      if (snapshot.exists) {
        setState(() {
          _userData = Map<String, dynamic>.from(snapshot.value as Map);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body:
          _userData != null
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Name'),
                      subtitle: Text(_userData!['name']),
                    ),
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text(_userData!['email']),
                    ),
                    ListTile(
                      title: Text('Phone'),
                      subtitle: Text(_userData!['phone']),
                    ),
                    ListTile(
                      title: Text('Location'),
                      subtitle: Text(
                        'Latitude: ${_userData!['latitude']}, Longitude: ${_userData!['longitude']}',
                      ),
                    ),
                  ],
                ),
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
