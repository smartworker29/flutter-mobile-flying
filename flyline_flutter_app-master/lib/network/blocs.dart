import 'package:intl/intl.dart';
import 'package:motel/models/book_request.dart';
import 'package:motel/models/recent_flight_search.dart';
import 'package:rxdart/rxdart.dart';

import '../models/account.dart';
import '../models/booked_flight.dart';
import '../models/check_flight_response.dart';
import '../models/flight_information.dart';
import '../models/flyline_deal.dart';
import '../models/locations.dart';
import 'repositories.dart';

class FlyLineBloc {
  final FlyLineRepository _repository = FlyLineRepository();

  BehaviorSubject<String> _token = BehaviorSubject<String>();

  set token(String value) {
    _token.add(value);
  }

  BehaviorSubject<String> get tokenData => _token;
  final BehaviorSubject<List<LocationObject>> _subjectlocationItems =
      BehaviorSubject<List<LocationObject>>();

  final BehaviorSubject<List<FlightInformationObject>>
      _subjectExclusiveFlightItems =
      BehaviorSubject<List<FlightInformationObject>>();

  final BehaviorSubject<List<FlightInformationObject>> _subjectMetaFlightItems =
      BehaviorSubject<List<FlightInformationObject>>();

  final BehaviorSubject<List<BookedFlight>> _subjectUpcomingFlights =
      BehaviorSubject<List<BookedFlight>>();
  final BehaviorSubject<List<BookedFlight>> _subjectPastFlights =
      BehaviorSubject<List<BookedFlight>>();

  final BehaviorSubject<List<RecentFlightSearch>> _subjectRecentFlightSearch =
      BehaviorSubject<List<RecentFlightSearch>>();

  final BehaviorSubject<List<FlylineDeal>> _subjectRandomDeals =
      BehaviorSubject<List<FlylineDeal>>();

  final BehaviorSubject<Account> _subjectAccountInfo =
      BehaviorSubject<Account>();

  final BehaviorSubject<CheckFlightResponse> _subjectCheckFlight =
      BehaviorSubject<CheckFlightResponse>();

  final BehaviorSubject<Map> _subjectBookFlight = BehaviorSubject<Map>();

  tryLogin(String email, String password) async {
    String response = await _repository.login(email, password);
    _token.sink.add(response);
  }

  Future<List<LocationObject>> locationQuery(String term) async {
    List<LocationObject> response = await _repository.locationQuery(term);
    _subjectlocationItems.sink.add(response);
    return response;
  }

  Future searchFlight(
    flyFrom,
    flyTo,
    DateTime dateFrom,
    DateTime dateTo,
    type,
    DateTime returnFrom,
    DateTime returnTo,
    adults,
    infants,
    children,
    selectedCabins,
    curr,
    offset,
    limit,
  ) async {
    List<FlightInformationObject> response = await _repository.searchFlights(
        flyFrom,
        flyTo,
        DateFormat("dd/MM/yyyy").format(dateFrom),
        DateFormat("dd/MM/yyyy").format(dateTo),
        type,
        DateFormat("dd/MM/yyyy").format(returnFrom),
        DateFormat("dd/MM/yyyy").format(returnTo),
        adults,
        infants,
        children,
        selectedCabins,
        curr,
        offset,
        limit);

    _subjectExclusiveFlightItems.sink.add(response);

    List<FlightInformationObject> metaResponse =
        await _repository.searchMetaFlights(
      flyFrom,
      flyTo,
      DateFormat("yyyy-MM-dd").format(dateFrom),
      DateFormat("yyyy-MM-dd").format(dateTo),
    );

    _subjectMetaFlightItems.sink.add(metaResponse);
  }

  Future<CheckFlightResponse> checkFlights(
      bookingId, infants, children, adults) async {
    CheckFlightResponse response =
        await _repository.checkFlights(bookingId, infants, children, adults);

    _subjectCheckFlight.sink.add(response);

    return response;
  }

  Future<Map> book(BookRequest bookRequest) async {
    Map response = await _repository.book(bookRequest);
    _subjectBookFlight.sink.add(response);
    return response;
  }

  Future<List<FlylineDeal>> randomDeals() async {
    List<FlylineDeal> response = await _repository.randomDeals(50);
    _subjectRandomDeals.sink.add(response);

    return response;
  }

  Future<List<BookedFlight>> pastOrUpcomingFlightSummary(
      bool isUpcoming) async {
    List<BookedFlight> response =
        await _repository.pastOrUpcomingFlightSummary(isUpcoming);
    isUpcoming
        ? _subjectUpcomingFlights.add(response)
        : _subjectPastFlights.add(response);
    return response;
  }

  Future<List<RecentFlightSearch>> flightSearchHistory() async {
    List<RecentFlightSearch> response = await _repository.flightSearchHistory();
    _subjectRecentFlightSearch.add(response);
    return response;
  }

  Future<Account> accountInfo() async {
    Account account = await _repository.accountInfo();
    _subjectAccountInfo.sink.add(account);
    return account;
  }

  Future<void> updateAccountInfo(String firstName, String lastName, String dob,
      String gender, String email, String phone, String passport) async {
    _repository.updateAccountInfo(
        firstName, lastName, dob, gender, email, phone, passport);
  }

  dispose() {
    _token.close();
    _subjectlocationItems.close();
    _subjectExclusiveFlightItems.close();
    _subjectRandomDeals.close();
    _subjectAccountInfo.close();
    _subjectCheckFlight.close();
    _subjectRecentFlightSearch.close();
    _subjectPastFlights.close();
    _subjectUpcomingFlights.close();
    _subjectBookFlight.close();
    _subjectMetaFlightItems.close();
  }

  BehaviorSubject<String> get loginResponse => _token;

  BehaviorSubject<List<LocationObject>> get locationItems =>
      _subjectlocationItems;

  BehaviorSubject<List<FlightInformationObject>> get flightsExclusiveItems =>
      _subjectExclusiveFlightItems;

  BehaviorSubject<List<FlightInformationObject>> get flightsMetaItems =>
      _subjectMetaFlightItems;

  BehaviorSubject<List<FlylineDeal>> get randomDealItems => _subjectRandomDeals;

  BehaviorSubject<Account> get accountInfoItem => _subjectAccountInfo;

  BehaviorSubject<CheckFlightResponse> get checkFlightData =>
      _subjectCheckFlight;

  BehaviorSubject<List<RecentFlightSearch>> get recentFlightSearches =>
      _subjectRecentFlightSearch;

  BehaviorSubject<List<BookedFlight>> get pastFlights => _subjectPastFlights;

  BehaviorSubject<List<BookedFlight>> get upcomingFlights =>
      _subjectUpcomingFlights;

  BehaviorSubject<Map> get bookFlight => _subjectBookFlight;
}

final flyLinebloc = FlyLineBloc();
