import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      builder: (BuildContext context, Widget widget) {
        final lang = Localizations.localeOf(context).languageCode;
        return Theme(
          data: ThemeData(
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.amber,
                disabledColor: Colors.grey
            ),
            fontFamily: lang == 'ko' ? 'DoHyeon' : 'LuckiestGuy',
            primarySwatch: Colors.amber,
          ),
          child: widget,
        );
      }
    );
  }
}