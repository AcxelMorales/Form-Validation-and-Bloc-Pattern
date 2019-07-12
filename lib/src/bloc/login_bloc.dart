import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:form_validator/src/bloc/validators.dart';

class LoginBloc with Validators {
  // ----------------- STREAM
  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // ----------------- RECUPERAR DATOS DEL STREAM
  Stream<String> get emailStream    => _emailController.stream.transform(validateEmailWithPattern);
  Stream<String> get passwordStream => _passwordController.stream.transform(validatePasswordLength);

  Stream<bool> get formValidateStream => Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // ----------------- INSERTAR VALORES AL STREAM
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // ----------------- OBTENER LOS ÚLTIMOS DATOS EMITIDOS
  String get email    => _emailController.value;
  String get password => _passwordController.value;

  // ----------------- CERRAR LOS STREAM
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
