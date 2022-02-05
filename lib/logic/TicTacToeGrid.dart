
enum GridChessStatus
{
  none,

  circle,
  fork
}

extension GridStatusExtension on GridChessStatus
{
  GridChessStatus get theOtherStatus
  {
      switch (this)
      {
        case GridChessStatus.none:
          return this;

        case GridChessStatus.circle:
          return GridChessStatus.fork;

        case GridChessStatus.fork:
          return GridChessStatus.circle;
      }
  }
}

// interface
class TicTacToeGrid
{
  late int x;
  late int y;
  GridChessStatus status = GridChessStatus.none;

  late TicTacToeGridListener listener;
}


abstract class TicTacToeGridListener
{
    void onGridStatusUpdated(GridChessStatus status, TicTacToeGrid grid);
    void chess(TicTacToeGrid grid);
}