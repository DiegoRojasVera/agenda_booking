import 'dart:developer';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:agenda_booking/models/service.dart';
import '../widgets/calendar.dart';

class BookingPage extends StatelessWidget {
  static final String route = '/booking';

  const BookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Service service = ModalRoute
        .of(context)
        ?.settings
        .arguments as Service;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.primaryColor,
        title: Text('Set Appointment'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Calendar(),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child:
            Text('Stylists', style: Theme
                .of(context)
                .textTheme
                .headline5),
          ),
          const SizedBox(height: 5),
          Container(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _stylist.length,
              itemBuilder: (_, int index) {
                if (index == 0) {
                  return Row(
                    children: [
                      SizedBox(width: 20),
                      StylistCard(
                          stylist: _stylist[index], isSelected: false),
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
          ),
        ],
      ),
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
            color: isSelected ? Utils.sencondaryColor: Utils.primaryColor!,
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
            style: Theme
                .of(context)
                .textTheme
                .headline5,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "${stylist.score}",
                style: Theme
                    .of(context)
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
