import 'package:agenda_booking/pages/finish_page.dart';
import 'package:agenda_booking/providers/booking_provider.dart';
import 'package:agenda_booking/providers/services_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:agenda_booking/widgets/booking_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmBookingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    final date = formatDate(servicesProvider.currentDate);
    final stylist = servicesProvider.stylist?.name;
    final price = servicesProvider.bookingService?.price;

    bookingProvider.initData(
      servicesProvider.stylist!.id,
      servicesProvider.bookingService!.id,
      servicesProvider.currentDate,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          _BookingTitle(value: 'Confirm'),
          SizedBox(height: 10.0),
          TextField(
            onChanged: (String value) {
              bookingProvider.name = value;
            },
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: bookingProvider.nameError,
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            onChanged: (String value) {
              bookingProvider.phone = value;
            },
            decoration: InputDecoration(
              labelText: 'Phone',
              errorText: bookingProvider.phoneError,
            ),
          ),
          SizedBox(height: 30.0),
          _BookingInfo(value: "$date"),
          SizedBox(height: 10.0),
          _BookingInfo(value: "With $stylist"),
          SizedBox(height: 10.0),
          _BookingInfo(value: "Price: \$$price"),
          SizedBox(height: 30.0),
          bookingProvider.isLoading
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Utils.secondaryColor,
              ),
            ),
          )
              : BookingActionButton(
            label: 'Book Now',
            onPressed: bookingProvider.canSend
                ? () => sendRequest(context, bookingProvider)
                : null,
          )
        ],
      ),
    );
  }

  void sendRequest(
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
      style: Theme.of(context).textTheme.headline5?.copyWith(
        fontWeight: FontWeight.w300,
      ),
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
      style: Theme.of(context).textTheme.headline6?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }
}

