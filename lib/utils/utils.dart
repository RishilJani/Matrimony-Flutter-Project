import 'package:flutter/cupertino.dart';
import 'package:matrimony_application/utils/string_constants.dart';


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

  TextStyle myTextStyle(){
    return const TextStyle(
        fontFamily: RobotoFlex,
        fontSize: 33,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(0, 0, 0,0.7),
    );
  }
/*

 */