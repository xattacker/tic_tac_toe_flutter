import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/GridPainter.dart';
import 'package:tic_tac_toe_flutter/logic/TicTacToeGrid.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'AppLocalizations.dart';
import 'BoardPainter.dart';
import 'GradeRecorder.dart';
import 'GridWidget.dart';
import 'logic/TicTacToeLogic.dart';
import 'logic/TicTacToeLogicListener.dart';


class TicTacToeWidget extends StatefulWidget
{
    TicTacToeState createState() => TicTacToeState();
}


class TicTacToeState extends State<TicTacToeWidget> implements TicTacToeLogicListener
{
  TicTacToeLogic? _logic;
  List<List<GridWidget>> _grids = [];
  GradeRecorder _gradeRecorder = GradeRecorder();

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
        barrierDismissible: false, // disable dismissed when clicking  dialog outside
        builder: (context) {
          return SimpleDialog(
            title: Text(getString('chess_type_selection') , textAlign: TextAlign.center,),
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            //在 children 中可以加入選項
            children: <Widget>[
              SimpleDialogOption(
                  child: CustomPaint(
                      size: Size(selection_width, selection_width),
                      painter: ChessPainter(GridChessType.circle)
                  ),
                  onPressed: (){
                    Navigator.pop(context, true);
                    _initLogic(GridChessType.circle);
                  }),
              SimpleDialogOption(
                  child: CustomPaint(
                      size: Size(selection_width, selection_width),
                      painter: ChessPainter(GridChessType.fork)
                  ),
                  onPressed: (){
                    Navigator.pop(context, true);
                    _initLogic(GridChessType.fork);
                  })
            ]
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text(getString('app_name')),
        ),
        body: SafeArea(
            child:
              Stack(
                alignment: Alignment.center,
                children:  [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text(_gradeRecorder.toString())),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width * 1.2),
                          child:
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("You: "),
                                CustomPaint(
                                    size: Size(MediaQuery.of(context).size.width * 0.08, MediaQuery.of(context).size.width * 0.08),
                                    painter: ChessPainter(_logic?.selectedChessType ?? GridChessType.none)
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text("Opponent: ")),
                                CustomPaint(
                                    size: Size(MediaQuery.of(context).size.width * 0.08, MediaQuery.of(context).size.width * 0.08),
                                    painter: ChessPainter(_logic?.selectedChessType.theOther ?? GridChessType.none)
                                )
                              ]
                          ))]
                  ),
                  Center(
                      child: Stack(
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
                    ),
            Stack(
                alignment: Alignment.bottomRight,
                children: [
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState)
                      {
                        case ConnectionState.done:
                          return Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                          child: Text( 'Version: ${snapshot.data?.version}'))
                                    );
                        default:
                          return const SizedBox();
                      }
                    },
                  )
                  ]
            )
          ])
        )
    );
  }

  @override
  void onWon(PlayerType winner)
  {
      setState(() {
        switch (winner)
        {
          case PlayerType.player:
            _gradeRecorder.addWin();
            break;

          case PlayerType.computer:
            _gradeRecorder.addLose();
            break;

          case PlayerType.unknown:
            _gradeRecorder.addTie();
            break;
        }
      });
    
      showDialog(
          context: context,
          barrierDismissible: false, // disable dismissed when clicking  dialog outside
          builder: (context) {
            return new AlertDialog(
                                title: Text(getString("game_over")),
                                content: Text(winner == PlayerType.player ? getString("you_win") :  winner == PlayerType.computer ? getString("you_lose") : getString("tie")),
                                actions: [
                                      Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      TextButton(
                                        child: Text(getString("ok"), textAlign: TextAlign.center,),
                                        onPressed: () {
                                          Navigator.of(context).pop(); //关闭对话框
                                          _logic?.restart();
                                        }
                                      )
                                    ])
                                    ]
                );
          });
   }

  void _initLogic(GridChessType selectedType)
  {
      setState(() {
        _logic = new TicTacToeLogic(this, selectedType, this._grids);
      });
  }
}
