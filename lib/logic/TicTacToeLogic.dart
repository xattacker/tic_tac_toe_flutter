
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
    List<List<TicTacToeGrid>> _grids;

    int _count = 0;

    TicTacToeLogic(this._listener, this._playerGridStatus, this._grids)
    {
        for (var sub in _grids)
        {
            for (var grid in sub)
            {
                grid.listener = this;
            }
        }
    }

    @override
    void onGridStatusUpdated(GridChessStatus status, TicTacToeGrid grid)
    {
        var x = grid.x;
        var y = grid.y;
        print("$x ,  $y");
        checkWin(grid);
    }

    @override
    void chess(TicTacToeGrid grid)
    {
          if (grid.status == GridChessStatus.none)
          {
              _count++;
              grid.status = _count % 2 == 1 ?  _playerGridStatus : _playerGridStatus.theOtherStatus;
          }
    }

    void checkWin(TicTacToeGrid grid)
    {

    }
}