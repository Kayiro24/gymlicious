abstract final class HistoryRoutes {
  static const root = '/history';
  static const idParameter = 'sessionId';

  static String detail(String sessionId) => '$root/$sessionId';

  static String edit(String sessionId) => '$root/$sessionId/edit';
}
