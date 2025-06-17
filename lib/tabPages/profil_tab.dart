import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    User? user = fAuth.currentUser;
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(user.uid);

      userRef
          .once()
          .then((DatabaseEvent event) {
            final dataSnapshot = event.snapshot;
            if (dataSnapshot.exists) {
              setState(() {
                nameController.text =
                    dataSnapshot.child("name").value?.toString() ?? "";
                emailController.text =
                    dataSnapshot.child("email").value?.toString() ?? "";
                phoneController.text =
                    dataSnapshot.child("phone").value?.toString() ?? "";
                isLoading = false;
              });
            } else {
              setState(() => isLoading = false);
            }
          })
          .catchError((error) {
            print("Error: $error");
            setState(() => isLoading = false);
          });
    }
  }

  updateUserData() async {
    User? user = fAuth.currentUser;
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(user.uid);

      await userRef.update({
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
      });

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("تم حفظ التعديلات بنجاح")));
    }
  }

  Widget _buildInfoField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[700]),
          SizedBox(width: 12),
          Expanded(
            child:
                isEditing
                    ? TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: label,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                    : Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "${label}: ${controller.text}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Account Dashboard"),
  //       backgroundColor: Colors.indigo,
  //       actions: [
  //         IconButton(icon: Icon(Icons.refresh), onPressed: fetchUserData),
  //       ],
  //     ),
  //     body:
  //         isLoading
  //             ? Center(child: CircularProgressIndicator())
  //             : SingleChildScrollView(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 children: [
  //                   Card(
  //                     elevation: 4,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(16),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(20),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "Account Information",
  //                             style: TextStyle(
  //                               fontSize: 20,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           Divider(height: 30),
  //                           _buildInfoField(
  //                             icon: Icons.person,
  //                             label: "Name",
  //                             controller: nameController,
  //                           ),
  //                           _buildInfoField(
  //                             icon: Icons.email,
  //                             label: "Email",
  //                             controller: emailController,
  //                           ),
  //                           _buildInfoField(
  //                             icon: Icons.phone,
  //                             label: "Phone",
  //                             controller: phoneController,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),
  //                   ElevatedButton.icon(
  //                     onPressed: () {
  //                       if (isEditing) {
  //                         updateUserData();
  //                       } else {
  //                         setState(() => isEditing = true);
  //                       }
  //                     },
  //                     icon: Icon(isEditing ? Icons.save : Icons.edit),
  //                     label: Text(isEditing ? "Save Changes" : "Edit"),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: isEditing ? Colors.green : Colors.blue,
  //                       minimumSize: Size(double.infinity, 50),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 10),
  //                   ElevatedButton.icon(
  //                     onPressed: () async {
  //                       await fAuth.signOut();
  //                       // يمكنك التوجيه إلى صفحة تسجيل الدخول هنا
  //                     },
  //                     icon: Icon(Icons.logout),
  //                     label: Text("Sign Out"),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.red,
  //                       minimumSize: Size(double.infinity, 50),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الاتجاه من اليمين لليسار
      child: Scaffold(
        appBar: AppBar(
          title: const Text("لوحة التحكم بالحساب"),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchUserData,
              tooltip: "تحديث البيانات",
            ),
          ],
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "معلومات الحساب",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(height: 30),
                              _buildInfoField(
                                icon: Icons.person,
                                label: "الاسم",
                                controller: nameController,
                              ),
                              _buildInfoField(
                                icon: Icons.email,
                                label: "البريد الإلكتروني",
                                controller: emailController,
                              ),
                              _buildInfoField(
                                icon: Icons.phone,
                                label: "رقم الهاتف",
                                controller: phoneController,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (isEditing) {
                            updateUserData();
                          } else {
                            setState(() => isEditing = true);
                          }
                        },
                        icon: Icon(isEditing ? Icons.save : Icons.edit),
                        label: Text(isEditing ? "حفظ التغييرات" : "تعديل"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isEditing ? Colors.green : Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await fAuth.signOut();
                          // يمكنك التوجيه إلى صفحة تسجيل الدخول هنا
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("تسجيل الخروج"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
