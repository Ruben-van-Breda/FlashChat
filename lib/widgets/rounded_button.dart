import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final String heroTag;
  final Color color;
  RoundedButton(
      {@required this.label, this.color, this.onPressed, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Hero(
        tag: heroTag != null ? heroTag : 'null',
        child: Material(
          elevation: 5.0,
          color: color != null ? color : Colors.redAccent,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              label,
            ),
          ),
        ),
      ),
    );
  }
}
