import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class HomePage extends StatelessWidget {
  static final String route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: const [
              _CategoryPageView(
                path: 'assets/haircut.jpg',
              ),
              _CategoryPageView(
                path: 'assets/haircut.jpg',
              ),
              _CategoryPageView(
                path: 'assets/haircut.jpg',
              ),
              _CategoryPageView(
                path: 'assets/haircut.jpg',
              ),
            ],
          ),
          const _WhiteBox(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        mini:true,

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
              decoration: BoxDecoration(
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
    List<Category> categories = testCategories();
    List<Service> services = testService();

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
            _CategoriesCarousel(categories: categories),
            SizedBox(
              height: 20,
            ),
            _ServicesList(services: services),
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
    return Container(
        height: 70,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (_, int index) {
            Category category = categories[index];

            final categoryItem = _CategoryItem(
              icon: category.icon,
              label: category.name,
              isSelected: index == 1,
              onTap: () => print(category.name),
            );

            if (index == 0) {
              return Row(
                children: [
                  SizedBox(width: 20),
                  categoryItem,
                ],
              );
            }
            if (index == categories.length - 1) {
              return Row(
                children: [
                  categoryItem,
                  SizedBox(width: 20),
                ],
              );
            }
            return categoryItem;
          },
          separatorBuilder: (_, int index) {
            return SizedBox(width: 10);
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
      child: Image(
        image: AssetImage(path),
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }
}

class Category {
  String name;
  IconData icon;

  Category(this.name, this.icon);
}

class Service {
  late String name;
  late double price;

  Service(this.name, this.price);
}

List<Category> testCategories() {
  return [
    Category('Haircuts1', Icons.cut),
    Category('Haircuts2', Icons.ad_units),
    Category('Haircuts3', Icons.commute_sharp),
    Category('Haircuts4', Icons.cut),
    Category('Haircuts5', Icons.ad_units),
    Category('Haircuts6', Icons.commute_sharp),
    Category('Haircuts7', Icons.cut),
    Category('Haircuts8', Icons.ad_units),
    Category('Haircuts9', Icons.commute_sharp),
    Category('Haircuts10', Icons.commute_sharp),
    Category('Haircuts11', Icons.commute_sharp),
    Category('Haircuts12', Icons.commute_sharp),
  ];
}

List<Service> testService() {
  return [
    Service('Lorem Ipsum 1', 25),
    Service('Lorem Ipsum 2', 65),
    Service('Lorem Ipsum 3', 45),
    Service('Lorem Ipsum 4', 25),
    Service('Lorem Ipsum 5', 15),
    Service('Lorem Ipsum 6', 5),
    Service('Lorem Ipsum 7', 75),
    Service('Lorem Ipsum 8', 15),
    Service('Lorem Ipsum 9', 5),
    Service('Lorem Ipsum 10', 75),
    Service('Lorem Ipsum 11', 15),
    Service('Lorem Ipsum 12', 5),
    Service('Lorem Ipsum 13', 75),
  ];
}
