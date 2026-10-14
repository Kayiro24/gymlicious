/// Build-time configuration from `--dart-define-from-file=config/<flavor>.json`.
class AppConfig {
  const new({required this.flavor, required this.isOnlineQuotesEnabled});

  factory fromEnvironment() => const AppConfig(
    flavor: String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
    isOnlineQuotesEnabled: bool.fromEnvironment(
      'ONLINE_QUOTES_ENABLED',
      defaultValue: true,
    ),
  );

  final String flavor;
  final bool isOnlineQuotesEnabled;

  bool get isProduction => flavor == 'prod';
}
