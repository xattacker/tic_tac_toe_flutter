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
  List<List<GridWidget>> _grids = [];

  @override
  void initState()
  {
       super.initState();


       Future.delayed(Duration(milliseconds: 500), () {
         selectChessType();
       });


       for (var i = 0; i < 3; i++)
       {
           List<GridWidget> sub_array = [];
           for (var j = 0; j < 3; j++)
           {
                GridWidget grid = GridWidget(i, j);
                sub_array.add(grid);
           }

           _grids.add(sub_array);
       }
  }

  void selectChessType()
  {
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
  }

  void initLogic(GridChessStatus selectedStatus)
  {
       _logic = new TicTacToeLogic(this, selectedStatus, this._grids);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("TicTacToe"),
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
                          children: _grids.expand((element) => element).toList()
                      )]
                )
            )
        )
    );
  }

  @override
  void onWon(PlayerType winner)
  {
      showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: Text("Game Over"),
              content: Text(winner == PlayerType.player ? "You win" :  winner == PlayerType.computer ? "You lose" : "Draw"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); //关闭对话框
                    _logic.restart();
                  },
                )
              ],
            );
          });
  }
}