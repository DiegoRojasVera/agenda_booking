import 'package:agenda_booking/providers/servides_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServicesProvider servicesProvider =
        Provider.of<ServicesProvider>(context);

    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: servicesProvider.isSearchVisible ? 1 : 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.only(left: 15, right: 70),
        width: servicesProvider.isSearchVisible
            ? MediaQuery.of(context).size.width
            : 0,
        // el ancho del texto del buscador
        child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: Utils.sencondaryColor, blurRadius: 5),
                ]),
            child: TextField(
              decoration: InputDecoration(
                isCollapsed: true,
                //fillColor: Utils.primaryColor,
                hintText: "Search Services",
              ),
            )),
      ),
    );
  }
}
