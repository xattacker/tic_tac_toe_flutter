
enum GridChessType
{
  none,

  circle,
  fork
}

extension GridStatusExtension on GridChessType
{
  GridChessType get theOther
  {
      switch (this)
      {
        case GridChessType.none:
          return this;

        case GridChessType.circle:
          return GridChessType.fork;

        case GridChessType.fork:
          return GridChessType.circle;
      }
  }
}

// interface
class TicTacToeGrid
{
  late int x;
  late int y;
  GridChessType type = GridChessType.none;

  late TicTacToeGridListener listener;
}


abstract class TicTacToeGridListener
{
    void onGridStatusUpdated(GridChessType type, TicTacToeGrid grid);
    void chess(TicTacToeGrid grid);
}