
class GradeRecorder
{
  int _winCount = 0;
  int _lostCount = 0;
  int _drawCount = 0;

  int get winCount => _winCount;
  int get lostCount => _lostCount;
  int get drawCount => _drawCount;

  void addWin()
  {
      _winCount++;
  }

  void addLose()
  {
      _lostCount++;
  }

  void addDraw()
  {
      _drawCount++;
  }

  void reset()
  {
      _winCount = 0;
      _lostCount = 0;
      _drawCount = 0;
  }
}


extension GradeRecorderExtension on GradeRecorder
{
    String getString()
    {
        var text = "";

        text += "Win: ";
        text += "$_winCount";

        text += ",  ";
        text += "Lose: ";
        text += "$_lostCount";

        text += ",  ";
        text += "Draw: ";
        text += "$_drawCount";

        return text;
    }
}