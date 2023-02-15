import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String lable;
  final Function fun;
  final bool showImg;
  final double sizechange;
  final bool filter;
  final bool widget;
  final Widget? child;
  final Size size;
  final String icons;
  final bool backTrue;

  const CustomAppbar({
    Key? key,
    required this.lable,
    required this.fun,
    this.showImg = false,
    required this.sizechange,
    this.filter = false,
    this.widget = false,
    this.child,
    required this.size,
    this.icons = "",
    this.backTrue = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15,
            bottom: 0,
            left: size.width * 0.03),
        child: Row(
          children: [
            backTrue
                ? InkWell(
                    onTap: () {
                      fun();
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left_outlined,
                      size: size.width * 0.09,
                    ),
                  )
                : Container(width: size.width * 0.03),
            Text(
              lable,
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
            SizedBox(width: size.width * 0.04),
          ],
        ));
  }
}
