// import 'dart:convert';

// import 'package:flutter/material.dart';
// // import 'package:googleapis/people/v1.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
// import 'package:provider/provider.dart';

// class PushNotificationService {
//   static Future<String> getAccessToken() async {
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "uber-ola-and-indriver-cl-fecfa",
//       "private_key_id": "0ddaf325733bc9bfcf37f51b338b4e26e076d019",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCphZpm4dMU+fO/\ntyB8v5XBmdzWbNKRIvwhP9erERI1McV15oWfDb4UT9E/+ozh719rqFGuJf9YTxSw\nsrWSm67hUlKMxxln29E0hdtQfAouaHAGDfxXdiCL58ZSr81wjEdVyRZjfK9ZrLuk\nYjYnQnXCfPac+AIS1L6mdTDlxpiA5yWkRaM0Pymwg3E8qlBxYO1otu/E+EPit4Vb\nUsONkhin84tB3YckZ72n7Nr7yIrbwxEuprXg2h+ipE1bypBotqrTI+GILcg3z9pd\njrse/v4EqwMmKBr1ZOqodlV1ZLkzzdsIHprNEF8K9wlASxP3fdlbPloWGi5XSpC4\nQh27YaK1AgMBAAECggEADCrqyjerTvYh6MDcNBgMR7kjgMCO3JwGPNy4Pi8bf3Xz\nFmNVc/Uoj4yrGEyDkDP+RVvvgPB5Q31pnsU1AzDpfILMKg6gZDQC8CIre7trf6k/\nYS/fzOdNrr0UHxs/Q7TN6fplAP8SFv2u+j2SZX7/tNYDXYDvpSpgBNKkj9mRWK8g\nsHtVRly29YHMC8mz8xL0z2KgjCavp0m5vclDjt4EbPokJbAOAbBRjUC8onlMDG/u\n3D++C6HzKxGhNHHwDIcUK0EtGQudpjKIDgy9jICWFtNBkOppgPVvAHpsQuyRd/HU\nYY+DpiuOjKJsmOq6AtLudqyY/Kl3rqH56+tz5mmEgQKBgQDcc0fwsaySGi5DnuRl\nKXa6HmiM+l8HgIeKLYs591gFywGdyJNcRisKaNTXL5sbvRjF6TfkPIx2h/x25NZW\nAr2tD0Cb6wN1J3B4R6FxRxqBh95A9L1bj6E/WrdmZTB3zXp5KaGaicz01u3+kC50\n8W8XRyzuWIzCSS8c7fy3xAqR5wKBgQDE29/HUNTqL/qJLSI7kK6Pdk9Co+RZOn5K\n4P1zYCeb18xsnMMAG0fX8zbS3GYc9RaF0bMMO9BWi5d/Dyn4ThMTaCsW6HI7dH+y\nKbFyQ/eAcBnMajwH6+ra34TFaWkhzqLSAtkETqBT/SAMrtesN9tQW7z6CgtxtaLS\n0PHQ93sLAwKBgQCvgrSm474CAAgPXCR4if91hJo2i2s3HNRMZaAwAUW6LvrVdQgl\ncdP4kKfLvqId/noHr3sJIk+uWuvceKpQhhQfAUKuH/h7wG+hw128QyDOOa7wRimw\nCPUW7JGRW0SwTQ6SAlwgHk/oKmoGvyHNhx6sCMWz6Rn/4KY6wRrv74t+xwKBgAaa\nMTkoFtv72/U51EoXIiOhniroAEKV2aJ9RULXWLy7UhnacBfS0mgFujL8PVh/R9AZ\nJl4kq2obqGsUgR3Y0H74IWnVRe+EirvY9iCU8voVyGe4sGa7nNbWZEeSr3n4yjEs\n80ZXtLzcYnTKcGVQQkTBrubb62JW6y0S4OlXQ4MtAoGBAIEr+3cW3gTl7k13p2bd\nNRWoeRQ7zooBLQjbzizULLe/7itpSn74G/Cbq2jHADq+0gEU9ZN9ZDPpDbzGJ8up\nvkic3TxWqOJmpV10eM+eBbYnIVW0cSS+94QDDg8tp6aVXi5wYBFTDzvmDsNEppJK\n9a2KMP9BRqmIETGPXfCZ/YbE\n-----END PRIVATE KEY-----\n",
//       "client_email":
//           "flutteruberclone@uber-ola-and-indriver-cl-fecfa.iam.gserviceaccount.com",
//       "client_id": "113802533279679559813",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/flutteruberclone%40uber-ola-and-indriver-cl-fecfa.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com",
//     };

