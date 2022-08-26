import'package:flutter/material.dart';

import '../widgets/booking_action_button.dart';
import 'booking_page.dart';
class ConfirmBookingModal extends StatelessWidget {
  const ConfirmBookingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      //pantalla que sale al oprimir Book Now
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Confirm',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Phone',
            ),
          ),
          SizedBox(height: 50,),
          _BookingInfo(),
          SizedBox(height: 10,),
          Text(
            "Price:\$45",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50,),
          BookingActionButton(
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

class _BookingInfo extends StatelessWidget {
  const _BookingInfo({
    Key? key, required this.value,
  }) : super(key: key);
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      "10/07/2021 10:00 am",
      style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
    );
  }
}