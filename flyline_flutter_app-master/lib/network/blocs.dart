import 'package:motel/models/account.dart';
import 'package:motel/models/flightInformation.dart';
import 'package:motel/models/flylineDeal.dart';
import 'package:motel/models/locations.dart';

import 'repositories.dart';
import 'package:rxdart/rxdart.dart';

class FlyLineBloc {
  final FlyLineRepository _repository = FlyLineRepository();

  final BehaviorSubject<String> _token = BehaviorSubject<String>();

  final BehaviorSubject<List<LocationObject>> _subjectlocationItems =
      BehaviorSubject<List<LocationObject>>();

  final BehaviorSubject<List<FlightInformationObject>> _subjectFlightItems =
      BehaviorSubject<List<FlightInformationObject>>();

  final BehaviorSubject<List<FlylineDeal>> _subjectRandomDeals =
      BehaviorSubject<List<FlylineDeal>>();

  final BehaviorSubject<Account> _subjectAccountInfo =
      BehaviorSubject<Account>();

  tryLogin(String email, String password) async {
    String response = await _repository.login(email, password);
    _token.sink.add(response);
  }

  Future<List<LocationObject>> locationQuery(String term) async {
    List<LocationObject> response = await _repository.locationQuery(term);
    _subjectlocationItems.sink.add(response);
    return response;
  }

  Future<List<FlightInformationObject>> searchFlight(
      flyFrom,
      flyTo,
      dateFrom,
      dateTo,
      type,
      returnFrom,
      returnTo,
      adults,
      infants,
      children,
      selectedCabins,
      curr,
      limit) async {
    List<FlightInformationObject> response = await _repository.searchFlights(
        flyFrom,
        flyTo,
        dateFrom,
        dateTo,
        type,
        returnFrom,
        returnTo,
        adults,
        infants,
        children,
        selectedCabins,
        curr,
        limit);
    _subjectFlightItems.sink.add(response);

    return response;
  }

  Future<List<FlylineDeal>> randomDeals() async {
    List<FlylineDeal> response = await _repository.randomDeals();
    _subjectRandomDeals.sink.add(response);

    return response;
  }

  Future<Account> accountInfo() async {
    Account account = await _repository.accountInfo();
    _subjectAccountInfo.sink.add(account);
    return account;
  }

  Future<void> updateAccountInfo(String firstName, String lastName, String dob,
      String gender, String email, String phone, String passport) async {
    _repository.updateAccountInfo(firstName, lastName, dob, gender, email, phone, passport);
  }

  dispose() {
    _token.close();
    _subjectlocationItems.close();
    _subjectFlightItems.close();
    _subjectRandomDeals.close();
    _subjectAccountInfo.close();
  }

  BehaviorSubject<String> get loginResponse => _token;

  BehaviorSubject<List<LocationObject>> get locationItems =>
      _subjectlocationItems;

  BehaviorSubject<List<FlightInformationObject>> get flightsItems =>
      _subjectFlightItems;

  BehaviorSubject<List<FlylineDeal>> get randomDealItems => _subjectRandomDeals;

  BehaviorSubject<Account> get accountInfoItem => _subjectAccountInfo;
}

final flyLinebloc = FlyLineBloc();
