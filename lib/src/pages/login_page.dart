import 'package:flutter/material.dart';

import 'package:form_validator/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          createFondo(context),
          createForm(context),
        ],
      ),
    );
  }

  // ------------------------ FORMULARIO
  Widget createForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),

          Container(
            width: size.width * .85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 2.5
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Ingreso',
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),

                SizedBox(height: 60.0),
                createEmailField(bloc),
                SizedBox(height: 30.0),
                createPasswordField(bloc),
                SizedBox(height: 30.0),
                createButton(bloc)

              ],
            ),
          ),

          Text('¿Olvido su contraseña?'),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  // ------------------------ EMAIL FIELD
  Widget createEmailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(
                Icons.alternate_email,
                color: Colors.deepPurple,
              ),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              errorText: snapshot.error,
              counterText: snapshot.data
            ),
            onChanged: (String value) => bloc.changeEmail(value),
          ),
        );
      },
    );
  }

  // ------------------------ PASSWORD FIELD
  Widget createPasswordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: Colors.deepPurple,
              ),
              labelText: 'Contraseña',
              errorText: snapshot.error,
              counterText: snapshot.data
            ),
            onChanged: (String value) => bloc.changePassword(value),
          ),
        );
      },
    );
  }

  // ------------------------ BUTTON
  Widget createButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {    
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: (snapshot.hasData) ? () => _login(context, bloc) : null,
        );
      },
    );
  }

  // ------------------------ RECIBIR LA ÚLTIMA DATA DE LOS STREAMS
  void _login(BuildContext context, LoginBloc bloc) {
    // -- La referencia de bloc se ocupa para desarrollo
    // print('Email ${bloc.email}');
    // print('Password ${bloc.password}');
    Navigator.pushReplacementNamed(context, 'home');
  }

  // ------------------------ FONDO
  Widget createFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * .4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    // ------------------------ CIRCULO
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, .05)
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(
          top: 90.0,
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          right: -30.0,
          child: circulo,
        ),

        // ------------------------ PIN CON NOMBRE
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 100.0,
              ),
              SizedBox(height: 10.0, width: double.infinity),
              Text(
                'Acxel Morales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}