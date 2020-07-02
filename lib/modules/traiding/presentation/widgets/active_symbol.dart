import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_tdd_login/modules/traiding/presentation/blocs/active_symbols/active_symbols_bloc.dart';
import 'package:flutter_tdd_login/modules/traiding/presentation/blocs/ticks/ticks_bloc.dart';
import 'package:flutter_tdd_login/modules/traiding/presentation/widgets/active_symbols_list_dialog.dart';

class ActiveSymbol extends StatefulWidget {
  @override
  _ActiveSymbolState createState() => _ActiveSymbolState();
}

class _ActiveSymbolState extends State<ActiveSymbol> {
  // ignore: close_sinks
  ActiveSymbolsBloc _activeSymbolsBloc;
  TicksBloc _ticksBloc;

  double _lastTickValue = 0;

  @override
  void initState() {
    super.initState();

    _activeSymbolsBloc = BlocProvider.of<ActiveSymbolsBloc>(context)
      ..add(FetchActiveSymbols());
    _ticksBloc = TicksBloc(_activeSymbolsBloc);
  }

  @override
  void dispose() {
    _ticksBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Card(
          child: ListTile(
            title: BlocBuilder(
              bloc: _activeSymbolsBloc,
              builder: (BuildContext context, ActiveSymbolsState state) {
                if (state is ActiveSymbolsLoaded) {
                  return Text(
                    '${state.selectedSymbol.marketDisplayName}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (state is ActiveSymbolsError) {
                  return Text(state.message);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            subtitle: BlocBuilder(
              bloc: _activeSymbolsBloc,
              builder: (BuildContext context, ActiveSymbolsState state) {
                if (state is ActiveSymbolsLoaded) {
                  return Text(
                    '${state.selectedSymbol.displayName}',
                    style: const TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (state is ActiveSymbolsError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              },
            ),
            trailing: BlocBuilder<TicksBloc, TicksState>(
              bloc: _ticksBloc,
              builder: (BuildContext context, TicksState state) {
                if (state is TicksLoaded) {
                  final Color tickColor = state.tick.ask > _lastTickValue
                      ? Colors.green
                      : state.tick.ask == _lastTickValue
                          ? Colors.black
                          : Colors.red;

                  _lastTickValue = state.tick.ask;

                  return Text(
                    '${state.tick?.ask?.toStringAsFixed(3)}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: tickColor,
                    ),
                  );
                }

                if (state is TicksError) {
                  return Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  );
                }

                return Container(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                );
              },
            ),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    BlocProvider<ActiveSymbolsBloc>.value(
                  value: _activeSymbolsBloc,
                  child: ActiveSymbolsListDialog(),
                ),
              );
            },
          ),
        ),
      );
}
