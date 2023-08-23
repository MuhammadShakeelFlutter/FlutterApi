import 'dart:convert';

import 'package:http/http.dart';

import 'album.dart';

extension ApiResponse on Response {
  bool isSuccess() => statusCode == 200;
  bool isCreated() => statusCode == 201;
}

abstract class ApiServices {
  String baseUrl = 'https://jsonplaceholder.typicode.com';
  String get apiUrl;
  Uri getUrl({String endPoint = ''}) => Uri.parse(baseUrl + apiUrl + endPoint);

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
    Response response = await put(getUrl(), body: jsonEncode(map));
    return response.isSuccess();
  }

  _delete({required String endPoint}) async {
    Response response = await delete(getUrl(endPoint: endPoint));
    return response.isSuccess();
  }
}

class AlbumApiServices extends ApiServices {
  @override
  String get apiUrl => '/albums';
  Future<List<Album>> fetchAlbum() async {
    List listmap = await _fetch() as List;
    return listmap.map((map) => Album.fromMap(map)).toList();
  }

  Future<bool> insertAlbum(Album album) async {
    return await _insert(album.toMap());
  }

  Future<bool> updateAlbum(Album album) async {
    return await _update(map: album.toMap(), endPoint: '/67');
  }

  Future<bool> deleteAlbum() async {
    return await _delete(endPoint: '/43');
  }
}
