import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingCustom extends StatelessWidget {
  const LoadingCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen,
      child: Center(
        child: Lottie.asset('images/send.json'),
      ),
    );
  }
}