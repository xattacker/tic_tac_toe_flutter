
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
    GridStatus _playerGridStatus;
    TicTacToeLogicListener _listener;

    TicTacToeLogic(this._listener, this._playerGridStatus)
    {
    }

    @override
    void onGridStatusUpdated(GridStatus status, TicTacToeGrid grid)
    {
        var x = grid.x;
        var y = grid.y;
        print("$x ,  $y");
    }

    @override
    void chess(TicTacToeGrid grid)
    {
          if (grid.status == GridStatus.none)
          {
              grid.status = _playerGridStatus;
          }
    }
}