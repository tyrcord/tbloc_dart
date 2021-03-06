import 'package:flutter/material.dart';

import 'package:tbloc_dart/tbloc_dart.dart';
import 'counter.bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tBloC Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'tBloC Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final bloc = CounterBloc();

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocProvider(
        bloc: bloc,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Text('INCREMENT'),
                    onPressed: () {
                      bloc.addEvent(CounterBlocEvent.increment());
                    },
                  ),
                  MaterialButton(
                    child: Text('DECREMENT'),
                    onPressed: () {
                      bloc.addEvent(CounterBlocEvent.decrement());
                    },
                  ),
                  MaterialButton(
                    child: Text('RESET'),
                    onPressed: () {
                      bloc.addEvent(CounterBlocEvent.reset());
                    },
                  ),
                ],
              ),
              Text(
                'You have pushed the button this many times:',
              ),
              CounterWidget(),
              MaterialButton(
                child: Text('ERROR'),
                onPressed: () => bloc.addEvent(CounterBlocEvent.error()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);

    return BlocBuilderWidget(
      bloc: bloc,
      builder: (BuildContext context, CounterBlocState state) {
        return Text(
          state.hasError ? state.error.toString() : '${state.counter}',
          style: Theme.of(context).textTheme.headline4,
        );
      },
    );
  }
}
