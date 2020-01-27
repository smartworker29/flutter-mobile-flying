import 'package:motel/models/account.dart';
import 'package:motel/models/flightInformation.dart';
import 'package:motel/models/flylineDeal.dart';
import 'package:motel/models/locations.dart';

import 'providers.dart';
import 'dart:async';

class FlyLineRepository {

  FlyLineProvider _flyLineProvider = FlyLineProvider();


  Future<String> login(email, password){
    return _flyLineProvider.login(email, password);
  }

  Future<List<LocationObject>> locationQuery(term){
    return _flyLineProvider.locationQuery(term);
  }

  Future<List<FlightInformationObject>> searchFlights(flyFrom, flyTo, dateFrom, dateTo, type, returnFrom, returnTo, adults, infants, children, selectedCabins, curr, limit){
    return _flyLineProvider.searchFlight(flyFrom, flyTo, dateFrom, dateTo, type, returnFrom, returnTo, adults, infants, children, selectedCabins, curr, limit);
  }

  Future<List<FlylineDeal>> randomDeals() {
    return _flyLineProvider.randomDeals();
  }

  Future<Account> accountInfo() {
    return _flyLineProvider.accountInfo();
  }

  Future<void> updateAccountInfo(String firstName, String lastName, String dob,
      String gender, String email, String phone, String passport) {
    return _flyLineProvider.updateAccountInfo(firstName, lastName, dob, gender, email, phone, passport);
  }
}