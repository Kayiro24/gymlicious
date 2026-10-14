abstract final class TrainRoutes {
  static const root = '/train';
  static const session = '/session';
  static const splitIdParameter = 'splitId';
  static const newSplitId = 'new';

  static String splitEditor(String splitId) => '$root/splits/$splitId';

  static String get newSplit => splitEditor(newSplitId);
}
