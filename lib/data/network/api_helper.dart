import 'dart:convert';
import 'dart:io';

import 'package:flutteroc/exceptions/exceptions.dart';
import 'package:flutteroc/exceptions/network/bad_request_exception.dart';
import 'package:flutteroc/exceptions/network/no_internet_connection_exception.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static final String BASE_URL = 'http://thunganoc377.knssoftworks.com';
  static final Map<String, String> JSON_HEADER = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<dynamic> get(String url) async {
    try {
      final uri = Uri.parse(BASE_URL + url);
      final response = await http.get(uri, headers: JSON_HEADER);
      return _processResponse(HttpMethod.GET, uri.toString(), response);
    } on SocketException {
      throw NoInternetConnectionException('No Internet Connection');
    }
  }

  Future<dynamic> post(String url, dynamic body) async {
    try {
      final uri = Uri.parse(BASE_URL + url);
      final response =
          await http.post(uri, headers: JSON_HEADER, body: jsonEncode(body));
      return _processResponse(HttpMethod.POST, uri.toString(), response,
          body: body);
    } on SocketException {
      throw NoInternetConnectionException('No Internet Connection');
    }
  }

  Future<dynamic> put(String url, dynamic body) async {
    try {
      final uri = Uri.parse(BASE_URL + url);
      final response =
          await http.put(uri, headers: JSON_HEADER, body: jsonEncode(body));
      return _processResponse(HttpMethod.PUT, uri.toString(), response,
          body: body);
    } on SocketException {
      throw NoInternetConnectionException('No Internet Connection');
    }
  }

  Future<dynamic> delete(String url, {dynamic body}) async {
    try {
      final uri = Uri.parse(BASE_URL + url);
      final response =
          await http.delete(uri, headers: JSON_HEADER, body: jsonEncode(body));
      return _processResponse(HttpMethod.DELETE, uri.toString(), response,
          body: body);
    } on SocketException {
      throw NoInternetConnectionException('No Internet Connection');
    }
  }

  dynamic _processResponse(
      HttpMethod method, String url, http.Response response,
      {dynamic body}) {
    final stringResponse = response.body.toString();
    print('$method: $url');
    if (body != null) {
      print('request: $body');
    }
    print('response: $stringResponse');
    switch (response.statusCode) {
      case 200:
        return jsonDecode(stringResponse);
      case 400:
        throw BadRequestException(stringResponse);
      default:
        throw HttpException(stringResponse);
    }
  }
}

enum HttpMethod { GET, POST, PUT, DELETE }
