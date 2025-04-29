class Config {
  const Config._();

  static String get apiBaseUrl => const String.fromEnvironment('apiBaseUrl');

  static String get websocketBaseUrl => const String.fromEnvironment('websocketBaseUrl');
}
