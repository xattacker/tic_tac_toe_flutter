
import 'package:tic_tac_toe_flutter/GridWidget.dart';
import 'package:collection/collection.dart';

import 'ConnectedDirection.dart';
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
    static const  WIN_COUNT = 3;

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
        _checkWin(grid);
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

    void restart()
    {
        for (var sub in _grids)
        {
            for (var grid in sub)
            {
                grid.status = GridChessStatus.none;
                print(grid.status);
            }
        }

        _count = 0;
    }

    void _checkWin(TicTacToeGrid grid)
    {
          if (grid.status == GridChessStatus.none)
          {
              return;
          }


         var direction = ConnectedDirection.lt_rb;
         var result = false;

         do
         {
             result = _checkDirectionWin(grid, direction);
             direction = direction.next();
         } while (!result && direction != ConnectedDirection.none);

         if (result)
         {
             _listener.onWon(grid.status == _playerGridStatus ? PlayerType.player : PlayerType.computer);
         }
         else
         {
               List<TicTacToeGrid> grids = _grids.expand((element) => element).toList();
               TicTacToeGrid? none_grid = grids.firstWhereOrNull(
                                                            (element) => element.status == GridChessStatus.none);
               if (none_grid == null)
               {
                  // 已全部下完, 平手
                  _listener.onWon(PlayerType.unknown);
               }
         }
    }

    bool _checkDirectionWin(TicTacToeGrid grid, ConnectedDirection direction)
    {
            var offset = direction.offset;
            var x = grid.x + offset[0];
            var y = grid.y + offset[1];
            var connected_count = 1;

            while (x >= 0 && x < WIN_COUNT && y >= 0 && y < WIN_COUNT && _grids[x][y].status == grid.status)
            {
                connected_count++;
                x += offset[0];
                y += offset[1];
            }

            if (connected_count >= WIN_COUNT)
            {
                return true;
            }

            x = grid.x - offset[0];
            y = grid.y - offset[1];
            while (x >= 0 && x < WIN_COUNT && y >= 0 && y < WIN_COUNT && _grids[x][y].status == grid.status)
            {
                connected_count++;
                x -= offset[0];
                y -= offset[1];
            }

            if (connected_count >= WIN_COUNT)
            {
                return true;
            }

            return false;
    }
}