import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/GridPainter.dart';

import 'BoardPainter.dart';
import 'GridWidget.dart';

class TicTacToeWidget extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
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
                                               size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                                               painter: BoardPainter()
                                             ),
                                            GridView(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3, //横轴三个子widget
                                                childAspectRatio: 1.0 //宽高比为1时，子widget
                                            ),
                                            physics: NeverScrollableScrollPhysics(), // disable scrollable
                                            shrinkWrap: true,
                                            children:<Widget>[
                                              GridWidget(),
                                              GridWidget(),
                                              GridWidget(),
                                              
                                              GridWidget(),
                                              GridWidget(),
                                              GridWidget(),

                                              GridWidget(),
                                              GridWidget(),
                                              GridWidget()
                                            ]
                                          )]
                              )
                      )
          )
    );
  }
}