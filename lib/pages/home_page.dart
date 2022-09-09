import 'package:agenda_booking/models/service.dart';
import 'package:agenda_booking/models/category.dart';
import 'package:agenda_booking/providers/services_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/search_box.dart';
import 'booking_page.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServicesProvider servicesProvider = Provider.of<ServicesProvider>(context);
    return Scaffold(
      body: servicesProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: servicesProvider.pageController,
                  itemCount: servicesProvider.categories.length,
                  itemBuilder: (_, int index) {
                    return _CategoryPageView(
                      path: servicesProvider.categories[index].photo,
                    );
                  },
                ),
                const _WhiteBox(),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      //la altura del texto del buscador
                      child: SearchBox(),
                    )),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FloatingActionButton(
          elevation: 0.0,
          mini: true,
          backgroundColor: servicesProvider.isSearchVisible
              ? Utils.sencondaryColor
              : Theme.of(context).primaryColor,
          child: servicesProvider.isSearchVisible
              ? Icon(Icons.close)
              : Icon(Icons.search),
          onPressed: () {
            servicesProvider.isSearchVisible =
                !servicesProvider.isSearchVisible;
          },
        ),
      ),
    );
  }
}

class _WhiteBox extends StatelessWidget {
  const _WhiteBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServicesProvider servicesProvider = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: size.height * 0.72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                    ]),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: RefreshIndicator(
                    color: Utils.primaryColor,
                    onRefresh: () => servicesProvider.loadCategories(),
                    child: _HomeServices()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeServices extends StatelessWidget {
  const _HomeServices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServicesProvider servicesProvider = Provider.of<ServicesProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Services',
                  style: Theme.of(context).textTheme.headline6),
            ),
            const SizedBox(
              height: 20,
            ),
            _CategoriesCarousel(
              categories: servicesProvider.categories,
            ),
            const SizedBox(
              height: 20,
            ),
            _ServicesList(
              services: servicesProvider.category.services,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesList extends StatelessWidget {
  const _ServicesList({
    Key? key,
    required this.services,
  }) : super(key: key);

  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (_, int index) {
          Service service = services[index];
          return ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(BookingPage.route, arguments: service);
            },
            title: Text(service.name),
            trailing: Text(
              "\$${service.price}",
              style: TextStyle(color: Utils.grayColor),
            ),
          );
        },
        separatorBuilder: (_, int index) {
          return Divider(
            color: Utils.sencondaryColor,
          );
        },
        itemCount: services.length,
      ),
    );
  }
}

class _CategoriesCarousel extends StatelessWidget {
  const _CategoriesCarousel({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final ServicesProvider servicesProvider =
        Provider.of<ServicesProvider>(context);
    return SizedBox(
        height: 90, // modificar el espacio de los iconos de servicios
        child: NewWidget1(categories: categories, servicesProvider: servicesProvider));
  }
}

class NewWidget1 extends StatelessWidget {
  const NewWidget1({
    Key? key,
    required this.categories,
    required this.servicesProvider,
  }) : super(key: key);

  final List<Category> categories;
  final ServicesProvider servicesProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(

      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (_, int index) {
        Category category = categories[index];
        final categoryItem = _CategoryItem(
          icon: servicesProvider.icons[category.icon]!,
          label: category.name,
          onTap: () => servicesProvider.selectCategory(category),
          isSelected: servicesProvider.category.id == category.id,
        );

        if (index == 0) {
          return Row(
            children: [
              const SizedBox(width: 10),
              categoryItem,
            ],
          );
        }
        if (index == categories.length - 1) {
          return Row(
            children: [
              categoryItem,
              const SizedBox(width: 20),
            ],
          );
        }
        return categoryItem;
      },
      separatorBuilder: (_, int index) {
        return const SizedBox(width: 15); // se paracion entre los iconos
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? Utils.sencondaryColor : Utils.primaryColor,
                ),
                child: Icon(
                  icon,
                  size: 40, // tamaño del los dibujos en los iconos
                  color: isSelected ? Colors.white : Utils.sencondaryColor,
                )),
            //     SizedBox(
            //      height: 5,
            //    ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 16), // tamaño de las letras de los sercicios iconos
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPageView extends StatelessWidget {
  const _CategoryPageView({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: FadeInImage(
        placeholder: const AssetImage('assets/haircut.jpg'),
        image: NetworkImage(path),
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }
}
