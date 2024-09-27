int calculateScore(int correctAnswers, int totalQuestions, int completionTimeInSeconds) {
  if (totalQuestions == 0) {
    return 0;
  }

  // Tính tỷ lệ câu trả lời đúng
  double accuracy = correctAnswers / totalQuestions;

  // Tính điểm cơ bản dựa trên tỷ lệ câu trả lời đúng (chiếm 70% tổng điểm)
  int baseScore = (accuracy * 700).round();

  // Tính điểm thời gian hoàn thành (chiếm 30% tổng điểm)
  // Giả sử thời gian hoàn thành lý tưởng là 60 giây, điểm sẽ giảm dần theo thời gian
  int maxCompletionTime = 60;
  double timeFactor = 1 - (completionTimeInSeconds / (maxCompletionTime * 2));
  timeFactor = timeFactor < 0 ? 0 : timeFactor; // Không cho điểm âm vì thời gian quá lâu
  int timeScore = (timeFactor * 300).round();

  // Tính tổng điểm
  int totalScore = baseScore + timeScore;

  // Đảm bảo tổng điểm không vượt quá 1000
  return totalScore.clamp(0, 1000);
}
