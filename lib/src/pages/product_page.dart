import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:Fluttergram/src/model/product_model.dart';
import 'package:Fluttergram/src/providers/products_provider.dart';
import 'package:Fluttergram/src/utils/app_utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey     = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool saving = false;
  File photo;

  ProductModel product              = ProductModel();
  ProductsProvider productsProvider = ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPicture,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePicture,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showPhoto(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                SizedBox(height: 20.0),
                _createButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Product'),
      onSaved: (String value)   => product.titulo = value,
      validator: (String value) => (value.length < 3) ? 'Enter a value' : null
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Price'),
      onSaved: (String value)   => product.valor = double.parse(value),
      validator: (String value) => (utils.isNumeric(value)) ? null : 'Only numbers'
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: product.disponible,
      title: Text('Available'),
      activeColor: Colors.deepPurple,
      onChanged: (bool value) {
        setState(() {
          product.disponible = value;
        });
      },
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      label: Text('Save'),
      icon: Icon(Icons.save),
      color: Colors.deepPurple,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: (saving) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() { saving = true; });

    if (photo != null) {
      product.fotoUrl = await productsProvider.uploadImage(photo);
    }

    if (product.id == null) {
      productsProvider.postProduct(product);
      _showSnackBar('Product created');
    } else {
      productsProvider.putProduct(product);
      _showSnackBar('Product updated');
    }
  }

  void _showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.deepPurple,
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
    _delay1();
  }

  Future _delay1() {
    return Future.delayed(const Duration(milliseconds: 1800), () => Navigator.pop(context));
  }

  Widget _showPhoto() {
    if (product.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(product.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _processPicture(ImageSource source) async {
    photo = await ImagePicker.pickImage(
      source: source
    );

    if (photo == null) return;

    if (photo != null) {
      product.fotoUrl = null;
    }

    setState(() { });
  }

  void _selectPicture() {
    _processPicture(ImageSource.gallery);
  }

  void _takePicture() async {
    _processPicture(ImageSource.camera);
  }
}
