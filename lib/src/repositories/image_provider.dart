import 'dart:typed_data';
import 'package:http/http.dart';
import '../models/photos.dart';
import '../repositories/state.dart';
import 'dart:convert';

class ImageProvider {
  //Singleton
  static final ImageProvider _imageProvider = ImageProvider._private();
  ImageProvider._private();
  factory ImageProvider() => _imageProvider;

  Client _client = Client();
  static const String _apiKey = "22f39908e88b4e0afa710914cd7e46e17ce5d5792d05170fb7e8236aebac1ff3";
  static const String _baseUrl = "https://api.unsplash.com";
  static const String _googleBaseUrl = "https://api.qwant.com/api/search/images";

  Future<State> getImagesByName(String query) async {

    Response response;
    if (_apiKey == 'api-key') {
      return State<String>.error("Please enter your API Key");
    }

    var headers=Map();

    headers["User_Agent"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36";

    response = await _client
        .get("$_googleBaseUrl?count=10&q=$query&t=images&safesearch=1&uiv=4");
    if (response.statusCode == 200)
      return State<Photos>.success(Photos.fromJson(json.decode(response.body)));
    else
      return State<String>.error(response.statusCode.toString());

  }

  //Get list of images based on the query
  /*Future<State> getImagesByName(String query) async {
    Response response;
    if (_apiKey == 'api-key') {
      return State<String>.error("Please enter your API Key");
    }
    response = await _client
        .get("$_baseUrl/search/photos?page=1&query=$query&client_id=$_apiKey");
    if (response.statusCode == 200)
      return State<Photos>.success(Photos.fromJson(json.decode(response.body)));
    else
      return State<String>.error(response.statusCode.toString());
  }*/

  Future<Uint8List> getImageFromUrl(String url) async {
    var response = await _client.get(url);
    Uint8List bytes = response.bodyBytes;
    return bytes;
  }
}