//     List<String> scopes = [
//       "https://WWW.gooleapis.com/auth/userinfo.email",
//       "https://WWW.gooleapis.com/auth/firebase.database",
//       "https://WWW.gooleapis.com/auth/firebase.messaging",
//     ];

//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );

//     //get the access token
//     auth.AccessCredentials credentials = await auth
//         .obtainAccessCredentialsViaServiceAccount(
//           auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//           scopes,
//           client,
//         );
//     client.close();

//     return credentials.accessToken.data;
//   }

//   static sendNotificationToSelecteDriver(
//     String deviceToken,
//     BuildContext context,
//     String tripID,
//   ) async {
//     String dropOffDestinationAddress =
//         Provider.of<AppInfo>(
//           context,
//           listen: false,
//         ).dropOffLocation!.placeName.toString();

//     String pickUpAddress =
//         Provider.of<AppInfo>(
//           context,
//           listen: false,
//         ).pickUpLocation!.placeName.toString();

//     final String serverAccessTokenKey = await getAccessToken();
//     String endpointFirebaseCloudMessaging =
//         'https://fcm.googleapis.com/v1/projects/uber-ola-and-indriver-cl-fecfa/messages';

//     final Map<String, dynamic> message = {
//       'message': {
//         'token': deviceToken,
//         'notification': {
//           'title': "NET TRIP REQUESTfrom $userName",
//           'body':
//               "pickup Location : $pickUpAddress \n Drop off Location : $dropOffDestinationAddress ",
//         },
//       },
//       'data': {tripID},
//     };
//     final http.Response response = await http.post(
//       Uri.parse(endpointFirebaseCloudMessaging),
//       headers: <String, String>{
//         'content-Type ': 'application/json',
//         'Authorization': 'Barer $serverAccessTokenKey',
//       },
//       body: jsonEncode(message),
//     );
//     if (response.statusCode == 200) {
//       print("notifacation sent successfuly");
//     } else {
//       print("Faild to sent fcm message : ${response.statusCode}");
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as FAuth;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:user_app/provider/app_info.dart';

// تأكد أنك أنشأت هذا الملف وأضفت فيه Address و AppInfo
// import '../provider/app_info.dart'; // ← مسار تقريبي

class PushNotificationService {
  /// ✅ جلب التوكن المؤقت من Firebase Cloud Messaging باستخدام حساب الخدمة
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      // ملاحظة: هذا المفتاح يجب ألا يكون ضمن التطبيق، بل على الخادم فقط
      "type": "service_account",
      "project_id": "uber-ola-and-indriver-cl-fecfa",
      "private_key_id": "YOUR_PRIVATE_KEY_ID",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\\nYOUR_KEY\\n-----END PRIVATE KEY-----\\n",
      "client_email": "YOUR_SERVICE_ACCOUNT_EMAIL",
      "client_id": "YOUR_CLIENT_ID",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/YOUR_SERVICE_ACCOUNT_EMAIL",
      "universe_domain": "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    final client = await FAuth.clientViaServiceAccount(
      FAuth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    final credentials = await FAuth.obtainAccessCredentialsViaServiceAccount(
      FAuth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  /// ✅ إرسال إشعار إلى سائق محدد
  static Future<void> sendNotificationToSelectedDriver({
    required String deviceToken,
    required BuildContext context,
    required String tripID,
    required String userName,
  }) async {
    // الحصول على معلومات التوصيل من AppInfo
    final dropOffLocation =
        Provider.of<AppInfo>(context, listen: false).dropOffLocation;
    final pickUpLocation =
        Provider.of<AppInfo>(context, listen: false).pickUpLocation;

    String dropOffAddress = dropOffLocation?.placeName ?? "وجهة غير معروفة";
    String pickUpAddress = pickUpLocation?.placeName ?? "موقع غير معروف";

    final String accessToken = await getAccessToken();
    final String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/uber-ola-and-indriver-cl-fecfa/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': "طلب رحلة جديد من $userName",
          'body': "من: $pickUpAddress\nإلى: $dropOffAddress",
        },
        'data': {'tripID': tripID},
      },
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("✔ تم إرسال الإشعار بنجاح");
    } else {
      print("❌ فشل إرسال الإشعار: ${response.statusCode}");
      print("الرد: ${response.body}");
    }
  }
}
