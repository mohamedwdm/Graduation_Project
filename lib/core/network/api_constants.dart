abstract class ApiConstants {
  static const String devBaseUrl = 'https://go2car-dev.herokuapp.com/api/v1'; // Placeholder
  static const String prodBaseUrl = 'https://api.go2car.com/v1'; // Placeholder
  
  static const String devSocketUrl = 'ws://go2car-dev.herokuapp.com/ws'; // Placeholder
  static const String prodSocketUrl = 'ws://api.go2car.com/ws'; // Placeholder

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String profile = '/auth/profile';
  static const String logout = '/auth/logout';
  static const String loginGuest = '/auth/login/guest';

  // Car Slots
  static const String slots = '/slots';
  static const String reserveSlot = '/slots/reserve';

  // Profile
  static const String updateProfile = '/auth/profile/update';
  static const String uploadAvatar = '/auth/profile/avatar';

  // Find Car
  static const String findCar = '/find-car';

  // Dashboard
  static const String dashboard = '/dashboard/summary';

  // Admin
  static const String adminParkingOverview = '/admin/parking/overview';
  static const String adminAnalysis = '/admin/parking/analysis';
  static const String adminManageSlots = '/admin/slots';
}
