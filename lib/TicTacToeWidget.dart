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


       Future.delayed(Duration(milliseconds: 500), () {

         var selection_width = MediaQuery.of(context).size.width * 0.25;
         showDialog(
           context: context,
           builder: (context) {
             return SimpleDialog(
               title: Text("Chess Type Selection"),
               contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
               //在 children 中可以加入選項
               children: <Widget>[
                 SimpleDialogOption(
                   child: CustomPaint(
                       size: Size(selection_width, selection_width),
                       painter: ChessPainter(GridChessStatus.circle)
                   ),
                   onPressed: (){
                       Navigator.pop(context, true);
                       initLogic(GridChessStatus.circle);
                   }),
                 SimpleDialogOption(
                   child: CustomPaint(
                       size: Size(selection_width, selection_width),
                       painter: ChessPainter(GridChessStatus.fork)
                   ),
                   onPressed: (){
                        Navigator.pop(context, true);
                        initLogic(GridChessStatus.fork);
                   })
               ],
             );
           },
         );
       });


       for (var i = 0; i < 3; i++)
       {
           for (var j = 0; j < 3; j++)
           {
              GridWidget grid = GridWidget(i, j);
               _grids.add(grid);
           }
       }
  }

  void initLogic(GridChessStatus selectedStatus)
  {
       _logic = new TicTacToeLogic(this, selectedStatus, this._grids);
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