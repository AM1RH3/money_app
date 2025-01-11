import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class NewTransActionsScreen extends StatefulWidget {
  const NewTransActionsScreen({Key? key}) : super(key: key);
  static int groupId = 0;
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;
  static String date = 'تاریخ';
  @override
  State<NewTransActionsScreen> createState() => _NewTransActionsScreenState();
}

class _NewTransActionsScreenState extends State<NewTransActionsScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NewTransActionsScreen.isEditing
                    ? 'ویرایش تراکنش'
                    : 'تراکنش جدید',
                style: const TextStyle(fontSize: 20),
              ),
              MyTextFiled(
                hintText: 'توضیحات',
                controller: NewTransActionsScreen.descriptionController,
              ),
              MyTextFiled(
                hintText: 'مبلغ',
                type: TextInputType.number,
                controller: NewTransActionsScreen.priceController,
              ),
              const TypeAndDataWidget(),
              MyButton(
                text: NewTransActionsScreen.isEditing
                    ? 'ویرایش کردن'
                    : 'اضافه کردن',
                onPressed: () {
                  //
                  Money item = Money(
                      id: Random().nextInt(999999999),
                      title: NewTransActionsScreen.descriptionController.text,
                      price: NewTransActionsScreen.priceController.text,
                      date: NewTransActionsScreen.date,
                      isReceived:
                          NewTransActionsScreen.groupId == 1 ? true : false);
                  //
                  if (NewTransActionsScreen.isEditing) {
                    int index = 0;
                    MyApp.getData();
                    for (int i = 0; i < hiveBox.values.length; i++) {
                      if (hiveBox.values.elementAt(i).id ==
                          NewTransActionsScreen.id) {
                        index = i;
                      }
                    }
                    print(index);
                    hiveBox.putAt(index, item);
                  } else {
                    //HomeScreen.moneys.add(item);
                    hiveBox.add(item);
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//! my Button
class MyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const MyButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: kPurpleColor,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

//! Type And Data Widget
class TypeAndDataWidget extends StatefulWidget {
  const TypeAndDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TypeAndDataWidget> createState() => _TypeAndDataWidgetState();
}

class _TypeAndDataWidgetState extends State<TypeAndDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: MyRadioButton(
            value: 1,
            groupvalue: NewTransActionsScreen.groupId,
            onChanged: (value) {
              setState(() {
                NewTransActionsScreen.groupId = value!;
              });
            },
            text: 'پرداختی',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: MyRadioButton(
            value: 2,
            groupvalue: NewTransActionsScreen.groupId,
            onChanged: (value) {
              setState(() {
                NewTransActionsScreen.groupId = value!;
              });
            },
            text: 'دریافتی  ',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              var pickedDate = await showPersianDatePicker(
                context: context,
                initialDate: Jalali.now(),
                firstDate: Jalali(1400),
                lastDate: Jalali(1499),
              );
              setState(() {
                String year = pickedDate!.year.toString();
                //
                String month = pickedDate.month.toString().length == 1
                    ? '0${pickedDate.month.toString()}'
                    : pickedDate.month.toString();
                //
                String day = pickedDate.day.toString().length == 1
                    ? '0${pickedDate.day.toString()}'
                    : pickedDate.day.toString();
                //
                NewTransActionsScreen.date = year + '/' + month + '/' + day;
              });
            },
            child: Text(
              NewTransActionsScreen.date,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

//! My Radio Button
class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupvalue;
  final Function(int?) onChanged;
  final String text;

  const MyRadioButton(
      {Key? key,
      required this.value,
      required this.groupvalue,
      required this.onChanged,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Radio(
            activeColor: kPurpleColor,
            value: value,
            groupValue: NewTransActionsScreen.groupId,
            onChanged: onChanged,
          ),
        ),
        Text(text),
      ],
    );
  }
}

//! My TextFiled
class MyTextFiled extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  const MyTextFiled(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.type = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        hintText: hintText,
      ),
    );
  }
}
