abstract final class ExercisesRoutes {
  static const root = '/exercises';
  static const idParameter = 'id';

  static String detail(String exerciseId) => '$root/$exerciseId';
}
