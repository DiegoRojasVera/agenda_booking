import 'package:agenda_booking/pages/booking_page.dart';
import 'package:agenda_booking/pages/finish_page.dart';
import 'package:agenda_booking/pages/home_page.dart';
import 'package:agenda_booking/providers/services_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ServicesProvider())],
      child: MaterialApp(
        title: 'Agenda App',
        initialRoute: HomePage.route,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Utils.primaryColor,
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: ThemeData.light().textTheme.bodyText1?.copyWith(
                      color: Utils.sencondaryColor,
                    ),
                bodyText2: ThemeData.light().textTheme.bodyText1?.copyWith(
                      color: Utils.sencondaryColor,
                    ),
                subtitle1: ThemeData.light().textTheme.subtitle1?.copyWith(
                      color: Utils.sencondaryColor,
                    ),
                headline6: ThemeData.light().textTheme.headline6!.copyWith(
                      color: Utils.sencondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                headline5: ThemeData.light().textTheme.headline5!.copyWith(
                      color: Utils.sencondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
              ),
        ),
        routes: {
          HomePage.route: (_) => const HomePage(),
          BookingPage.route: (_) => const BookingPage(),
          FinishPage.route: (_) => FinishPage(),
        },
      ),
    );
  }
}
