import 'package:ifa_exchange_rate/models/currency.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ifa_exchange_rate/utils/shared_value.dart';

class ItemCurrency extends StatelessWidget {
  final Currency currency;
  final bool isSelect;

  ItemCurrency(this.currency, this.isSelect);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              Container(
                height: 25,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    child: Flag(
                      currency.flag,
                      height: 25,
                      width: 40,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  '${currency.text.split("-")[0].trim()}',
                  style: TextStyle(
                      color: isSelect ? myColors.primary : Color(0xff3b3f47),
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  '${currency.text.split("-")[1].trim()}',
                  style: TextStyle(
                      color: isSelect ? myColors.primary : Colors.black38,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                ),
              ),
              isSelect
                  ? Icon(
                      CupertinoIcons.check_mark_circled,
                      color: myColors.primary,
                    )
                  : Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(32))),
                    )
            ],
          ),
        ),
        Divider(
          indent: 12,
          endIndent: 12,
        )
      ],
    );
  }
}
