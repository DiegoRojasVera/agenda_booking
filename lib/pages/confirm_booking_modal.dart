import 'package:agenda_booking/providers/services_provider.dart';
import'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../widgets/booking_action_button.dart';
import 'booking_page.dart';
import 'finish_page.dart';
class ConfirmBookingModal extends StatelessWidget {
  const ConfirmBookingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final servicesProvider= Provider.of<ServicesProvider>(context);
    final date= formatDate(servicesProvider.currentDate);
    final stylist = servicesProvider.stylist?.name;
    final price= servicesProvider.bookingService?.price;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,//el tamaño de la ventana que se abre
      //pantalla que sale al oprimir Book Now
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _BookingTitle(value: 'Confirm'),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Phone',
            ),
          ),
          SizedBox(height: 50,),
          _BookingInfo(value: date),
          SizedBox(height: 5),
          _BookingInfo(value: "With: $stylist"),
          SizedBox(height: 10),
          _BookingInfo(value: "Price:\$$price"),
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