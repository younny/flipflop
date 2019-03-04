import 'package:flipflop/models/flipflop_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/pages/home_page.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (_, bloc) {
          return FlipFlopBloc(FlipFlopApi());
        },
        onDispose: (_, bloc) => bloc.dispose(),
        child: RootApp()
    );
  }
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            fontFamily: 'Binggrae',
            primarySwatch: Colors.amber,
          ),
          child: widget,
        );
      }
    );
  }
}