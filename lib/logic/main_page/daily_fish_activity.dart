class DailyFishActivityLogic {
  int getFishingScore(double moonPhase, int weatherCode) {
    // Ensure moonPhase is within the valid range (0 to 100)
    moonPhase = moonPhase.clamp(0, 100);

    int score = 0;

    // Interpolation logic for different moon phases
    if (moonPhase <= 25) {
      // From 0 to 25 (New Moon to Quarter)
      score = ((moonPhase / 25) * (10 - 100) + 100).toInt(); // Interpolates between 100 and 10
    } else if (moonPhase <= 50) {
      // From 25 to 50 (Quarter to Half Moon)
      score = (((moonPhase - 25) / 25) * (40 - 10) + 10).toInt(); // Interpolates between 10 and 40
    } else if (moonPhase <= 75) {
      // From 50 to 75 (Half Moon to Last Quarter)
      score = (((moonPhase - 50) / 25) * (10 - 40) + 40).toInt(); // Interpolates between 40 and 10
    } else {
      // From 75 to 100 (Last Quarter to Full Moon)
      score = (((moonPhase - 75) / 25) * (100 - 10) + 10).toInt(); // Interpolates between 10 and 100
    }

    switch (weatherCode) {
      case 45: // Fog
      case 48: // Depositing rime fog
      case 51: // Light drizzle
      case 53: // Moderate drizzle
      case 55: // Dense drizzle
      case 61: // Slight rain
      case 63: // Moderate rain
      case 65: // Heavy rain
      case 71: // Slight snowfall
      case 73: // Moderate snowfall
      case 75: // Heavy snowfall
      case 80: // Slight rain showers
      case 81: // Moderate rain showers
      case 86: // Heavy snow showers
        score -= 10;
        break;
      case 66: // Freezing rain (light)
      case 67: // Freezing rain (heavy)
      case 95: // Thunderstorm
      case 96: // Thunderstorm with light hail
      case 99: // Thunderstorm with heavy hail
        score -= 20;
        break;
    }

    score = score.clamp(0, 100);

    return score;
  }
}