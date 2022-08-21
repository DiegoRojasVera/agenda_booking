import 'package:agenda_booking/models/service.dart';
import 'package:agenda_booking/models/category.dart';
import 'package:agenda_booking/providers/servides_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        mini: true,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.search),
        onPressed: () {},
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
                child: _HomeServices(),
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
              child: Text('Services'),
            ),
            SizedBox(
              height: 20,
            ),
            _CategoriesCarousel(
              categories: servicesProvider.categories,
            ),
            SizedBox(
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (_, int index) {
          Service service = services[index];
          return ListTile(
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

    return Container(
        height: 70,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (_, int index) {
            Category category = categories[index];
            final categoryItem = _CategoryItem(
              icon: servicesProvider.icons[category.icon]!,
              label: category.name,
              isSelected: servicesProvider.category.id == category.id,
              onTap: () => servicesProvider.selectCategory(category),
            );

            if (index == 0) {
              return Row(
                children: [
                  const SizedBox(width: 20),
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
            return const SizedBox(width: 10);
          },
        ));
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? Utils.sencondaryColor : Utils.primaryColor,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isSelected ? Colors.white : Utils.sencondaryColor,
                )),
            SizedBox(
              height: 5,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 13),
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
        placeholder: AssetImage('assets/haircut.jpg'),
        image: NetworkImage(path),
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }
}
