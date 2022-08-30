import'package:flutter/material.dart';

import '../widgets/booking_action_button.dart';
import 'booking_page.dart';
import 'finish_page.dart';
class ConfirmBookingModal extends StatelessWidget {
  const ConfirmBookingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,//el tamaño de la ventana que se abre
      //pantalla que sale al oprimir Book Now
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _BookingTitle(value: 'Confirm'),
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
          _BookingInfo(value: "10/04/2021 10:00AM"),
          SizedBox(height: 10),
          _BookingInfo(value: "Price:\$45"),
          SizedBox(height: 50,),
          BookingActionButton(
            label: 'Book Now',
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(FinishPage.route);
            },
          )
        ],
      ),
    );
  }
}

class _BookingTitle extends StatelessWidget {
  const _BookingTitle({
    Key? key, required this.value,
  }) : super(key: key);
  final String value;

  @override
  Widget build(BuildContext context) {


    return Text(
      value,
      style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.w300),
      textAlign: TextAlign.center,
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
      value,
      style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }
}