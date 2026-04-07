import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final ValueNotifier<int> pageIndex;
  const CustomDrawer({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background-draw.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: ValueListenableBuilder<int>(
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

                drawerItem(CupertinoIcons.chart_bar_circle_fill, 'Главная', 0, currentIndex, context),
                drawerItem(CupertinoIcons.calendar_circle_fill, 'Расписание', 1, currentIndex, context),
                drawerItem(CupertinoIcons.book_circle_fill, 'Оценки', 2, currentIndex, context),
                drawerItem(CupertinoIcons.doc_circle_fill, 'ДЗ', 3, currentIndex, context),
                drawerItem(CupertinoIcons.bookmark_fill, 'Учебные материалы', 4, currentIndex, context),
                drawerItem(CupertinoIcons.bell_circle_fill, 'Объявления', 5, currentIndex, context),
                drawerItem(CupertinoIcons.star_circle_fill, 'Награды', 6, currentIndex, context),
                drawerItem(CupertinoIcons.pencil_circle_fill, 'Отзывы о студенте', 7, currentIndex, context),
                drawerItem(CupertinoIcons.person_circle_fill, 'Личный кабинет', 8, currentIndex, context),
                drawerItem(CupertinoIcons.question_circle_fill, 'F.A.Q.', 9, currentIndex, context),
                drawerItem(CupertinoIcons.location_circle_fill, 'Контакты', 10, currentIndex, context),
                drawerItem(CupertinoIcons.chart_bar_circle_fill, 'Обращения', 11, currentIndex, context),
                drawerItem(CupertinoIcons.exclamationmark_circle_fill, 'Жалобы', 12, currentIndex, context),

                const SizedBox(height: 20),

                Container(
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
    int index,
    int currentIndex,
    BuildContext context,
  ) {
    final bool selected = index == currentIndex;

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
        ),
      ),
      onTap: () {
        pageIndex.value = index;
        Navigator.pop(context);
      },
      selected: selected,
      selectedTileColor: Colors.black.withOpacity(0.05),
    );
  }
}