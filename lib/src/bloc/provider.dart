import 'package:flutter/material.dart';

import 'package:Fluttergram/src/bloc/login_bloc.dart';
export 'package:Fluttergram/src/bloc/login_bloc.dart';

import 'package:Fluttergram/src/bloc/product_bloc.dart';
export 'package:Fluttergram/src/bloc/product_bloc.dart';

class Provider extends InheritedWidget {
  final _loginBloc   = LoginBloc();
  final _productBloc = ProductBloc();

  static Provider _instance;

  factory Provider({ Key key, Widget child }) {
    if (_instance == null) {
      _instance = Provider._internal(key: key, child: child);
    }

    return _instance;
  }
  
  Provider._internal({ Key key, Widget child }): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)._loginBloc;
  }

  static ProductBloc productsBloc (BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)._productBloc;
  }
}