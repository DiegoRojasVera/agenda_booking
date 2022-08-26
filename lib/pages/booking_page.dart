import 'dart:developer';
import 'dart:core';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:agenda_booking/models/service.dart';
import '../widgets/calendar.dart';

class BookingPage extends StatelessWidget {
  static final String route = '/booking';

  const BookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Service service = ModalRoute.of(context)?.settings.arguments as Service;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: _BookingMainContent()),
          _BookingActionButton(onPressed: () {})
        ],
      ),
    );
  }
}

class _BookingActionButton extends StatelessWidget {
  const _BookingActionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // Boton del socalo
    return Container(
      color: Colors.white, // se transforma en traparente si sacamos eso
      padding: EdgeInsets.all(10),
      //  height: 80, // socalo de abajo fijo
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,//Boton del socalo de abajo
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 70),
              primary: Utils.sencondaryColor,
              shape: const StadiumBorder()),
          child: const Text('Book Now',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
        ),
      ),
    );
  }
}

class _BookingMainContent extends StatelessWidget {
  const _BookingMainContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget>times=[
      BookingTime(time: "10:00 AM", status: BookingTime.normal),
      BookingTime(time: "10:00 AM", status: BookingTime.normal),
      BookingTime(time: "10:00 AM", status: BookingTime.selected),
      BookingTime(time: "10:00 AM", status: BookingTime.normal),
      BookingTime(time: "10:00 AM", status: BookingTime.normal),
      BookingTime(time: "10:00 AM", status: BookingTime.normal),
      BookingTime(time: "10:00 AM", status: BookingTime.normal),
      BookingTime(time: "10:00 AM", status: BookingTime.blocked),
      BookingTime(time: "10:00 AM", status: BookingTime.normal),
    ];
    return ListView(
      children: [
        const Calendar(),
        const _Subtitle(subtitle: 'Stylists'),
        const SizedBox(height: 5),
        StylistsList(
          stylists: _stylist,
        ),
        const SizedBox(height: 10),
        const _Subtitle(subtitle: 'Available Time'),
        const SizedBox(height: 10),
        Container(

          height: (times.length/3).ceil()*50, // da la dimension de las letras de los horarios
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

class BookingTime extends StatelessWidget {
  const BookingTime({Key? key, required this.time, required this.status})
      : super(key: key);

  final String time;
  final int status;

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
        onTap: status == normal ? () {} : null,
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
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _stylist.length,
        itemBuilder: (_, int index) {
          if (index == 0) {
            return Row(
              children: [
                SizedBox(width: 20),
                StylistCard(stylist: _stylist[index], isSelected: false),
              ],
            );
          }
          if (index == _stylist.length - 1) {
            return Row(
              children: [
                SizedBox(width: 20),
                StylistCard(
                  stylist: _stylist[index],
                  isSelected: false,
                ),
              ],
            );
          }
          return StylistCard(
            stylist: _stylist[index],
            isSelected: index == 1,
          );
        },
        separatorBuilder: (_, int index) {
          return SizedBox(
            width: 20,
          );
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
class Stylist {
  late int id;
  late String name;
  late double score;

  Stylist({required this.id, required this.name, required this.score});
}

List<Stylist> _stylist = [
  Stylist(name: 'Elly', score: 3.4, id: 1),
  Stylist(name: 'Ana', score: 3.4, id: 2),
  Stylist(name: 'Clara', score: 3.4, id: 3),
  Stylist(name: 'Pepe', score: 3.4, id: 4),
];

class StylistCard extends StatelessWidget {
  const StylistCard({Key? key, required this.stylist, required this.isSelected})
      : super(key: key);

  final Stylist stylist;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10), //Dimension de el listado de stulistas
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
            color: isSelected ? Utils.sencondaryColor : Utils.primaryColor!,
            width: 2),
      ),
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Image(
              image: AssetImage('assets/stylist.jpg'),
              fit: BoxFit.contain,
              width: 100,
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
    );
  }
}
