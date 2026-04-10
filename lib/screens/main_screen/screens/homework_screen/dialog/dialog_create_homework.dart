import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

Widget _buildItem(String text, {void Function(String)? onSelect}) {
  return GestureDetector(
    onTap: onSelect != null ? () => onSelect(text) : () {},
    child: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(75, 158, 158, 158),
        ),borderRadius: BorderRadius.circular(6)
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
    ),
  );
}

Future<dynamic> showDialogCreateHomework(BuildContext context) {
  final controllerAnswer = TextEditingController();
  final controllerComment = TextEditingController();
  int mark = 0;

  return showDialog(
    context: context, 
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 17,
              children: [
                Text(
                  "Загрузка домашнего задания",
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(171, 202, 202, 202)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      spacing: 8,
                      mainAxisSize: .min,
                      children: [
                        FIcon(
                          IO5.IoCloudUpload,
                          color: Colors.black,
                          size: 25,
                        ),
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Рекомендуется загружать файлы в архиве. Файлы в формате .тхт и .csv не допускаются",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Вы можете перетащить файл сюда или",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              overlayColor: Colors.grey
                            ),
                            onPressed: () {}, 
                            child: Text(
                              "Кликните здесь",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextField(
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 3,
                  controller: controllerAnswer,
                  decoration: InputDecoration(
                    alignLabelWithHint: true, 
                    label: Text("Текстовый ответ"),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 148, 146, 146)
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 221, 221, 221)
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Потрачено времени на выполнение ДЗ:",
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ),
                    IntrinsicWidth(
                      child: TextField(
                        inputFormatters: [MaskTextInputFormatter(
                          mask: '##:##',
                          filter: { "#": RegExp(r'[0-9]') },
                          type: MaskAutoCompletionType.lazy,
                        )],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Время',
                          labelStyle: TextStyle(
                            fontSize: 13
                          ),
                          hintText: 'чч:мм', 
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 148, 146, 146)
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 221, 221, 221)
                            ),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
                FivePointedStar(
                  count: 5,
                  size: Size(32, 32),
                  color: Colors.grey[300]!,
                  selectedColor: Colors.amber,
                  defaultSelectedCount: 3,
                  onChange: (selectedCount) {
                    mark = selectedCount;
                  },
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildItem("Все круто!"),
                    _buildItem("Все понятно!"),
                    _buildItem("Мне нравиться"),
                    _buildItem("Задание слишком простое"),
                    _buildItem("Скучно!("),
                    _buildItem("Не понятно, но нужно было сделать"),
                    _buildItem("Задание слишком сложное"),
                  ],
                ),
                TextField(
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  controller: controllerComment,
                  decoration: InputDecoration(
                    alignLabelWithHint: true, 
                    label: Text("Комментарий"),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 148, 146, 146)
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 221, 221, 221)
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 194, 194, 194),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(6)
                        )
                      ),
                      onPressed: () => Navigator.pop(context), 
                      child: Text(
                        "Отклонить",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.white,
                        backgroundColor: Color(0xFF188194),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(6)
                        )
                      ),
                      onPressed: () => {
                        print(mark),
                        Navigator.pop(context)
                      }, 
                      child: Text(
                        "Отправить",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
}

