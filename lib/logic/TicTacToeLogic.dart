
import 'package:flutter/cupertino.dart';
import 'package:tic_tac_toe_flutter/GridWidget.dart';
import 'package:collection/collection.dart';
import 'dart:math';

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
        //debugPrint("onGridStatusUpdated ${grid.x}, ${grid.y} , ${grid.type}");
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
         var bestStep = _miniMax(null, _playerSelectedType.theOther, _grids, 0);

         var found = _findGrid(bestStep.left, _grids);
         if (found != null)
         {
              debugPrint("chess score: ${bestStep.right}, (${bestStep.left.x}, ${bestStep.left.y})");
              chess(found);
         }
    }

    Pair<TicTacToeGrid, int> _miniMax(TicTacToeGrid? grid, GridChessType type, List<List<TicTacToeGrid>> grids, int level)
    {
        // AI Algorithm reference:
        // https://en.wikipedia.org/wiki/Minimax
        // https://www.freecodecamp.org/news/how-to-make-your-tic-tac-toe-game-unbeatable-by-using-the-minimax-algorithm-9d690bad4b37/
        var avails = _availGrids(grids);

         if (grid != null)
         {
             var score = 0;
             if (_checkWinV2(grid, grids))
             {
                 score = grid.type == _playerSelectedType ? -10 : 10;
             }

             if (score != 0)
             {
                  return Pair(grid, score);
             }
             else if (avails.isEmpty)
             {
                  return Pair(grid, 0);
             }
         }

          var clone_grids = _cloneGrids(grids);
          List<Pair<TicTacToeGrid, int>> move_steps = [];
          for (var grid in avails)
          {
              var found = _findGrid(grid, clone_grids);
              if (found != null)
              {
                  found.type = type;

                  var got = _miniMax(found, type.theOther, clone_grids, level+1);
                  move_steps.add(Pair<TicTacToeGrid, int>(found, got.right));

                  found.type = GridChessType.none;
              }
          }

         TicTacToeGrid bestStep = move_steps[0].left;
         int bestScore = move_steps[0].right;

         if (type == _playerSelectedType)
         {
              // find the lowest score
              bestScore = 9999;
              for (var step in move_steps)
              {
                  if (step.right < bestScore)
                  {
                      bestScore = step.right;
                      bestStep = step.left;
                  }
              }
        }
        else
         {
              // find the highest score
              bestScore = -9999;
              for (var step in move_steps)
              {
                  if (step.right > bestScore)
                  {
                      bestScore = step.right;
                      bestStep = step.left;
                  }
              }
         }

         return Pair(bestStep, bestScore);
    }

    List<List<TicTacToeGrid>> _cloneGrids(List<List<TicTacToeGrid>> grids)
    {
        List<List<TicTacToeGrid>> clone = [];
        for (var sub in grids)
        {
             List<TicTacToeGrid> sub_array = [];
             for (var grid in sub)
             {
                 sub_array.add(grid.clone());
             }

             clone.add(sub_array);
        }

        return clone;
    }

    List<TicTacToeGrid> _availGrids(List<List<TicTacToeGrid>> grids)
    {
        List<TicTacToeGrid> list = grids.expand((element) => element).toList();
        list.sort((TicTacToeGrid a, TicTacToeGrid b) => a.index < b.index ? -1 : 1);
        return list.where((element) => element.type == GridChessType.none).toList();
    }

    TicTacToeGrid? _findGrid(TicTacToeGrid grid, List<List<TicTacToeGrid>> grids)
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
