import 'package:flutter/material.dart';

Widget avatar(
    {String urlImage = ' defaul',
      double size = 50,
      EdgeInsetsGeometry margin = EdgeInsets.zero,
      double elevation = 5}) {
  return Container(
    margin: margin,
    height: size,
    width: size,
    child: Material(
      borderRadius: BorderRadius.circular(50),
      elevation: elevation,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CircleAvatar(
          radius: 50.0,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(urlImage),
        ),
      ),
    ),
  );
}