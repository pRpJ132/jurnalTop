import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background-draw.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 60),
            Center(
              child: Text(
                'Journal',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 30),
            drawerItem(
              CupertinoIcons.chart_bar_circle_fill,
              'Главная',
              selected: true,
            ),
            drawerItem(CupertinoIcons.calendar_circle_fill, 'Расписание'),
            drawerItem(CupertinoIcons.book_circle_fill, 'Оценки'),
            drawerItem(CupertinoIcons.doc_circle_fill, 'ДЗ'),
            drawerItem(CupertinoIcons.bookmark_fill, 'Учебные материалы'),
            drawerItem(CupertinoIcons.bell_circle_fill, 'Объявления'),
            drawerItem(CupertinoIcons.star_circle_fill, 'Награды'),
            drawerItem(CupertinoIcons.pencil_circle_fill, 'Отзывы о студенте'),
            drawerItem(CupertinoIcons.person_circle_fill, 'Личный кабинет'),
            drawerItem(CupertinoIcons.question_circle_fill, 'F.A.Q.'),
            drawerItem(CupertinoIcons.location_circle_fill, 'Контакты'),
            drawerItem(CupertinoIcons.chart_bar_circle_fill, 'Обращения'),
            drawerItem(CupertinoIcons.exclamationmark_circle_fill, 'Жалобы'),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(137, 0, 0, 0),
                  width: 8,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.cart_fill_badge_plus,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Маркет',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 45),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(IconData icon, String text, {bool selected = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(
        text,
        style: TextStyle(
          color: selected
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(179, 0, 0, 0),
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {},
    );
  }
}
