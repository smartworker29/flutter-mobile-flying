import 'dart:async';

import 'package:motel/models/book_request.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/recent_flight_search.dart';

import '../models/account.dart';
import '../models/booked_flight.dart';
import '../models/flight_information.dart';
import '../models/flyline_deal.dart';
import '../models/locations.dart';
import 'providers.dart';

class FlyLineRepository {
  FlyLineProvider _flyLineProvider = FlyLineProvider();

  Future<String> login(email, password) {
    return _flyLineProvider.login(email, password);
  }

  Future<List<LocationObject>> locationQuery(term) {
    return _flyLineProvider.locationQuery(term);
  }

  Future<List<FlightInformationObject>> searchFlights(
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
      offset,
      limit) {
    return _flyLineProvider.searchFlight(
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
        offset,
        limit);
  }

  Future<List<FlightInformationObject>> searchMetaFlights(
    String flyFrom,
    String flyTo,
    String startDate,
    String returnDate,
  ) {
    return _flyLineProvider.searchMetaFlights(
      flyFrom,
      flyTo,
      startDate,
      returnDate,
    );
  }

  Future<CheckFlightResponse> checkFlights(
      bookingId, infants, children, adults) {
    return _flyLineProvider.checkFlights(bookingId, infants, children, adults);
  }

  Future<Map> book(BookRequest bookRequest) {
    return _flyLineProvider.book(bookRequest);
  }

  Future<List<FlylineDeal>> randomDeals(int size) {
    return _flyLineProvider.randomDealsForGuest(size);
  }

  Future<List<BookedFlight>> pastOrUpcomingFlightSummary(
      bool isUpcoming) async {
    return await _flyLineProvider.pastorUpcomingFlightSummary(isUpcoming);
  }

  Future<List<RecentFlightSearch>> flightSearchHistory() async {
    return await _flyLineProvider.flightSearchHistory();
  }

  Future<Account> accountInfo() {
    return _flyLineProvider.accountInfo();
  }

  Future<void> updateAccountInfo(String firstName, String lastName, String dob,
      String gender, String email, String phone, String passport) {
    return _flyLineProvider.updateAccountInfo(
        firstName, lastName, dob, gender, email, phone, passport);
  }
}
