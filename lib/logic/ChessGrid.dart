
enum ChessType
{
  none,

  circle,
  fork
}

// interface
class ChessGrid
{
  late int x;
  late int y;
  ChessType type = ChessType.none;
}