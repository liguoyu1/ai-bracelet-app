class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8080',
  );

  // Endpoints
  static const String health = '/api/health';
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String me = '/api/auth/me';
  static const String products = '/api/products';
  static const String elements = '/api/elements';
  static const String designs = '/api/designs';
  static const String myDesigns = '/api/designs/mine';
  static const String orders = '/api/orders';
  static const String favorites = '/api/favorites';
  static const String toggleFavorite = '/api/favorites/toggle';
  static const String energyAssess = '/api/energy/assess';
  static const String energyHistory = '/api/energy/history';
  static const String earnings = '/api/earnings';
  static const String earningsHistory = '/api/earnings/history';
  static const String upload = '/api/upload';
  static const String adminProducts = '/api/admin/products';
  static const String adminElements = '/api/admin/elements';
}
