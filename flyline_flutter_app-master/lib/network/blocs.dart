import 'package:motel/models/flightInformation.dart';
import 'package:motel/models/locations.dart';

import 'repositories.dart';
import 'package:rxdart/rxdart.dart';

class FlyLineBloc {
  final FlyLineRepository _repository = FlyLineRepository();

  final BehaviorSubject<String> _token =
  BehaviorSubject<String>();

  final BehaviorSubject<List<LocationObject>> _subjectlocationItems =
  BehaviorSubject<List<LocationObject>>();

  final BehaviorSubject<List<FlightInformationObject>> _subjectFlightItems =
  BehaviorSubject<List<FlightInformationObject>>();




  tryLogin(String email, String password) async {
    String response = await _repository.login(email, password);
    _token.sink.add(response);
  }

  Future<List<LocationObject>> locationQuery(String term) async {
    List<LocationObject> response = await _repository.locationQuery(term);
    _subjectlocationItems.sink.add(response);
    return response;
  }

  Future<List<FlightInformationObject>> searchFlight(flyFrom, flyTo, dateFrom, dateTo, type, returnFrom, returnTo, adults, infants, children, selectedCabins, curr) async {
    List <FlightInformationObject> response = await _repository.searchFlights(flyFrom, flyTo, dateFrom, dateTo, type, returnFrom, returnTo, adults, infants, children, selectedCabins, curr);
    _subjectFlightItems.sink.add(response);

    return response;
  }


  dispose() {
    _token.close();
    _subjectlocationItems.close();
    _subjectFlightItems.close();
  }

  

  BehaviorSubject<String> get loginResponse => _token;

  BehaviorSubject<List<LocationObject>> get locationItems => _subjectlocationItems;


  BehaviorSubject<List<FlightInformationObject>> get flightsItems => _subjectFlightItems;

  

}

final flyLinebloc = FlyLineBloc();