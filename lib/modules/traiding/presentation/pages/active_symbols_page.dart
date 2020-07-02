import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_deriv_api/state/connection/connection_bloc.dart'
    as connection;
import 'package:flutter_tdd_login/modules/traiding/presentation/widgets/active_symbol.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter TDD'),
        ),
        body:
            BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
          builder: (
            BuildContext context,
            connection.ConnectionState state,
          ) {
            if (state is connection.Connected) {
              return ActiveSymbol();
            } else if (state is connection.InitialConnectionState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is connection.ConnectionError) {
              return Center(child: Text('Connection Error\n${state.error}'));
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      );
}
