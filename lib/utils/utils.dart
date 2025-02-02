import 'package:flutter/cupertino.dart';


  Widget appBarGredient(List<Color> listofColors){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: listofColors
          )
      ),
    );
  }

/*

 */