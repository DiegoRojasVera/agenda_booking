import 'package:agenda_booking/models/category.dart';
import 'package:agenda_booking/models/service.dart';
import 'package:agenda_booking/pages/booking_page.dart';
import 'package:agenda_booking/providers/services_provider.dart';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

        () async {
      await Future.delayed(Duration.zero);
      final servicesProvider = Provider.of<ServicesProvider>(
        context,
        listen: false,
      );

      if (servicesProvider.categories.length == 0) {
        servicesProvider.loadCategories();
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);

    return Scaffold(
      body: servicesProvider.isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Utils.secondaryColor,
          ),
        ),
      )
          : Stack(
        children: [
          _PageViewCategories(),
          _WhiteBox(),
        ],
      ),
    );
  }
}

class _PageViewCategories extends StatefulWidget {
  const _PageViewCategories({Key? key}) : super(key: key);

  @override
  __PageViewCategoriesState createState() => __PageViewCategoriesState();
}

class __PageViewCategoriesState extends State<_PageViewCategories> {
  @override
  void dispose() {
    final servicesProvider = Provider.of<ServicesProvider>(
      context,
      listen: false,
    );
    servicesProvider.pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    servicesProvider.pageController = PageController(initialPage: 0);

    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: servicesProvider.pageController,
      itemCount: servicesProvider.categories.length,
      itemBuilder: (_, int index) {
        return _CategoryPageView(
          path: servicesProvider.categories[index].photo,
        );
      },
    );
  }
}

class _WhiteBox extends StatelessWidget {
  const _WhiteBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: size.height * 0.74,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: RefreshIndicator(
                  color: Utils.primaryColor,
                  onRefresh: () => servicesProvider.loadCategories(),
                  child: _HomeServices(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeServices extends StatelessWidget {
  const _HomeServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Services',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 20.0),
            _CategoriesCarousel(
              categories: servicesProvider.categories,
            ),
            SizedBox(height: 20.0),
            servicesProvider.category == null
                ? Container(
              child: Text('Seleccione primero una categoría.'),
            )
                : _ServicesList(
              services: servicesProvider.category!.services,
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
      height: 500.0,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        itemBuilder: (_, int index) {
          Service service = services[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                BookingPage.route,
                arguments: service,
              );
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
            color: Utils.grayColor,
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
    final servicesProvider = Provider.of<ServicesProvider>(context);

    return Container(
      height: 120.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, int index) {
          Category category = categories[index];

          final categoryItem = _CategoryItem(
            icon: servicesProvider.icons[category.icon]!,
            label: category.name,
            isSelected: servicesProvider.category?.id == category.id,
            onTap: () => servicesProvider.selectCategory(category),
          );

          if (index == 0) {
            return Row(
              children: [
                SizedBox(width: 20.0),
                categoryItem,
              ],
            );
          }
          if (index == categories.length - 1) {
            return Row(
              children: [
                categoryItem,
                SizedBox(width: 20.0),
              ],
            );
          }
          return categoryItem;
        },
        separatorBuilder: (_, int index) {
          return SizedBox(width: 15.0);
        },
      ),
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
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Utils.secondaryColor : Utils.primaryColor,
              ),
              child: Icon(
                icon,
                size: 44.0,
                color: isSelected ? Colors.white : Utils.secondaryColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPageView extends StatelessWidget {
  const _CategoryPageView({
    Key? key,
    required this.path,
  }) : super(key: key);

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

