import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:flutter_deriv_api/state/connection/connection_bloc.dart'
    as connection;
import 'package:flutter_tdd_login/modules/traiding/presentation/blocs/active_symbols/active_symbols_bloc.dart';
import 'package:flutter_tdd_login/modules/traiding/presentation/pages/active_symbols_page.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  connection.ConnectionBloc _connectionBloc;

  @override
  void initState() {
    super.initState();

    _connectionBloc = connection.ConnectionBloc(ConnectionInformation());
  }

  @override
  void dispose() {
    _connectionBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TDD',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => _connectionBloc,
          ),
          BlocProvider(
            create: (context) => ActiveSymbolsBloc(),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
