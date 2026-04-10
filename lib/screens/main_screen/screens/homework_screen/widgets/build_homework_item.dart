
 import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/homework.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/modal_bottom_sheet/show_detail.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/service/get_status_color.dart';

Widget buildHomeworkItem(BuildContext context, HomeworkItem e) {
  final status = e.status;
  final color = getStatusColor(status);
  final mark = e.homeworkStud?.mark;

  return GestureDetector(
    onTap: () => showDetail(context, e),
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.nameSpec,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        if (mark != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: Colors.amber.shade300, width: 1),
                            ),
                            child: Text(
                              "★ $mark",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.theme,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd.MM.yyyy')
                              .format(e.completionTime ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          e.fioTeach,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    if (e.homeworkStud != null && status != 0) ...[
                      Row(
                        children: [
                          Icon(Icons.check,
                              size: 12, color: const Color.fromARGB(255, 0, 150, 5)),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd.MM.yyyy')
                                .format(e.homeworkStud?.creationTime ?? DateTime.now()),
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color.fromARGB(255, 0, 150, 5),
                            ),
                          ),
                        ],
                      ),
                    ] else if (status == 0) ...[
                      Text(
                        "Истекший",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.chevron_right,
                  size: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}