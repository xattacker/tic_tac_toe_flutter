
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
    GridChessStatus _playerGridStatus;
    TicTacToeLogicListener _listener;
    List<TicTacToeGrid> _grids;

    TicTacToeLogic(this._listener, this._playerGridStatus, this._grids)
    {
        for (var gird in _grids)
        {
            gird.listener = this;
        }
    }

    @override
    void onGridStatusUpdated(GridChessStatus status, TicTacToeGrid grid)
    {
        var x = grid.x;
        var y = grid.y;
        print("$x ,  $y");
        checkWin();
    }

    @override
    void chess(TicTacToeGrid grid)
    {
          if (grid.status == GridChessStatus.none)
          {
              grid.status = _playerGridStatus;
          }
    }

    void checkWin()
    {

    }
}