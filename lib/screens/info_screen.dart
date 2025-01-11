import 'package:flutter/material.dart';
import 'package:money_app/Widgets/chart_widget.dart';
import 'package:money_app/utils/calculate.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  right: 15.0,
                  top: 20.0,
                  left: 5.0,
                ),
                child: Text(
                  'مدریت تراکنش ها به تومان',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              MoneyInfoWidget(
                firstText: ' : دریافتی امروز',
                firstPrice: Calculate.dToday().toString(),
                secondText: ' : پرداختی امروز',
                secondPrice: Calculate.pToday().toString(),
              ),
              MoneyInfoWidget(
                firstText: ' : دریافتی این ماه',
                firstPrice: Calculate.dMonth().toString(),
                secondText: ' : پرداختی این ماه',
                secondPrice: Calculate.pMonth().toString(),
              ),
              MoneyInfoWidget(
                firstText: ' : دریافتی امسال',
                firstPrice: Calculate.dYear().toString(),
                secondText: ' : پرداختی امسال',
                secondPrice: Calculate.pYear().toString(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 200,
                  child: BarChartWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

//! Money Info Widget
class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;

  const MoneyInfoWidget(
      {Key? key,
      required this.firstText,
      required this.secondText,
      required this.firstPrice,
      required this.secondPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, top: 20.0, left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Text(
            secondPrice,
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.right,
          )),
          Text(secondText, style: const TextStyle(fontSize: 16.0)),
          Expanded(
              child: Text(
            firstPrice,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16.0),
          )),
          Text(firstText, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
