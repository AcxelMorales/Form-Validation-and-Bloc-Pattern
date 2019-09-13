import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:Fluttergram/src/settings/user_preferences.dart';
import 'package:Fluttergram/src/model/product_model.dart';

class ProductsProvider {
  final String _url = 'https://flutter-b01fc.firebaseio.com';
  final _prefs = UserPreferences();

  Future<bool> postProduct(ProductModel product) async {
    final url = '$_url/products.json?auth=${this._prefs.token}';

    final resp = await http.post(url, body: productModelToJson(product));
    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> putProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${this._prefs.token}';

    final resp = await http.put(url, body: productModelToJson(product));
    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductModel>> getProducts() async {
    final url = '$_url/products.json?auth=${this._prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> products = List();

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;

      products.add(prodTemp);
    });

    return products;
  }

  Future<bool> deleteProduct(String id) async {
    final url = '$_url/products/$id.json?auth=${this._prefs.token}';
    final resp = await http.delete(url);

    print(resp.body);

    return true;
  }

  Future<String> uploadImage(File picture) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dd6bjgims/image/upload?upload_preset=o4hiovzf');
    final mimeType = mime(picture.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file',
      picture.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Something went wrong');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}