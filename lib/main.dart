import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/pages/card_stack_page.dart';
import 'package:flipflop/pages/game_page.dart';
import 'package:flipflop/pages/home_page.dart';
import 'package:flipflop/pages/settings_page.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlipFlopBloc>(
        builder: (_, bloc) => bloc
            ?? FlipFlopBloc(FirestoreRepository.instance),
        onDispose: (_, bloc) => bloc.dispose(),
        child: RootApp()
    );
  }
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlipFlop',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR')
      ],
      home: Scaffold(
          backgroundColor: Colors.blueGrey,
          body: HomePage()
      ),
      routes: <String, WidgetBuilder> {
        '/cardstack': (BuildContext context) => CardStackPage(),
        '/game': (BuildContext context) => GamePage(),
        '/settings': (BuildContext context) => SettingsPage()
      },
      builder: (BuildContext context, Widget widget) {
        return Theme(
          data: ThemeData(
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.amber,
                disabledColor: Colors.grey
            ),
            fontFamily: 'Binggrae',
            primarySwatch: Colors.amber,
          ),
          child: widget,
        );
      }
    );
  }
}