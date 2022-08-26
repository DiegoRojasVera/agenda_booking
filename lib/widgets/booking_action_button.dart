import 'package:agenda_booking/utils/utils.dart';
import'package:flutter/material.dart';
class BookingActionButton extends StatelessWidget {
  const BookingActionButton({
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
          onPressed: onPressed, //Boton del socalo de abajo
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