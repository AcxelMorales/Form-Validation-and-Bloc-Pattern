import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:Fluttergram/src/model/product_model.dart';
import 'package:Fluttergram/src/providers/products_provider.dart';

class ProductBloc {
  final _productsController = BehaviorSubject<List<ProductModel>>();
  final _loadingController  = BehaviorSubject<bool>();

  final _productsProvider = ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void loadProducts() async {
    final prods = await _productsProvider.getProducts();
    _productsController.sink.add(prods);
  }

  void addProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.postProduct(product);
    _loadingController.sink.add(false);
  }

  void updateProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.putProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadPicture(File photo) async {
    _loadingController.sink.add(true);
    final photoUrl = await _productsProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return photoUrl;
  }

  void deleteProduct(String id) async {
    await _productsProvider.deleteProduct(id);
  }

  void dispose() {
    _productsController?.close();
    _loadingController?.close();
  }
}