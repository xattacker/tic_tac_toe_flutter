
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

extension TicTacToeGridExtension on TicTacToeGrid
{
    int get index => (this.x * this.listener.dimension) + this.y;

    TicTacToeGrid clone()
    {
        TicTacToeGrid grid = TicTacToeGrid();
        grid.x = this.x;
        grid.y = this.y;
        grid.type = this.type;

        return grid;
    }
}

abstract class TicTacToeGridListener
{
    int get dimension;
    void onGridStatusUpdated(GridChessType type, TicTacToeGrid grid);
    void chess(TicTacToeGrid grid);
}