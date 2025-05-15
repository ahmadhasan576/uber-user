// // import 'package:driver_app/splashScreen/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:user_app/splashScreen/splash_screen.dart';
// // import 'package:firebase_core/firebase_core.dart'; // استيراد حزمة Firebase
// // import 'package:geolocator/geolocator.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: "AIzaSyBY3aBQoVmhsLU2n3D5xU-kdYsWxyxiYIg",
//         authDomain: "uber-ola-and-indriver-cl-fecfa.firebaseapp.com",
//         databaseURL:
//             "https://uber-ola-and-indriver-cl-fecfa-default-rtdb.firebaseio.com",
//         projectId: "uber-ola-and-indriver-cl-fecfa",
//         storageBucket: "uber-ola-and-indriver-cl-fecfa.firebasestorage.app",
//         messagingSenderId: "659490985048",
//         appId: "1:659490985048:web:b74b97f03dc78ba5e2262d",
//         measurementId: "G-3MYCX5EH8X",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }
//   ;

//   runApp(
//     MyApp(
//       child: MaterialApp(
//         title: 'User App',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         ),
//         home: const MySplashScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   final Widget? child;
//   MyApp({this.child});

//   static void restartApp(BuildContext context) {
//     context.findAncestorStateOfType<_MyAppState>()!.restartApp();
//   }

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Key key = UniqueKey();
//   void restartApp() {
//     setState(() {
//       key = UniqueKey();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(key: key, child: widget.child!);
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/splashScreen/splash_screen.dart';
import 'provider/app_info.dart'; // ← استيراد AppInfo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBY3aBQoVmhsLU2n3D5xU-kdYsWxyxiYIg",
        authDomain: "uber-ola-and-indriver-cl-fecfa.firebaseapp.com",
        databaseURL:
            "https://uber-ola-and-indriver-cl-fecfa-default-rtdb.firebaseio.com",
        projectId: "uber-ola-and-indriver-cl-fecfa",
        storageBucket: "uber-ola-and-indriver-cl-fecfa.firebasestorage.app",
        messagingSenderId: "659490985048",
        appId: "1:659490985048:web:b74b97f03dc78ba5e2262d",
        measurementId: "G-3MYCX5EH8X",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppInfo())],
      child: MyApp(
        child: MaterialApp(
          title: 'User App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const MySplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;
  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child!);
  }
}
