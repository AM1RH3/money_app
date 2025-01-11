// ignore_for_file: must_be_immutable

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/main_screen.dart';
import 'package:money_app/screens/new_treansactions_screen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static List<Money> moneys = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabWidget(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              headerWidget(),
              //const Expanded(child: EmptyWidget()),
              Expanded(
                child: HomeScreen.moneys.isEmpty
                    ? const EmptyWidget()
                    : ListView.builder(
                        itemCount: HomeScreen.moneys.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            //* Edit
                            onTap: () {
                              //
                              NewTransActionsScreen.date =
                                  HomeScreen.moneys[index].date;
                              //
                              NewTransActionsScreen.descriptionController.text =
                                  HomeScreen.moneys[index].title;
                              //
                              NewTransActionsScreen.priceController.text =
                                  HomeScreen.moneys[index].title;
                              //
                              NewTransActionsScreen.groupId =
                                  HomeScreen.moneys[index].isReceived ? 1 : 2;
                              //
                              NewTransActionsScreen.isEditing = true;
                              //
                              NewTransActionsScreen.id =
                                  HomeScreen.moneys[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NewTransActionsScreen(),
                                ),
                              ).then((value) {
                                MyApp.getData();
                                setState(() {});
                              });
                            },

                            //! Delete
                            onLongPress: () {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                            'آیااز حذف این آیتم مطمئن هستید ؟',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'خیر',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  hiveBox.deleteAt(index);
                                                  MyApp.getData();
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'بله',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                          ],
                                        ));
                              });
                            },
                            child: MyListTileWidget(
                              index: index,
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //! FAB Widget
  Widget fabWidget() {
    return FloatingActionButton(
      backgroundColor: kPurpleColor,
      elevation: 0,
      onPressed: () {
        NewTransActionsScreen.date = 'تاریخ';
        NewTransActionsScreen.descriptionController.text = '';
        NewTransActionsScreen.priceController.text = '';
        NewTransActionsScreen.groupId = 0;
        NewTransActionsScreen.isEditing = false;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const NewTransActionsScreen()),
        ).then((value) {
          MyApp.getData();
          setState(() {});
        });
      },
      child: const Icon(Icons.add),
    );
  }

  //! Header Widget
  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              hintText: '...جستجو کنید',
              buttonElevation: 0,
              buttonShadowColour: Colors.black26,
              isOriginalAnimation: false,
              buttonBorderColour: Colors.black26,
              buttonIcon: Icons.search,
              onCollapseComplete: () {
                MyApp.getData();
                searchController.text = '';
                setState(() {});
              },
              onFieldSubmitted: (String text) {
                List<Money> result = hiveBox.values
                    .where((value) =>
                        value.title.contains(text) || value.date.contains(text))
                    .toList();
                HomeScreen.moneys.clear();
                setState(() {
                  for (var value in result) {
                    HomeScreen.moneys.add(value);
                  }
                });
              },
              textEditingController: searchController, trailingWidget: null, secondaryButtonWidget: null, buttonWidget: null,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'تراکنش ها',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}

class MyListTileWidget extends StatelessWidget {
  final int index;
  const MyListTileWidget({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  HomeScreen.moneys[index].isReceived ? kGreenColor : kRedColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Icon(
                HomeScreen.moneys[index].isReceived ? Icons.add : Icons.remove,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(HomeScreen.moneys[index].title),
          ),
          const Spacer(),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    'تومان',
                    style: TextStyle(fontSize: 14.0, color: kRedColor),
                  ),
                  Text(
                    HomeScreen.moneys[index].price,
                    style: const TextStyle(fontSize: 14.0, color: kRedColor),
                  ),
                ],
              ),
              Text(HomeScreen.moneys[index].date),
            ],
          ),
        ],
      ),
    );
  }
}

//! Empty Widget
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          'assets/images/empty.svg',
          height: 250,
          width: 250,
        ),
        const Text('! تراکنشی موجود نیست '),
        const Spacer(),
      ],
    );
  }
}
