import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  Page({
    this.assetPath,
    this.title,
    this.description,
    this.background,
  });

  final assetPath;
  final title;
  final description;
  final background;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(assetPath),
                  Container(
                    height: 25,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
