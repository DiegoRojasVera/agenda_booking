import 'package:agenda_booking/providers/services_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:agenda_booking/models/service.dart';
import 'package:provider/provider.dart';
import '../models/stylist.dart';
import '../widgets/booking_action_button.dart';
import '../widgets/calendar.dart';
import 'confirm_booking_modal.dart';

class BookingPage extends StatefulWidget {
  static const String route = '/booking';

  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      final service = ModalRoute.of(context)?.settings.arguments as Service;
      final servicesProvider = Provider.of<ServicesProvider>(
        context,
        listen: false,
      );

      servicesProvider.clean();
      servicesProvider.loadServiceForBooking(service);
    }();
  }

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)?.settings.arguments as Service;
    final servicesProvider = Provider.of<ServicesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Set Appointment'),
        backgroundColor: Utils.primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => servicesProvider.loadServiceForBooking(service),
         color: Utils.secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _BookingMainContent(),
            ),
            BookingActionButton(
              label: 'Book Now',
              onPressed: !servicesProvider.canFinalizeAppointment
                  ? null
                  : () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return const ConfirmBookingModal();
                        },
                      );
                    },
            )
          ],
        ),
      ),
    );
  }
}

class _BookingMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    List<Widget> times = [];

    // Horario de atención de 10:00 am hasta las 8:00pm (10:00 - 20:00)
    for (var i = 10; i <= 20; i++) {
      int status = _BookingTime.normal;
      final stylist = servicesProvider.stylist;
      final current = DateTime(servicesProvider.year, servicesProvider.month,
          servicesProvider.day, i, 0, 0);

      // Si la fecha seleccionada es igual a la fecha
      // actual en el loop se marca como seleccionada.
      if (servicesProvider.currentDate.compareTo(current) == 0) {
        status = _BookingTime.selected;
      }
      if (servicesProvider.minDate.compareTo(current) > 0) {
        status = _BookingTime.blocked;
      }
      if (stylist != null) {
        stylist.lockedDates.forEach((lockedDate) {
          if (lockedDate.compareTo(current) == 0) {
            status = _BookingTime.blocked;
          }
        });
      }

      times.add(_BookingTime(
        status: status,
        time: formatHour(current),
        onTap: () => servicesProvider.hour = i,
        key: null,
      ));
    }

    return servicesProvider.isLoadingService ||
            servicesProvider.bookingService == null
        ? Column(
            children: [
              const Calendar(),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Utils.secondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        : ListView(
            children: [
              Calendar(),
              SizedBox(height: 5.0),
              _Subtitle(subtitle: 'Stylists'),
              SizedBox(height: 10.0),
              _StylistsList(
                stylists: servicesProvider.bookingService!.stylists,
              ),
              SizedBox(height: 10.0),
              _Subtitle(subtitle: 'Available Time'),
              SizedBox(height: 10.0),
              Container(
                height: (times.length / 3).ceil() * 50.0,
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.9,
                  crossAxisCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  children: times,
                ),
              ),
            ],
          );
  }
}

class _BookingTime extends StatelessWidget {
  const _BookingTime({
    Key? key,
    required this.time,
    this.status,
    required this.onTap,
  }) : super(key: key);

  final String time;
  final int? status;
  final Function() onTap;

  static final int normal = 1;
  static final int selected = 2;
  static final int blocked = 3;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Utils.primaryColor!;
    Color textColor = Colors.white;

    if (status == selected) {
      backgroundColor = Utils.secondaryColor;
    } else if (status == blocked) {
      backgroundColor = Utils.grayColor;
    }

    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      child: InkWell(
        onTap: status == normal ? onTap : null,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        splashColor: Utils.secondaryColor,
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Center(
            child: Text(
              time,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: textColor,
                    fontSize: 20.0,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StylistsList extends StatelessWidget {
  const _StylistsList({
    Key? key,
    required this.stylists,
  }) : super(key: key);

  final List<Stylist> stylists;

  @override
  Widget build(BuildContext context) {
    final _servicesProvider = Provider.of<ServicesProvider>(context);

    return SizedBox(
      height: 200.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stylists.length,
        itemBuilder: (_, int index) {
          final stylist = stylists[index];
          final isSelected = _servicesProvider.stylist != null &&
              _servicesProvider.stylist?.id == stylist.id;

          if (index == 0) {
            return Row(
              children: [
                SizedBox(width: 20),
                StylistCard(
                  stylist: stylist,
                  isSelected: isSelected,
                  onTap: () => _servicesProvider.stylist = stylist,
                ),
              ],
            );
          }
          if (index == stylists.length - 1) {
            return Row(
              children: [
                StylistCard(
                  stylist: stylist,
                  isSelected: isSelected,
                  onTap: () => _servicesProvider.stylist = stylist,
                ),
                SizedBox(width: 20.0),
              ],
            );
          }

          return StylistCard(
            stylist: stylist,
            isSelected: isSelected,
            onTap: () => _servicesProvider.stylist = stylist,
          );
        },
        separatorBuilder: (_, int index) {
          return SizedBox(width: 20.0);
        },
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({
    Key? key,
    required this.subtitle,
  }) : super(key: key);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        subtitle,
        style: Theme.of(context).textTheme.headline5?.copyWith(
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}

class StylistCard extends StatelessWidget {
  const StylistCard({
    Key? key,
    required this.stylist,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final Stylist stylist;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        onTap: isSelected ? null : onTap,
        child: Ink(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.white,
            border: Border.all(
              color: isSelected ? Utils.primaryColor! : Utils.grayColor,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/haircut.jpg'),
                  image: NetworkImage(stylist.photo),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 80,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                stylist.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    "${stylist.score}",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Utils.primaryColor,
                        ),
                  ),
                  Icon(
                    Icons.star,
                    color: Utils.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
