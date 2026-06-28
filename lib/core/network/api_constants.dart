abstract class ApiConstants {
  static const String devBaseUrl =
      'https://go2car-dev.herokuapp.com/api/v1'; // Placeholder
  static const String prodBaseUrl = 'https://api.go2car.com/v1'; // Placeholder

  static const String devSocketUrl =
      'ws://go2car-dev.herokuapp.com/ws'; // Placeholder
  static const String prodSocketUrl = 'ws://api.go2car.com/ws'; // Placeholder

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String profile = '/users/me';
  static const String logout = '/auth/logout';
  static const String loginGuest = '/auth/login/guest';
  static const String savedCars = '/vehicles/user/me';
  static const String addVehicle = '/vehicles/';

  // Car Slots
  static const String slots = '/slots/all';
  static const String availableSlots = '/slots/available';
  static const String reserveSlot = '/slots/reserve';

  // Profile
  static const String updateProfile = '/users/me';
  static const String changePassword = '/users/me/password';
  static const String uploadAvatar = '/auth/profile/avatar';

  // Find Car
  static const String findCar = '/vehicles/user/me';
  static const String searchPlate = '/vehicles/search/plate';
  static const String searchAttributes = '/vehicles/search/attributes';
  static const String searchAdvanced = '/vehicles/search/advanced';
  static const String floors = '/floors/all';
  static const String sections = '/sections/all';
  static String vehicleMap(String plate) => '/vehicles/$plate/map';

  // Dashboard
  static const String dashboard = '/admin/summary';

  // Admin
  static const String adminParkingOverview = '/admin/parking/overview';
  static const String adminAnalysis = '/admin/parking/analysis';
  static const String adminManageSlots = '/admin/slots';
}
