
import 'package:tic_tac_toe_flutter/GridWidget.dart';

import 'TicTacToeGrid.dart';
import 'TicTacToeLogicListener.dart';

enum PlayerType
{
  unknown,

  player,
  computer
}

class TicTacToeLogic
{
    GridStatus _playerGrid;
    TicTacToeLogicListener _listener;

    TicTacToeLogic(this._listener, this._playerGrid)
    {
    }
}