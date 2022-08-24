import 'package:agenda_booking/providers/servides_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 15, // movimiento del nombre del mes
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left_outlined, size: 30.0),
                color: Utils.sencondaryColor,
                onPressed: () {
                  //          ServicesProvider.changeMonth(false);
                },
              ),
              const SizedBox(width: 10.0),
              const Text(
                'Feb',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 10.0),
              IconButton(
                icon: Icon(Icons.arrow_right_outlined, size: 30.0),
                color: Utils.sencondaryColor,
                onPressed: () {
                  //     servicesProvider.changeMonth(true);
                },
              ),
            ],
          ),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _CalendarDay(
                  weekDay: 'Lu',
                  day: 1,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Mar',
                  day: 2,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Mier',
                  day: 3,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Jue',
                  day: 4,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Vier',
                  day: 5,
                  isSelected: true,
                ),
                _CalendarDay(
                  weekDay: 'Sab',
                  day: 6,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Dom',
                  day: 7,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Lu',
                  day: 8,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Mar',
                  day: 9,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Mier',
                  day: 10,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Jue',
                  day: 11,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Vier',
                  day: 12,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Sab',
                  day: 13,
                  isSelected: false,
                ),
                _CalendarDay(
                  weekDay: 'Dom',
                  day: 14,
                  isSelected: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay(
      {Key? key,
      required this.weekDay,
      required this.day,
      required this.isSelected})
      : super(key: key);
  final String weekDay;
  final int day;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Column(
          children: [
            Text(
              "$weekDay",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "$day",
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            isSelected
                ? Container(
                    // el que indica la flecha
                    height: 11,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Utils.sencondaryColor,
                    ),
                  )
                : Container(
                    height: 6,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom:
                              BorderSide(color: Utils.grayColor, width: 1.0),
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
