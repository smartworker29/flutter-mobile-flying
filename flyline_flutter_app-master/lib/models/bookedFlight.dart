import 'package:motel/utils/date_utils.dart';

class BookedFlight {
  final List<dynamic> airlines;
  final String localArrival;
  final String localDeparture;
  final String returnArrival;
  final String returnDeparture;
  final String cityFrom;
  final String cityTo;
  final int price;
  final bool isRoundtrip;

  BookedFlight({
    this.airlines,
    this.localArrival,
    this.localDeparture,
    this.returnArrival,
    this.returnDeparture,
    this.cityFrom,
    this.cityTo,
    this.isRoundtrip,
    this.price,
  });
  String getAirlines(Map<String, dynamic> airlineCodes) {
    List<String> lines = List<String>();
    this.airlines.forEach((v) {
      lines.add(airlineCodes[v]);
    });
    return lines.join(', ');
  }

  factory BookedFlight.fromJson(Map<String, dynamic> json) {

    var parsedDepartureDate = DateUtils.monthDayFormat(
        DateTime.parse(json['data']["local_departure"]));
    var parsedArrivalDate =
        DateUtils.monthDayFormat(DateTime.parse(json['data']["local_arrival"]));

    var parsedReturnDepartureDate = DateUtils.monthDayFormat(
        DateTime.parse(json['data']["return_departure"]));
    var parsedReturnArrivalDate = DateUtils.monthDayFormat(
        DateTime.parse(json['data']["return_arrival"]));

    return BookedFlight(
      airlines: json['data']['airlines'],
      cityFrom: json['data']['cityFrom'],
      cityTo: json['data']['cityTo'],
      isRoundtrip: json['data']['roundtrip'],
      price: json['data']['price'],
      localArrival: parsedArrivalDate,
      localDeparture: parsedDepartureDate,
      returnArrival: parsedReturnDepartureDate,
      returnDeparture: parsedReturnArrivalDate,
    );
  }
}
