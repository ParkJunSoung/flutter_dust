import 'package:flutter_dust/air_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

class AirBloc {
  final _airSubject = BehaviorSubject<AirResult>();

  AirBloc() {
    fetch();
  }

  Future<AirResult> fetchData() async {
    var uri = Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=59a06f27-fe65-483b-84f6-1192ccf78c59');
    var response = await http.get(uri);

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  void fetch() async {
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }
  Stream<AirResult> get airResult => _airSubject.stream;
}
