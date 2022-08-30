import 'package:agenda_booking/widgets/booking_action_button.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'home_page.dart';

class FinishPage extends StatelessWidget {
  static final String route = '/finish';

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.headline3!.copyWith(
          fontWeight: FontWeight.w800,
          color: Utils.sencondaryColor,
        );
    final subtitle = Theme.of(context)
        .textTheme
        .headline5!
        .copyWith(fontWeight: FontWeight.w300);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Done!', style: title),
            SizedBox(
              height: 20,
            ),
            Text(
              'We will be waiting for you with the best service.!',
              style: subtitle,
              textAlign: TextAlign.center,
            ),
            BookingActionButton(
              label: 'Home',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(HomePage.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
