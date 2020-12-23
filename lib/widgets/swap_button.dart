import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ifa_exchange_rate/utils/shared_value.dart';
import 'package:flutter/cupertino.dart';

class SwapButton extends StatelessWidget {
  final VoidCallback onTap;
  SwapButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(64)),
              border: Border.all(
                  color: myColors.primary.withOpacity(.6), width: 4)),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: myColors.textBlack.withOpacity(.3),
              child: Icon(
                CupertinoIcons.arrow_right_arrow_left,
                size: 14,
              ))),
    );
  }
}
