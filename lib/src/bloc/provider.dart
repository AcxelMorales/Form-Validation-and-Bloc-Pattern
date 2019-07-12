import 'package:flutter/material.dart';

import 'package:form_validator/src/bloc/login_bloc.dart';
export 'package:form_validator/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instance;

  factory Provider({ Key key, Widget child }) {
    if (_instance == null) {
      _instance = Provider._internal(key: key, child: child);
    }

    return _instance;
  }
  
  Provider._internal({ Key key, Widget child }): super(key: key, child: child);

  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).loginBloc;
  }
}