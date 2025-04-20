class Config {
  const Config._();

  static String get apiBaseUrl => const String.fromEnvironment('apiBaseUrl');
}
