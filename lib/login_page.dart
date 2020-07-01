import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:flutter_deriv_api/state/connection/connection_bloc.dart'
    as api_connection;
import 'package:flutter_tdd_login/login_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  api_connection.ConnectionBloc _connectionBloc;

  @override
  void initState() {
    super.initState();

    _connectionBloc = api_connection.ConnectionBloc(ConnectionInformation());
  }

  @override
  void dispose() {
    _connectionBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (BuildContext context) => _connectionBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter TDD Login'),
          ),
          body: BlocBuilder<api_connection.ConnectionBloc,
              api_connection.ConnectionState>(
            builder: (
              BuildContext context,
              api_connection.ConnectionState state,
            ) {
              if (state is api_connection.Connected) {
                return Center(child: Login());
              } else if (state is api_connection.InitialConnectionState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is api_connection.ConnectionError) {
                return Center(child: Text('Connection Error\n${state.error}'));
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );
}
