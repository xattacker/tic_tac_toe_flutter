
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
         var bestStep = _runAIBestMoveAlgorithm2(null, _playerSelectedType.theOther, _grids);
         for (var sub in _grids)
         {
             for (var grid in sub)
             {
                if (grid.index == bestStep.left.index)
                {
                    chess(grid);
                    return;
                }
             }
         }
    }

    Pair<TicTacToeGrid, int> _runAIBestMoveAlgorithm2(TicTacToeGrid? grid, GridChessType type, List<List<TicTacToeGrid>> grids)
    {
        var avails = _availGrids(grids);

         if (grid != null)
         {
             var score = _calStepScore(grid, grids);
             if (score != 0 || avails.isEmpty)
             {
                 score +=  score > 0 ? avails.length : -avails.length;
                 return Pair(grid, score);
             }
         }


            List<Pair<TicTacToeGrid, int>> move_steps = [];
            for (var grid in avails)
            {
                var clone_grids = _cloneGrids(grids);
                var found = findGrid(grid, clone_grids);
                if (found != null)
                {
                    found.type = type;
                    move_steps.add(_runAIBestMoveAlgorithm2(found, type.theOther, clone_grids));
                }
            }


            // if (type == _playerSelectedType)
            // {
            //     // 找分數最低的
            //     bestScore = 9999;
            //     for (var step in move_steps)
            //     {
            //         if (step.right < bestScore)
            //         {
            //            bestScore = step.right;
            //            bestStep = step.left;
            //         }
            //     }
            // }
            // else
            // {
            //     // 找分數最高的
            //     bestScore = -9999;
            //     for (var step in move_steps)
            //     {
            //         if (step.right > bestScore)
            //         {
            //            bestScore = step.right;
            //            bestStep = step.left;
            //         }
            //     }
            // }

            // 找分數最高的
            move_steps.sort((Pair<TicTacToeGrid, int> a, Pair<TicTacToeGrid, int> b)=> a.right > b.right ? -1 : 1);
            TicTacToeGrid bestStep = move_steps[0].left;
            int bestScore = move_steps[0].right;

            List<TicTacToeGrid> best_score_list = [];
            for (var step in move_steps)
            {
                if (step.right == bestScore)
                {
                  best_score_list.add(step.left);
                }
            }

            if (best_score_list.length >= 2)
            {
                 Random random = new Random();

                 var center = best_score_list.firstWhereOrNull((element) => element.index == pow(GRID_DIMENSION - 1, 2));
                 if (center != null && random.nextBool())
                 {
                     bestStep = center;
                 }
                 else
                 {
                     // 超過1個以上最佳步時, 隨機取樣
                     bestStep = best_score_list[random.nextInt(best_score_list.length)];
                 }
            }

            return Pair(bestStep, bestScore);
    }

    int _calStepScore(TicTacToeGrid grid, List<List<TicTacToeGrid>> grids)
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