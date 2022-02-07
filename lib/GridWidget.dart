import 'package:flutter/cupertino.dart';

import 'GridPainter.dart';
import 'logic/TicTacToeGrid.dart';

class GridWidget extends StatefulWidget implements TicTacToeGrid
{
  GridChessType _status = GridChessType.none;
  late _GridState _state;

  @override
  int x;

  @override
  int y;

  @override
  GridChessType get type => _status;

  @override
  set type(GridChessType status) {
    _state.setState(() {
        _status = status;
        this.listener.onGridStatusUpdated(_status, this);
    });
  }

  GridWidget(this.x, this.y);

  _GridState createState()
  {
      _state = _GridState();
      return _state;
  }

  @override
  late TicTacToeGridListener listener;

  void chess()
  {
      this.listener.chess(this);
  }
}

class _GridState extends State<GridWidget>
{
  @override
    Widget build(BuildContext context) {
          return GestureDetector(
              onTap: () {
                    setState(() {
                        this.widget.chess();
                    });
              },
              child:  CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                  painter: ChessPainter(this.widget.type)
              )
          );
    }
}