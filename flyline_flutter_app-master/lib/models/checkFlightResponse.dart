class CheckFlightResponse {
  Baggage baggage;
  bool flightsChecked;
  bool flightsInvalid;

  CheckFlightResponse(this.baggage, this.flightsChecked, this.flightsInvalid);
  CheckFlightResponse.fromJson(Map<String, dynamic> json)
      : baggage = Baggage.fromJson(json['baggage']),
        flightsChecked = json['flights_checked'],
        flightsInvalid = json['flights_invalid'];
}

class Baggage {
  BaggageItem combinations;
  BaggageItem definitions;

  Baggage(this.combinations, this.definitions);

  Baggage.fromJson(Map<String, dynamic> json)
      : combinations = BaggageItem.fromJson(json['combinations']),
        definitions = BaggageItem.fromJson(json['definitions']);
}

class BaggageItem {
  List<BagItem> handBag;
  List<BagItem> holdBag;

  BaggageItem(this.handBag, this.holdBag);

  BaggageItem.fromJson(Map<String, dynamic> json)
      : handBag = (json['hand_bag'] as List).map((i) => BagItem.fromJson(i)).toList(),
        holdBag = (json['hold_bag'] as List).map((i) => BagItem.fromJson(i)).toList();
}

class BagItem {
  String category;
  Conditions conditions;
  List<dynamic> indices;
  Price price;

  BagItem(this.category, this.conditions, this.indices, this.price);

  BagItem.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        conditions = Conditions.fromJson(json['conditions']),
        indices = json['indices'],
        price = Price.fromJson(json['price']);
}

class Conditions {
  List<dynamic> passengerGroups;

  Conditions(this.passengerGroups);

  Conditions.fromJson(Map<String, dynamic> json)
      : passengerGroups = json['passenger_groups'];
}

class Price {
  double amount;
  double base;
  String currency;
  int merchant;
  double service;
  int serviceList;

  Price(this.amount, this.base, this.currency, this.merchant, this.service,
      this.serviceList);

  Price.fromJson(Map<String, dynamic> json)
      : amount = double.parse(json['amount'].toString()),
        base = double.parse(json['base'].toString()),
        currency = json['currency'],
        merchant = json['merchant'],
        service = double.parse(json['service'].toString()),
        serviceList = json['serviceList'];
}
