import 'package:flutter/material.dart';

import 'package:Fluttergram/src/model/product_model.dart';
import 'package:Fluttergram/src/bloc/provider.dart';
import 'package:Fluttergram/src/settings/user_preferences.dart';

class HomePage extends StatelessWidget {
  final _prefs = UserPreferences();

  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              this._prefs.token = null;
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
      body: _createList(productsBloc),
      floatingActionButton: _createFloatingActionButton(context),
      backgroundColor: Colors.white
    );
  }

  Widget _createList(ProductBloc bloc) {
    return StreamBuilder(
      stream: bloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
        if (snapshot.hasData) {
          final products = snapshot.data;

          if (products.length == 0) {
            Navigator.pushReplacementNamed(context, 'login');
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) => _createItem(context, products[i], bloc),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext context, ProductModel product, ProductBloc bloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
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
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        bloc.deleteProduct(product.id);
        bloc.loadProducts();
      },
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
