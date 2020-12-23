import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ifa_exchange_rate/models/currency.dart';
import 'package:ifa_exchange_rate/models/exchange_rates.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ifa_exchange_rate/utils/shared_value.dart';
import 'package:flag/flag.dart';
import 'package:ifa_exchange_rate/widgets/swap_button.dart';
import 'package:ifa_exchange_rate/widgets/error_message.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Dio dio = Dio();
  bool isLoading = true;
  int current = 1;
  TextEditingController controller;

  Future<ExchangeRates> future;
  bool isBase = true;
  double resultConvert = 0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '1');
    getData();
  }

  getData() {
    setState(() {
      future = dio
          .get("https://api.exchangeratesapi.io/latest?base=${origin.value}")
          .then((value) => ExchangeRates.fromJson(value.data));
    });
  }

  Currency origin = Currency(
      text: "USD - United States Dollar",
      key: "us",
      value: "USD",
      flag: "us",
      symbol: "\$ ");

  Currency destination = Currency(
      text: "IDR - Indonesian Rupiah",
      key: "id",
      value: "IDR",
      flag: "id",
      symbol: "Rp ");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myColors.bg,
      body: VStack([
        24.heightBox,
        title,
        20.heightBox,
        VStack([
          FutureBuilder<ExchangeRates>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return datanya(snapshot.data);
              } else if (snapshot.hasError) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorMessage(
                    msg: snapshot.error.toString(),
                    onPressed: () {
                      getData();
                    },
                  ),
                ));
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
              }
            },
          ),
        ]).scrollVertical()
      ]).scrollVertical(),
    );
  }

  final title = VStack([
    'IFA'.text.color(myColors.textBlack).textStyle(titleStyle).make(),
    'Exchange Rates'
        .text
        .color(myColors.textBlack)
        .textStyle(titleStyleThin)
        .make()
  ]).p24();

  Widget datanya(ExchangeRates data) {
    convertAction();
    return VStack(
      [
        HStack(
          [
            24.widthBox,
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: Flag(
                  origin.flag,
                  height: 15,
                  width: 25,
                )),
            20.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      List<Currency> currencies = getDataCurrency();
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoPicker(
                              backgroundColor: Colors.white,
                              onSelectedItemChanged: (value) {
                                setState(() async {
                                  current = value;
                                  origin = currencies[value];
                                  isBase = true;
                                  await getData();
                                  convertAction();
                                });
                              },
                              itemExtent: 40.0,
                              children: List<Widget>.generate(currencies.length,
                                  (int index) {
                                return HStack(
                                  [
                                    Text(currencies[index].text),
                                    ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        child: Flag(
                                          currencies[index].flag,
                                          height: 25,
                                          width: 40,
                                        )),
                                  ],
                                  alignment: MainAxisAlignment.spaceAround,
                                );
                              }),
                            );
                          });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${origin.text.split("-")[0]}',
                              style: countryStyle,
                            ),
                            10.widthBox,
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: Color(0xff3b3f47),
                              size: 16,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${origin.text.split("-")[1].trim()}',
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.widthBox,
            SwapButton(
              onTap: () {
                Currency temp = origin;
                setState(() {
                  origin = destination;
                  destination = temp;
                  isBase = !isBase;
                });
                convertAction();
              },
            ),
            20.widthBox,
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: Flag(
                  destination.flag,
                  height: 15,
                  width: 25,
                )),
            20.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      List<Currency> currencies = getDataCurrency();
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoPicker(
                              backgroundColor: Colors.white,
                              onSelectedItemChanged: (value) {
                                setState(() async {
                                  current = value;
                                  destination = currencies[value];
                                  isBase = true;
                                  await getData();
                                  convertAction();
                                });
                              },
                              itemExtent: 40.0,
                              children: List<Widget>.generate(currencies.length,
                                  (int index) {
                                return HStack(
                                  [
                                    Text(currencies[index].text),
                                    ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        child: Flag(
                                          currencies[index].flag,
                                          height: 25,
                                          width: 40,
                                        )),
                                  ],
                                  alignment: MainAxisAlignment.spaceAround,
                                );
                              }),
                            );
                          });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${destination.text.split("-")[0]}',
                              style: TextStyle(
                                  color: Color(0xff3b3f47),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            10.widthBox,
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: Color(0xff3b3f47),
                              size: 16,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${destination.text.split("-")[1].trim()}',
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            24.widthBox,
          ],
          alignment: MainAxisAlignment.spaceAround,
        ),
        VxBox(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 4, right: 16, top: 12, bottom: 8),
              border: InputBorder.none,
            ),
            textAlign: TextAlign.start,
            style: titleStyle,
            keyboardType: TextInputType.number,
            controller: controller,
            onChanged: (value) {
              convertAction();
            },
          ),
        ).p16.white.make().p24(),
        '='.text.textStyle(titleStyle).makeCentered(),
        VxBox(
          child: NumberFormat.currency(
            symbol: destination.symbol,
          )
              .format(resultConvert)
              .text
              .textStyle(titleStyle.copyWith(fontSize: 32))
              .make(),
        ).makeCentered().shimmer(
              primaryColor: myColors.primary,
            ),
        '${destination.text.split("-")[1].trim()}'
            .text
            .textStyle(titleStyle.copyWith(fontSize: 10))
            .makeCentered(),
        40.heightBox,
        40.heightBox,
        Image.asset(
          'assets/images/logo.png',
          scale: 10.0,
        )
            .mdClick(() {
              _launchURL('https://kardusinfo.com');
            })
            .make()
            .objectBottomCenter(),
        16.heightBox,
        HStack([
          Icon(CupertinoIcons.calendar),
          10.widthBox,
          "Last Update ${DateFormat('dd MMMM yyyy').format(DateTime.parse(data.date))}"
              .text
              .textStyle(titleStyle.copyWith(fontSize: 8))
              .color(Vx.gray700)
              .make()
        ]).objectBottomCenter(),
      ],
    ).scrollVertical();
  }

  void convertAction() {
    future.then((v) {
      setState(() {
        try {
          if (controller.text.isNotEmpty) {
            if (int.parse(controller.text) > 0) {
              if (isBase) {
                resultConvert =
                    v.rates[destination.value] * int.parse(controller.text);
              } else {
                resultConvert =
                    int.parse(controller.text) / v.rates[origin.value];
              }
            } else {
              resultConvert = 0;
            }
          } else {
            resultConvert = 0;
          }
        } catch (e) {
          print("errors ${e.toString()}");
          resultConvert = 0;
        }
      });
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
