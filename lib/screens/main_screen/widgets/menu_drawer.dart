import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final ValueNotifier<String> pageIndex;
  const CustomDrawer({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.linearToSrgbGamma(),
            image: AssetImage('assets/background-draw.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: ValueListenableBuilder<String>(
          valueListenable: pageIndex,
          builder: (context, currentIndex, _) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    'Journal',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                drawerItem(CupertinoIcons.chart_bar_circle_fill, 'Главная', "main", currentIndex, context),
                drawerItem(CupertinoIcons.calendar_circle_fill, 'Расписание', "schedule", currentIndex, context),
                drawerItem(CupertinoIcons.book_circle_fill, 'Оценки', "grades", currentIndex, context),
                drawerItem(CupertinoIcons.doc_circle_fill, 'ДЗ', "homework", currentIndex, context),
                drawerItem(CupertinoIcons.bookmark_fill, 'Учебные материалы', "materials", currentIndex, context),
                drawerItem(CupertinoIcons.bell_circle_fill, 'Объявления', "announcements", currentIndex, context),
                drawerItem(CupertinoIcons.star_circle_fill, 'Награды', "awards", currentIndex, context),
                drawerItem(CupertinoIcons.pencil_circle_fill, 'Отзывы о студенте', "feedback", currentIndex, context),
                drawerItem(CupertinoIcons.creditcard_fill, 'Оплата', "payment", currentIndex, context),
                drawerItem(CupertinoIcons.person_circle_fill, 'Личный кабинет', "profile", currentIndex, context),
                drawerItem(CupertinoIcons.question_circle_fill, 'F.A.Q.', "faq", currentIndex, context),
                drawerItem(CupertinoIcons.location_circle_fill, 'Контакты', "contacts", currentIndex, context),
                drawerItem(CupertinoIcons.chart_bar_circle_fill, 'Обращения', "requests", currentIndex, context),
                drawerItem(CupertinoIcons.exclamationmark_circle_fill, 'Жалобы', "complaints", currentIndex, context),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    pageIndex.value = "market";
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(137, 0, 0, 0),
                        width: 8,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.cart_fill_badge_plus,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Маркет',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 45),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget drawerItem(
    IconData icon,
    String text,
    String indexPage,
    String currentIndexPage,
    BuildContext context,
  ) {
    final bool selected = indexPage == currentIndexPage;

    return ListTile(
      leading: Icon(
        icon,
        color: selected
            ? Colors.black
            : const Color.fromARGB(179, 0, 0, 0),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: selected
              ? Colors.black
              : const Color.fromARGB(179, 0, 0, 0),
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          fontSize: selected ? 18 : 14,
        ),
      ),
      onTap: () {
        pageIndex.value = indexPage;
        Navigator.pop(context);
      },
      selected: selected,
      selectedTileColor: Colors.black.withOpacity(0.05),
    );
  }
}