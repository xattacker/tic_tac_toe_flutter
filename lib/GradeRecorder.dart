
class GradeRecorder
{
  int _winCount = 0;
  int _lostCount = 0;
  int _tiedCount = 0;

  int get winCount => _winCount;
  int get lostCount => _lostCount;
  int get tiedCount => _tiedCount;

  void addWin()
  {
      _winCount++;
  }

  void addLose()
  {
      _lostCount++;
  }

  void addTie()
  {
    _tiedCount++;
  }

  void reset()
  {
      _winCount = 0;
      _lostCount = 0;
      _tiedCount = 0;
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
        text += "Tie: ";
        text += "$_tiedCount";

        return text;
    }
}