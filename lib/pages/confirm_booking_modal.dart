import 'package:agenda_booking/providers/booking_provider.dart';
import 'package:agenda_booking/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../widgets/booking_action_button.dart';
import 'booking_page.dart';
import 'finish_page.dart';

class ConfirmBookingModal extends StatelessWidget {
  const ConfirmBookingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    final date = formatDate(servicesProvider.currentDate);
    final stylist = servicesProvider.stylist?.name;
    final price = servicesProvider.bookingService?.price;

    bookingProvider.initData(servicesProvider.stylist!.id,
        servicesProvider.bookingService!.id, servicesProvider.currentDate);

    return Container(
      height: MediaQuery.of(context).size.height *
          0.7, //el tamaño de la ventana que se abre
      //pantalla que sale al oprimir Book Now
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _BookingTitle(value: 'Confirm'),
          TextField(
            onChanged: (String value) {
              bookingProvider.name = value;
            },
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: bookingProvider.nameError,
            ),
          ),
          TextField(
            onChanged: (String value) {
              bookingProvider.phone = value;
            },
            decoration: InputDecoration(
              labelText: 'Phone',
              errorText: bookingProvider.phoneError,
            ),
          ),
          const SizedBox(height: 50),
          _BookingInfo(value: date),
          const SizedBox(height: 5),
          _BookingInfo(value: "With: $stylist"),
          const SizedBox(height: 10),
          _BookingInfo(value: "Price:\$$price"),
          const SizedBox(height: 50),
          bookingProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : BookingActionButton(
                  label: 'Book Now',
                  onPressed: bookingProvider.canSend
                      ? () => sendResquest(context, bookingProvider)
                      : null)
        ],
      ),
    );
  }

  void sendResquest(
      BuildContext context, BookingProvider bookingProvider) async {
    bookingProvider.isLoading = true;
    final success = await bookingProvider.save();
    bookingProvider.isLoading = false;

    if (success) {
      bookingProvider.clean();
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed(FinishPage.route);
    }
  }
}

class _BookingTitle extends StatelessWidget {
  const _BookingTitle({
    Key? key,
    required this.value,
  }) : super(key: key);
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.w300),
      textAlign: TextAlign.center,
    );
  }
}

class _BookingInfo extends StatelessWidget {
  const _BookingInfo({
    Key? key,
    required this.value,
  }) : super(key: key);
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }
}
