import 'package:agenda_booking/pages/home_page.dart';
import 'package:agenda_booking/providers/services_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:agenda_booking/widgets/booking_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/booking_action_button.dart';

class FinishPage extends StatelessWidget {
  static final String route = 'finish';

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.headline3?.copyWith(
      fontWeight: FontWeight.w700,
      color: Utils.primaryColor,
    );
    final subtitle = Theme.of(context).textTheme.headline5?.copyWith(
      fontWeight: FontWeight.w300,
    );
    final servicesProvider = Provider.of<ServicesProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Done!', style: title),
            SizedBox(height: 20.0),
            Text(
              'We will be waiting for you with the best service.',
              style: subtitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100.0),
            BookingActionButton(
              label: 'Home',
              onPressed: () {
                servicesProvider.cleanAll();
                Navigator.of(context).pushReplacementNamed(HomePage.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}

