import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/GridPainter.dart';
import 'package:tic_tac_toe_flutter/logic/TicTacToeGrid.dart';

import 'BoardPainter.dart';
import 'GridWidget.dart';
import 'logic/TicTacToeLogic.dart';
import 'logic/TicTacToeLogicListener.dart';

class TicTacToeWidget extends StatefulWidget
{
    TicTacToeState createState() => TicTacToeState();
}


class TicTacToeState extends State<TicTacToeWidget> implements TicTacToeLogicListener
{
  late TicTacToeLogic _logic;
  List<GridWidget> _grids = [];

  @override
  void initState()
  {
       super.initState();

       _logic = new TicTacToeLogic(this, GridStatus.circle);

       for (var i = 0; i < 3; i++)
       {
           for (var j = 0; j < 3; j++)
           {
              GridWidget grid = GridWidget(i, j);
               _grids.add(grid);
           }
       }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("TicTacToe"),
        ),
        body: SafeArea(
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
                          children: _grids
                      )]
                )
            )
        )
    );
  }

  @override
  void onWon(PlayerType winner)
  {

  }
}