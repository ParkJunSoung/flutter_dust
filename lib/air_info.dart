import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dust/air_result.dart';


import 'package:http/http.dart' as http;


class AirInfo extends ChangeNotifier {
  AirResult _result;

  AirResult get result => _result;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<AirResult> _fetchData() async {
    var uri = Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=59a06f27-fe65-483b-84f6-1192ccf78c59');
    var response = await http.get(uri);

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  void fetchData() {
    _isLoading = true;
    _fetchData().then((result) {
      _result = result;
      _isLoading = false;
      notifyListeners();
    });
  }
}