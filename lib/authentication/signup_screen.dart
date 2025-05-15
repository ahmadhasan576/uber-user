// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:user_app/Widgets/progress_dialog.dart';
// import 'package:user_app/authentication/login_screen.dart';
// import 'package:user_app/global/global.dart';
// import 'package:user_app/splashScreen/splash_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   TextEditingController nameTextEditingController = TextEditingController();
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController phoneTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();

//   validateForm() {
//     if (nameTextEditingController.text.length < 3) {
//       Fluttertoast.showToast(msg: "name must be atleast 3 characters.");
//     } else if (!emailTextEditingController.text.contains("@")) {
//       Fluttertoast.showToast(msg: "Email is not valid.");
//     } else if (phoneTextEditingController.text.length != 10) {
//       Fluttertoast.showToast(msg: "Phone Number should be 10 nember.");
//     } else if (passwordTextEditingController.text.length < 5) {
//       Fluttertoast.showToast(
//         msg: "Password is Wrong, should more than 5 charectar",
//       );
//     } else {
//       saveUserInfoNow();
//     }
//   }

//   saveUserInfoNow() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext c) {
//         return ProgressDialog(message: "Processing, please wait...");
//       },
//     );

//     try {
//       final UserCredential userCredential = await fAuth
//           .createUserWithEmailAndPassword(
//             email: emailTextEditingController.text.trim(),
//             password: passwordTextEditingController.text.trim(),
//           );

//       final User? firebaseUser = userCredential.user;

//       if (firebaseUser != null) {
//         // احصل على موقع المستخدم
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );

//         // إنشاء خريطة البيانات التي سيتم حفظها
//         Map<String, dynamic> userMap = {
//           "id": firebaseUser.uid,
//           "name": nameTextEditingController.text.trim(),
//           "email": emailTextEditingController.text.trim(),
//           "phone": phoneTextEditingController.text.trim(),
//           "latitude": position.latitude,
//           "longitude": position.longitude,
//         };

//         // حفظ البيانات داخل قاعدة بيانات Realtime Database
//         DatabaseReference userRef = FirebaseDatabase.instance.ref().child(
//           "users",
//         );
//         await userRef.child(firebaseUser.uid).set(userMap);

//         currentFirebaseUser = firebaseUser;

//         Fluttertoast.showToast(msg: "Account has been created.");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (c) => MySplashScreen()),
//         );
//       } else {
//         Navigator.pop(context);
//         Fluttertoast.showToast(msg: "Account has not been created.");
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Image.asset("images/logo.png"),
//               ),

//               const SizedBox(height: 10),

//               const Text(
//                 "Register as a User",
//                 style: TextStyle(
//                   fontSize: 26,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               TextField(
//                 controller: nameTextEditingController,
//                 style: const TextStyle(color: Colors.white),

//                 decoration: InputDecoration(
//                   labelText: "Name",
//                   hintText: "Name",

//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
//                   labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ),

//               TextField(
//                 controller: emailTextEditingController,
//                 keyboardType: TextInputType.emailAddress,
//                 style: const TextStyle(color: Colors.grey),
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   hintText: "Email",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
//                   labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ),

//               TextField(
//                 controller: phoneTextEditingController,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(color: Colors.grey),
//                 decoration: const InputDecoration(
//                   labelText: "Phone",
//                   hintText: "Phone",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
//                   labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ),

//               TextField(
//                 controller: passwordTextEditingController,
//                 keyboardType: TextInputType.text,
//                 obscureText: true,
//                 style: const TextStyle(color: Colors.grey),
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   hintText: "Password",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
//                   labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ),

//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   validateForm();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   iconColor: Colors.lightGreenAccent,
//                 ),
//                 child: const Text(
//                   "Create Account",
//                   style: TextStyle(color: Colors.black54, fontSize: 18),
//                 ),
//               ),

//               TextButton(
//                 child: const Text(
//                   "Already have an account? login here",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (c) => LoginScreen()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:user_app/Widgets/progress_dialog.dart';
import 'package:user_app/authentication/login_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/splashScreen/splash_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "Name must be at least 3 characters.");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid.");
    } else if (phoneTextEditingController.text.length != 10) {
      Fluttertoast.showToast(msg: "Phone Number should be 10 digits.");
    } else if (passwordTextEditingController.text.length < 5) {
      Fluttertoast.showToast(msg: "Password must be at least 5 characters.");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, please wait...");
      },
    );

    try {
      final UserCredential userCredential = await fAuth
          .createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim(),
          );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 1. الحصول على الموقع
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // 2. الحصول على توكن FCM
        String? token = await FirebaseMessaging.instance.getToken();

        // 3. تجهيز البيانات
        Map<String, dynamic> userMap = {
          "id": firebaseUser.uid,
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),
          "latitude": position.latitude,
          "longitude": position.longitude,
          "deviceToken": token, // ✅ حفظ التوكن
        };

        // 4. حفظ البيانات في قاعدة البيانات
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child(
          "users",
        );
        await userRef.child(firebaseUser.uid).set(userMap);

        currentFirebaseUser = firebaseUser;

        Fluttertoast.showToast(msg: "Account has been created.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => MySplashScreen()),
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Account has not been created.");
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Register as a User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: validateForm,
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),
              TextButton(
                child: const Text(
                  "Already have an account? login here",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
