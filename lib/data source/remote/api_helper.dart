import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as httpClient;
import 'package:newsapp/data%20source/remote/app_exceptions.dart';
import 'package:newsapp/data%20source/remote/urls.dart';

class APiHelper {
  Future<dynamic> getAPI(String url, {Map<String, String>? headers}) async {
    try {
      var uri = Uri.parse(url);
      var response = await httpClient.get(
        uri,
        headers: headers ?? {"X-Api-Key": Urls.myApiKey},
      );
      return returnResponse(response);
    } on SocketException {
      throw FetchDataException(body: "No internet connection");
    }
  }

  dynamic returnResponse(httpClient.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseBody = response.body;
        var data = jsonDecode(responseBody);
        return data;
      case 400:
        throw BadResquestException(body: response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(body: response.body.toString());
      case 429:
        throw TooManyRequests(body: response.body.toString());
      case 500:
        throw InternalServerError(body: response.body.toString());
      default:
        throw FetchDataException(
          body:
              "error occurred while communicating with server with status code ${response.statusCode.toString()}",
        );
    }
  }
}
