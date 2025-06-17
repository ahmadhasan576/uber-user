import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:user_app/provider/app_info.dart';

class PushNotificationService {
  static Future<void> sendNotificationToSelectedDriver({
    required String deviceToken,
    required BuildContext context,
    required String tripID,
    required String userName,
  }) async {
    // الحصول على معلومات الموقع من AppInfo
    final dropOffLocation =
        Provider.of<AppInfo>(context, listen: false).dropOffLocation;
    final pickUpLocation =
        Provider.of<AppInfo>(context, listen: false).pickUpLocation;

    String dropOffAddress = dropOffLocation?.placeName ?? "وجهة غير معروفة";
    String pickUpAddress = pickUpLocation?.placeName ?? "موقع غير معروف";

    // إرسال الطلب إلى الخادم
    final response = await http.post(
      Uri.parse('http://localhost:3000/send-notification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceToken': deviceToken,
        'tripID': tripID,
        'userName': userName,
        'pickupAddress': pickUpAddress,
        'dropOffAddress': dropOffAddress,
      }),
    );

    if (response.statusCode == 200) {
      print("✔ تم إرسال الإشعار بنجاح عبر الخادم");
    } else {
      print("❌ فشل إرسال الإشعار عبر الخادم: ${response.statusCode}");
      print("الرد: ${response.body}");
    }
  }
}
