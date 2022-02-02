import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BoardPainter.dart';

class TicTacToeWidget extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("TicTacToe"),
      ),
      body:   SafeArea(
                 child: Center(
                           child:
                           Stack(
                               alignment: Alignment.center,
                               children:  [
                                             CustomPaint( //<--- 使用绘制组件
                                               size: const Size(double.infinity, double.infinity),
                                               painter: BoardPainter()
                                             ),
                                            GridView(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3, //横轴三个子widget
                                                childAspectRatio: 1.0 //宽高比为1时，子widget
                                            ),
                                            physics: NeverScrollableScrollPhysics(), // disable scrollable
                                            children:<Widget>[
                                              Icon(Icons.ac_unit),
                                              Icon(Icons.airport_shuttle),
                                              Icon(Icons.all_inclusive),
                                              Icon(Icons.beach_access),
                                              Icon(Icons.cake),
                                              Icon(Icons.free_breakfast),
                                              Icon(Icons.beach_access),
                                              Icon(Icons.cake),
                                              Icon(Icons.free_breakfast)
                                            ]
                                          )]
                              )
                      )
          )
    );
  }
}