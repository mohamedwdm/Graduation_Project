enum Environment { dev, staging, prod }

class EnvConfig {
  final String apiBaseUrl;
  final String socketBaseUrl;
  final bool enableLogging;
  final Environment environment;

  static EnvConfig? _instance;

  EnvConfig._({
    required this.apiBaseUrl,
    required this.socketBaseUrl,
    required this.enableLogging,
    required this.environment,
  });

  static void initialize(Environment env) {
    switch (env) {
      case Environment.dev:
        _instance = EnvConfig._(
          apiBaseUrl: 'https://go2car-dev.herokuapp.com/api/v1',
          socketBaseUrl: 'ws://go2car-dev.herokuapp.com/ws',
          enableLogging: true,
          environment: Environment.dev,
        );
        break;
      case Environment.staging:
        _instance = EnvConfig._(
          apiBaseUrl: 'https://go2car-staging.herokuapp.com/api/v1',
          socketBaseUrl: 'ws://go2car-staging.herokuapp.com/ws',
          enableLogging: true,
          environment: Environment.staging,
        );
        break;
      case Environment.prod:
        _instance = EnvConfig._(
          apiBaseUrl: 'https://api.go2car.com/v1',
          socketBaseUrl: 'ws://api.go2car.com/ws',
          enableLogging: false,
          environment: Environment.prod,
        );
        break;
    }
  }

  static EnvConfig get instance {
    if (_instance == null) {
      throw Exception('EnvConfig has not been initialized. Call EnvConfig.initialize() in main.dart');
    }
    return _instance!;
  }

  static bool get isDev => instance.environment == Environment.dev;
}
