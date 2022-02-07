
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
    static const  GRID_DIMENSION = 3;

    GridChessType get selectedChessType => _playerSelectedType;

    GridChessType _playerSelectedType;
    TicTacToeLogicListener _listener;
    List<List<TicTacToeGrid>> _grids;
    int _count = 0;

    TicTacToeLogic(this._listener, this._playerSelectedType, this._grids)
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
    int get dimension => GRID_DIMENSION;

    @override
    void onGridStatusUpdated(GridChessType status, TicTacToeGrid grid)
    {
        _checkWin(grid);
    }

    @override
    void chess(TicTacToeGrid grid)
    {
          if (grid.type == GridChessType.none)
          {
              _count++;
              grid.type = _count % 2 == 1 ?  _playerSelectedType : _playerSelectedType.theOther;
          }
    }

    void restart()
    {
        for (var sub in _grids)
        {
            for (var grid in sub)
            {
                grid.type = GridChessType.none;
                print(grid.type);
            }
        }

        _count = 0;
    }

    void _checkWin(TicTacToeGrid grid)
    {
          if (grid.type == GridChessType.none)
          {
              return;
          }


         var direction = ConnectedDirection.lt_rb;
         var result = false;

         do
         {
             result = _checkDirectionWin(grid, direction, _grids);
             direction = direction.next();
         } while (!result && direction != ConnectedDirection.none);

         if (result)
         {
             _listener.onWon(grid.type == _playerSelectedType ? PlayerType.player : PlayerType.computer);
         }
         else if (_availGrids(_grids).isEmpty)
          {
             // 已全部下完, 平手
             _listener.onWon(PlayerType.unknown);
         }
         else if (grid.type == _playerSelectedType)
         {
             // 使用者下完, 換 AI 下
             _runAIBestMoveAlgorithm();
         }
    }

    bool _checkDirectionWin(TicTacToeGrid grid, ConnectedDirection direction, List<List<TicTacToeGrid>> grids)
    {
            var offset = direction.offset;
            var x = grid.x + offset[0];
            var y = grid.y + offset[1];
            var connected_count = 1;

            while (x >= 0 && x < GRID_DIMENSION && y >= 0 && y < GRID_DIMENSION && grids[x][y].type == grid.type)
            {
                connected_count++;
                x += offset[0];
                y += offset[1];
            }

            if (connected_count >= GRID_DIMENSION)
            {
                return true;
            }

            x = grid.x - offset[0];
            y = grid.y - offset[1];
            while (x >= 0 && x < GRID_DIMENSION && y >= 0 && y < GRID_DIMENSION && grids[x][y].type == grid.type)
            {
                connected_count++;
                x -= offset[0];
                y -= offset[1];
            }

            if (connected_count >= GRID_DIMENSION)
            {
                return true;
            }

            return false;
    }

    bool _checkWinV2(TicTacToeGrid grid, List<List<TicTacToeGrid>> grids)
    {
          var direction = ConnectedDirection.lt_rb;
          var result = false;

          do
          {
              result = _checkDirectionWin(grid, direction, grids);
              direction = direction.next();
          } while (!result && direction != ConnectedDirection.none);

          return result;
    }

    void _runAIBestMoveAlgorithm()
    {
         var bestStep = _runAIBestMoveAlgorithm2(null, _grids);
         for (var sub in _grids)
         {
             for (var grid in sub)
             {
                print(grid.index);
                print(bestStep.left.index);
                if (grid.index == bestStep.left.index)
                {
                    print("chess");
                    chess(grid);
                    break;
                }
             }
         }
    }

    Pair<TicTacToeGrid, int> _runAIBestMoveAlgorithm2(TicTacToeGrid? grid, List<List<TicTacToeGrid>> grids)
    {
          var avails = _availGrids(grids);
          if (avails.isEmpty && grid != null)
          {
              var score = _calMoveScore(grid, grids);
              return Pair(grid, score);
          }
          else
          {
              List<Pair<TicTacToeGrid, int>> move_steps = [];
              var count = 0;

              for (var grid in avails)
              {
                  var clone_grids = _cloneGrids(grids);
                  var found = findGrid(grid, clone_grids);
                  if (found != null)
                  {
                      found.type = count % 2 == 0 ? _playerSelectedType.theOther : _playerSelectedType;
                      move_steps.add(_runAIBestMoveAlgorithm2(found, clone_grids));
                  }
                  
                  count++;
              }

              var bestScore = -9999;
              TicTacToeGrid bestStep = avails[0];
              for (var step in move_steps)
              {
                  if (step.right > bestScore)
                  {
                    bestScore = step.right;
                    bestStep = step.left;
                  }
              }

              return Pair(bestStep, bestScore);
          }
    }

    int _calMoveScore(TicTacToeGrid grid, List<List<TicTacToeGrid>> grids)
    {
        var result = _checkWinV2(grid, grids);
        if (result)
        {
            return grid.type == _playerSelectedType ? -10 : 10;
        }

        return 0;
    }

    List<List<TicTacToeGrid>> _cloneGrids(List<List<TicTacToeGrid>> grids)
    {
        List<List<TicTacToeGrid>> clone = [];
        for (var sub in grids)
        {
             List<TicTacToeGrid> sub_array = [];
             for (var grid in sub)
             {
                 var temp = grid.clone();
                 temp.listener = this;
                 sub_array.add(temp);
             }

             clone.add(sub_array);
        }

        return clone;
    }

    List<TicTacToeGrid> _availGrids(List<List<TicTacToeGrid>> grids)
    {
        List<TicTacToeGrid> list = grids.expand((element) => element).toList();
        return list.where((element) => element.type == GridChessType.none).toList();
    }

    TicTacToeGrid? findGrid(TicTacToeGrid grid, List<List<TicTacToeGrid>> grids)
    {
        for (var sub in grids)
        {
            for (var temp in sub)
            {
                  if (temp.index == grid.index)
                  {
                    return temp;
                  }
            }
        }

        return null;
    }
}


class Pair<T, R>
{
  Pair(this.left, this.right);

  final T left;
  final R right;
}