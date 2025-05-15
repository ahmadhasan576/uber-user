// import 'package:driver_app/Widgets/progress_dialog.dart';
// import 'package:driver_app/authentication/signup_screen.dart';
// import 'package:driver_app/global/global.dart';
// import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/Widgets/progress_dialog.dart';
import 'package:user_app/authentication/signup_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/splashScreen/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is requird");
    } else {
      loginUserNow();
    }
  }

  loginUserNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "processing ,, Please wait...");
      },
    );

    try {
      final User? firebaseUser =
          (await fAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim(),
          )).user;

      if (firebaseUser != null) {
        currentFirebaseUser = firebaseUser;
        Fluttertoast.showToast(msg: "Login successful.");

        Navigator.pop(context); // إغلاق نافذة الانتظار
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const MySplashScreen()),
        );
      } else {
        Navigator.pop(context); // إغلاق نافذة الانتظار
        Fluttertoast.showToast(msg: "Error Occurred during Login.");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // إغلاق نافذة الانتظار
      Fluttertoast.showToast(msg: "Login failed: ${e.message}");
    } catch (e) {
      Navigator.pop(context); // إغلاق نافذة الانتظار
      Fluttertoast.showToast(msg: "An unexpected error occurred.");
    }
  }

  // loginUserNow() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext c) {
  //       return ProgressDialog(message: "processing ,, Please wait...");
  //     },
  //   );
  //   final User? firebaseUser =
  //       (await fAuth
  //           .signInWithEmailAndPassword(
  //             email: emailTextEditingController.text.trim(),
  //             password: passwordTextEditingController.text.trim(),
  //           )
  //           .catchError((msg) {
  //             Navigator.pop(context);
  //             Fluttertoast.showToast(msg: "Error" + msg.toString());
  //           })).user;
  //   if (firebaseUser != null) {
  //     currentFirebaseUser = firebaseUser;
  //     Fluttertoast.showToast(msg: "Login successful.");
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (c) => const MySplashScreen()),
  //     );
  //   } else {
  //     Navigator.pop(context);
  //     Fluttertoast.showToast(msg: "Error Occurred during Login.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),
              const SizedBox(height: 10),

              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
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
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),

              TextButton(
                child: const Text(
                  "Do not have an Account? Create Acount",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => SignUpScreen()),
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
