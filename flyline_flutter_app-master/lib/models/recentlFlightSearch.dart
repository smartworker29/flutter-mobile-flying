import 'package:motel/utils/date_utils.dart';

class RecentFlightSearch {
  final String arrivalDate;
  final String departureDate;
  final DateTime arrivalDateFull;
  final DateTime departureDateFull;
  final String cityFrom;
  final String cityTo;
  final bool isRoundtrip;

  RecentFlightSearch({
    this.arrivalDate,
    this.departureDate,
    this.arrivalDateFull,
    this.departureDateFull,
    this.cityFrom,
    this.cityTo,
    this.isRoundtrip,
  });

  factory RecentFlightSearch.fromJson(Map<String, dynamic> json) {
    var parsedDepartureDate =
        DateUtils.monthDayFormat(DateTime.parse(json["departure_date"]));
    var parsedArrivalDate =
        DateUtils.monthDayFormat(DateTime.parse(json["return_date"]));

    return RecentFlightSearch(
      cityFrom: json['place_from']['name'],
      cityTo: json['place_to']['name'],
      isRoundtrip: json['destination_type'] == 'round' ? true : false,
      arrivalDate: parsedArrivalDate,
      departureDate: parsedDepartureDate,
      arrivalDateFull: DateTime.parse(json["return_date"]),
      departureDateFull: DateTime.parse(json["departure_date"]),
    );
  }
}
