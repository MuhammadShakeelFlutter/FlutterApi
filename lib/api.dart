import 'dart:convert';

import 'package:http/http.dart';

extension ApiRespone on Response {
  bool isSuccess() => statusCode == 200;
  bool isCreated() => statusCode == 201;
}

abstract class ApiProvider {
  String baseurl = 'https://jsonplaceholder.typicode.com';
  String get apiurl;
  Uri getUrl({String endPoint = ''}) => Uri.parse(baseurl + apiurl + endPoint);

  _fetch({String endPoint = ''}) async {
    Response response = await get(getUrl(endPoint: endPoint));
    if (response.isSuccess()) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  _insert(Map<String, dynamic> map) async {
    Response response = await post(getUrl(), body: jsonEncode(map));
    return response.isCreated();
  }

  _update({required Map<String, dynamic> map, required String endPoint}) async {
    Response response =
        await put(getUrl(endPoint: endPoint), body: jsonEncode(map));
    return response.isSuccess();
  }
}
