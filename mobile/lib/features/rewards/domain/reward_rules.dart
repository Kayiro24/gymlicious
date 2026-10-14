/// Every XP value and the level curve, in one place (brief section 2).
abstract final class RewardRules {
  static const checkInXp = 10;

  /// Extra, once per day, when that day also has a session with sets.
  static const sessionXp = 10;
  static const personalRecordXp = 25;
  static const weeklyGoalXp = 50;

  /// Reaching level L takes `levelStep × L × (L − 1)` total XP.
  static const levelStep = 50;

  static int totalXpForLevel(int level) => levelStep * level * (level - 1);
}

class LevelProgress {
  const new({
    required this.level,
    required this.xpIntoLevel,
    required this.xpForLevel,
    required this.totalXp,
  });

  factory fromTotalXp(int totalXp) {
    var level = 1;
    while (RewardRules.totalXpForLevel(level + 1) <= totalXp) {
      level += 1;
    }
    final floor = RewardRules.totalXpForLevel(level);
    return LevelProgress(
      level: level,
      xpIntoLevel: totalXp - floor,
      xpForLevel: RewardRules.totalXpForLevel(level + 1) - floor,
      totalXp: totalXp,
    );
  }

  final int level;
  final int xpIntoLevel;
  final int xpForLevel;
  final int totalXp;

  int get xpToNext => xpForLevel - xpIntoLevel;
}
