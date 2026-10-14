enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  forearms,
  quads,
  hamstrings,
  glutes,
  calves,
  core,
  fullBody,
  cardio;

  static MuscleGroup? tryParse(String? name) => values.asNameMap()[name];
}

enum Equipment {
  barbell,
  dumbbell,
  machine,
  cable,
  bodyweight,
  kettlebell,
  band,
  other;

  static Equipment? tryParse(String? name) => values.asNameMap()[name];
}
