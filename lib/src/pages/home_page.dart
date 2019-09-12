import 'package:flutter/material.dart';

import 'package:Fluttergram/src/model/product_model.dart';
import 'package:Fluttergram/src/providers/products_provider.dart';
import 'package:Fluttergram/src/bloc/provider.dart';
import 'package:Fluttergram/src/settings/user_preferences.dart';

class HomePage extends StatelessWidget {
  final productsProvider = ProductsProvider();
  final _prefs = UserPreferences();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              this._prefs.token = null;
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
      body: _createList(),
      floatingActionButton: _createFloatingActionButton(context),
      backgroundColor: Colors.white
    );
  }

  Widget _createList() {
    return FutureBuilder(
      future: productsProvider.getProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) => _createItem(context, products[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 100.0,
        ),
      ),
      child: Card(
        margin: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 20.0, left: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 7.0,
        child: Column(
          children: <Widget>[
            (product.fotoUrl == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                  image: NetworkImage(product.fotoUrl),
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
            ListTile(
              leading: Icon(
                Icons.blur_on,
                color: (product.disponible) ? Colors.green : Colors.red,
              ),
              title: Text(
                '${product.titulo} - \$${product.valor}',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0
                ),
              ),
              subtitle: Text(product.id),
              onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
            )
          ],
        ),
      ),
      onDismissed: (direction) => productsProvider.deleteProduct(product.id),
    );
  }

  Widget _createFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.pushNamed(context, 'product');
      },
    );
  }
}
