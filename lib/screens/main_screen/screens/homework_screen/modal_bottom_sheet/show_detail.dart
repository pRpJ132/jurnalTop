import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/homework.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/dialog/dialog_create_homework.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/service/get_status_color.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/service/get_status_icon.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/service/get_status_text.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/widgets/detail_row.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/widgets/file_card.dart';

void showDetail(BuildContext context, HomeworkItem e) {
  final status = e.status;
  final color = getStatusColor(status);
  final stud = e.homeworkStud;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(getStatusIcon(status),
                          color: color, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        getStatusText(status),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          e.nameSpec,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              e.theme,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            if (e.filePath != null) FileCard(url: e.filePath!),
                          ],
                        ),
                        const Divider(height: 28),
                    
                        detailRow(
                          Icons.person_outline,
                          Colors.grey,
                          "Преподаватель",
                          e.fioTeach,
                        ),
                        const SizedBox(height: 12),
                        detailRow(
                          Icons.calendar_today_outlined,
                          Colors.grey,
                          "Срок сдачи",
                          DateFormat('dd MMMM yyyy', 'ru').format(e.completionTime ?? DateTime.now()),
                        ),
                        const SizedBox(height: 12),
                        detailRow(
                          Icons.add_circle_outline,
                          Colors.lightBlueAccent,
                          "Дата создания",
                          DateFormat('dd MMMM yyyy', 'ru').format(e.creationTime ?? DateTime.now()),
                        ),
                        const SizedBox(height: 12),
                        detailRow(
                          Icons.warning_amber_outlined,
                          Colors.red,
                          "Дедлайн",
                          DateFormat('dd MMMM yyyy', 'ru').format(e.overdueTime ?? DateTime.now()),
                        ),
                        if (e.homeworkStud != null && status != 0) ...[
                          const SizedBox(height: 12),
                          detailRow(
                            Icons.check,
                            Colors.green,
                            "Сдано",
                            DateFormat('dd MMMM yyyy', 'ru').format(e.homeworkStud?.creationTime ?? DateTime.now()),
                          ),
                        ] else if (status == 0) ...[
                          const SizedBox(height: 12),
                          Text(
                            "Истекший",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          )
                        ],
                    
                        if (stud != null) ...[
                          const Divider(height: 28),
                          const Text(
                            "Ваш ответ",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (stud.mark != null)
                            detailRow(
                              Icons.star,
                              Colors.amber.shade500,
                              "Оценка",
                              "${stud.mark}",
                              valueColor: Colors.amber.shade500,
                            ),
                          if (stud.studAnswer != null && stud.studAnswer!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            detailRow(
                              Icons.text_snippet_outlined,
                              Colors.grey,
                              "Текст ответа",
                              stud.studAnswer ?? "-",
                            ),
                          ],
                          if (stud.filePath != null) ...[
                            const SizedBox(height: 10),
                            detailRow(
                              Icons.attach_file,
                              Colors.grey,
                              "Файл ответа",
                              "Прикреплён",
                              valueColor: Colors.blue.shade700,
                            ),
                          ],
                        ],
                    
                        if (e.homeworkComment != null && e.homeworkComment?.textComment != null && e.homeworkComment!.textComment!.isNotEmpty) ...[
                          const Divider(height: 28),
                          const Text(
                            "Комментарий преподавателя",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.blue.shade100),
                            ),
                            child: SelectableText(
                              e.homeworkComment?.textComment ?? "-",
                              style:
                                  const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                    
                        if (e.comment.isNotEmpty) ...[
                          const Divider(height: 28),
                          const Text(
                            "Примечание к заданию",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.orange.shade100),
                            ),
                            child: SelectableText(
                              e.comment,
                              style:
                                  const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                        if(status == 3 || status == 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 33, 138, 203)
                              ),
                              onPressed: () => {
                                Navigator.pop(context),
                                showDialogCreateHomework(context),
                              }, 
                              child: Text(
                                "Загрузить задание",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}