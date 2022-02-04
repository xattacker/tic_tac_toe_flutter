
enum GridStatus
{
  none,

  circle,
  fork
}

extension GridStatusExtension on GridStatus
{
  GridStatus get theOtherStatus
  {
      switch (this)
      {
        case GridStatus.none:
          return this;

        case GridStatus.circle:
          return GridStatus.fork;

        case GridStatus.fork:
          return GridStatus.circle;
      }
  }
}

// interface
class TicTacToeGrid
{
  late int x;
  late int y;
  GridStatus status = GridStatus.none;

  late TicTacToeGridListener listener;
}


abstract class TicTacToeGridListener
{
    void onGridStatusUpdated(GridStatus status, TicTacToeGrid grid);
}