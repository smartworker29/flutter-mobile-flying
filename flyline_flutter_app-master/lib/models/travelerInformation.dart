import 'package:motel/models/checkFlightResponse.dart';

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
}
