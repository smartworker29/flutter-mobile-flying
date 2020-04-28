import 'package:motel/helper/helper.dart';
import 'package:motel/models/check_flight_response.dart';

class TravelerInformation {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String passportId;
  String passportExpiration;
  BagItem carryOnSelected;
  BagItem checkedBagageSelected;

  TravelerInformation(
      this.firstName,
      this.lastName,
      this.dob,
      this.gender,
      this.passportId,
      this.passportExpiration,
      this.carryOnSelected,
      this.checkedBagageSelected);

  String get ageCategory {
    try {
      var age = Helper.age(DateTime.parse(this.dob));
      if (age <= 7) {
        return "infant";
      } else if (age <= 18) {
        return "child";
      }

      return "adult";
    } catch (e) {
      return null;
    }
  }
}
