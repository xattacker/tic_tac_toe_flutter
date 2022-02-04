
import 'TicTacToeLogic.dart';

abstract class TicTacToeLogicListener
{
    void onWon(PlayerType winner);
}