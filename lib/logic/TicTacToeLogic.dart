
import 'package:tic_tac_toe_flutter/GridWidget.dart';

import 'TicTacToeGrid.dart';
import 'TicTacToeLogicListener.dart';

enum PlayerType
{
  unknown,

  player,
  computer
}

class TicTacToeLogic implements TicTacToeGridListener
{
    GridStatus _playerGrid;
    TicTacToeLogicListener _listener;

    TicTacToeLogic(this._listener, this._playerGrid)
    {
    }

    @override
    void onGridStatusUpdated(GridStatus status, TicTacToeGrid grid)
    {
        var x = grid.x;
        var y = grid.y;
        print("$x ,  $y");
    }
}