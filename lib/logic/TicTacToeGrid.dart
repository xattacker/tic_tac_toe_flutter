
enum GridStatus
{
  none,

  circle,
  fork
}

// interface
class TicTacToeGrid
{
  late int x;
  late int y;
  GridStatus status = GridStatus.none;
}