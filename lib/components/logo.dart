import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
        color: const Color(0xffff5722),
        border: Border.all(width: 1.0, color: const Color(0xffebe0e0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 10),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Your Thing',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
