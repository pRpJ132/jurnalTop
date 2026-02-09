
import 'package:flutter/material.dart';

class ReitingInfoMenu extends StatefulWidget {
  const ReitingInfoMenu({super.key});

  @override
  State<ReitingInfoMenu> createState() => _ReitingInfoMenuState();
}

class _ReitingInfoMenuState extends State<ReitingInfoMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Рейтинг", 
              style: TextStyle(
                fontSize: 27,
              ),
            ),
            Divider(),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 400;

                if (isWide) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("2 место в группе", style: TextStyle(fontSize: 24)),
                      Text("54 место в потоке", style: TextStyle(fontSize: 24)),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("2 место в группе", style: TextStyle(fontSize: 24)),
                      SizedBox(height: 8),
                      Text("54 место в потоке", style: TextStyle(fontSize: 24)),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}