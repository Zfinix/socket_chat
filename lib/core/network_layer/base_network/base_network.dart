import 'dart:convert';
import 'package:http/http.dart';

mixin BaseNetwork {
  final Client client = Client();

  Future<Map<String, String>> defaultHeaders() async => {
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json;charset=UTF-8',
      };

  final String defaultBody = '{}';
  //* Helper functions

  Future<Response> getData({String url, Map<String, String> headers}) async {
    return await client.get(
      url,
      headers: headers ?? await defaultHeaders(),
    );
  }

  Future<Response> postData({
    String url,
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    return await client.post(
      url,
      headers: headers ?? await defaultHeaders(),
      body: json.encode(body ?? defaultBody),
    );
  }
}
