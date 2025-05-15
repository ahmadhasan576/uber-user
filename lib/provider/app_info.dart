import 'package:flutter/foundation.dart';
import '../models/address.dart';

class AppInfo extends ChangeNotifier {
  Address? pickUpLocation;
  Address? dropOffLocation;

  void updatePickUpLocation(Address location) {
    pickUpLocation = location;
    notifyListeners();
  }

  void updateDropOffLocation(Address location) {
    dropOffLocation = location;
    notifyListeners();
  }
}
