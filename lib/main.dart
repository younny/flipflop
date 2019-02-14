import 'package:flutter/material.dart';

import 'package:flip/blocs/card_bloc.dart';
import 'package:flip/components/home_page.dart';
import 'package:flip/providers/base_provider.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CardBloc>(
      builder: (_, bloc) => bloc ?? CardBloc(

      ),
      onDispose: (_, bloc) => bloc.dispose(),
      child: RootApp(),
    );
  }
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardBloc = Provider.of<CardBloc>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber,
          disabledColor: Colors.grey
        ),
        fontFamily: 'LuckiestGuy',
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: HomePage()
      ),
    );
  }
}