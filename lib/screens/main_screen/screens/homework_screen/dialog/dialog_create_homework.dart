import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

Future<dynamic> showDialogCreateHomework(BuildContext context) {

  final controllerComment = TextEditingController();


  return showDialog(
    context: context, 
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
                controller: controllerComment,
                decoration: InputDecoration(
                  alignLabelWithHint: true, 
                  label: Text("Комментарии"),
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
            ],
          ),
        ),
      ),
    );
}

