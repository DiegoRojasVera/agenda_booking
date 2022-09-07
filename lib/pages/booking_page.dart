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

  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
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
        backgroundColor: Utils.primaryColor,
        title: const Text('Set Appointment'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: RefreshIndicator(
        // el simbolo del cargador
        color: Utils.sencondaryColor, // color de pensador de recarga
        onRefresh: () => servicesProvider.loadServiceForBooking(service),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: _BookingMainContent()),
            BookingActionButton(
                label: 'Book Now',
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const ConfirmBookingModal();
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}

class _BookingMainContent extends StatelessWidget {
  const _BookingMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    List<Widget> times = [];
    //Bloquear fechas no disponible para los estilistas.
    //Horario de atencion de 10:00 am hasta las 8:pm
    for (var i = 10; i < 20; i++) {
      final String am = i < 12 ? 'AM' : 'PM';
      final String hour = i < 10 ? "0$i" : "$i";

      // eleccion de estar del boton de horario
      int status = _BookingTime.normal;
      final stylist = servicesProvider.stylist;
      final current = DateTime(servicesProvider.year, servicesProvider.month,
          servicesProvider.day, i, 0, 0);

      //Si la fecha selecionada es igual a la fecha
      //actual en el loop se marca como seleccionada.
      if (servicesProvider.currentDate.compareTo(current) == 0) {
        status = _BookingTime.selected;
      }
      //la fecha minima debes ser actual
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
        time: "$hour:00 $am",
        onTap: () => servicesProvider.hour = i,
      ));
    }

    return servicesProvider.isLoadingService
        ? Column(
            children: [
              Calendar(),
              //Error en uso de Expanded en ListView
              Row(
                children: [
                  Expanded(
                    child: CircularProgressIndicator(
                        color: Utils
                            .primaryColor // cambio de color del simbolo del carga
                        ),
                  ),
                ],
              ),
            ],
          )
        : ListView(
            children: [
              const Calendar(),
              const _Subtitle(subtitle: 'Stylists'),
              const SizedBox(height: 5),
              StylistsList(stylists: servicesProvider.bookingService!.stylists),
              const SizedBox(height: 10),
              const _Subtitle(subtitle: 'Available Time'),
              const SizedBox(height: 10),
              Container(
                height: (times.length / 3).ceil() * 50,
                // da la dimension de las letras de los horarios
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  // para no desplazar el scroll por mas que esten aparte
                  children: times,
                ),
              ),
            ],
          );
  }
}

class _BookingTime extends StatelessWidget {
  const _BookingTime(
      {Key? key, required this.time, required this.status, required this.onTap})
      : super(key: key);

  final String time;
  final int status;
  final Function() onTap;

  static final int normal = 1;
  static final int selected = 2;
  static final int blocked = 3;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Utils.primaryColor!;
    Color textColor = Colors.white;

    if (status == selected) {
      backgroundColor = Utils.sencondaryColor;
    } else if (status == blocked) {
      backgroundColor = Utils.grayColor;
    }
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: status == normal ? onTap : null,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        splashColor: Utils.sencondaryColor,
        child: Ink(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              time,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: textColor,
                    fontSize: 20,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class StylistsList extends StatelessWidget {
  const StylistsList({
    Key? key,
    required this.stylists,
  }) : super(key: key);

  final List<Stylist> stylists;

  @override
  Widget build(BuildContext context) { // los estilistas
    final _servicesProvider = Provider.of<ServicesProvider>(context);
    return Container(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stylists.length,
        itemBuilder: (_, int index) {
          final stylist = stylists[index];
          final isSelected = _servicesProvider.stylist != null &&
              _servicesProvider.stylist?.id == stylist.id;


          //final isSelected = _servicesProvider.stylist?.id == stylist.id;

          if (index == 0) {
            return Row(
              children: [
                SizedBox(width: 20.0),
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
          return SizedBox(width: 20);
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
      child: Text(subtitle,
          style: Theme.of(context).textTheme.headline5?.copyWith(
                fontWeight: FontWeight.w300,
              )),
    );
  }
}

//Modelo temporal

class StylistCard extends StatelessWidget {
  const StylistCard(
      {Key? key,
      required this.stylist,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  final Stylist stylist;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      //seleccion de estilistas
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        onTap: isSelected ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.all(10.0),
          //Dimension de el listado de stulistas
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            border: Border.all(
              color: isSelected ? Utils.grayColor : Utils.primaryColor!,
              width: 2.0,
            ),
          ),

          child: Column(
            children: [
              Container(
                //Fichas con fotos de los stilistas
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/stylist.jpg'),
                  // foto que sale unos segunos para cargar!!
                  image: NetworkImage(stylist.photo),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                stylist.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "${stylist.score}",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Utils.primaryColor),
                  ),
                  Icon(
                    Icons.star,
                    color: Utils.primaryColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
