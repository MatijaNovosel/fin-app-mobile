import 'package:finapp/helpers/helpers.dart';
import 'package:finapp/models/account.dart';
import 'package:flutter/material.dart';

class CurrentAmountCard extends StatefulWidget {
  final Account account;
  final Color color;
  final IconData icon;
  final bool showHideButton;
  final bool showInitialValue;
  final bool gradient;
  final Color gradientFrom;
  final Color gradientTo;
  final Color mainTextColor;
  final double height;
  final double width;
  final double margin;

  const CurrentAmountCard({
    Key key,
    this.account,
    this.color,
    this.icon,
    this.showHideButton,
    this.showInitialValue,
    this.gradient,
    this.gradientFrom,
    this.gradientTo,
    this.mainTextColor,
    this.height,
    this.width,
    this.margin,
  }) : super(key: key);

  @override
  _CurrentAmountCardState createState() => _CurrentAmountCardState();
}

class _CurrentAmountCardState extends State<CurrentAmountCard> {
  bool _visible = false;

  @override
  void initState() {
    setState(() {
      _visible = widget.showInitialValue != null ? widget.showInitialValue : false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? null,
      height: widget.height ?? 55,
      margin: EdgeInsets.symmetric(
        horizontal: widget.margin,
      ),
      decoration: BoxDecoration(
        gradient: widget.gradient != null
            ? widget.gradient == true
                ? LinearGradient(
                    colors: [
                      widget.gradientFrom,
                      widget.gradientTo,
                    ],
                  )
                : null
            : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: <Widget>[
          widget.icon != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 12.0,
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    widget.account.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  _visible
                      ? formatHrk(widget.account.amount)
                      : "${widget.account.amount.toStringAsFixed(2)} HRK".replaceAll(new RegExp(r'[0-9]'), '*'),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: widget.mainTextColor,
                  ),
                ),
              ],
            ),
          ),
          widget.showHideButton == false
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                  ),
                  child: IconButton(
                    icon: _visible ? Icon(Icons.stop_circle) : Icon(Icons.panorama_fish_eye),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
