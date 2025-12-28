class AppRoutes {
  // Prevent instantiation
  AppRoutes._();
  
  // Auth Routes
  static const String signIn = '/';
  
  // Chat Routes
  static const String usersList = '/users-list';
  static const String chat = '/chat/:userId';
  
  // Route names for named navigation
  static const String signInName = 'signIn';
  static const String usersListName = 'usersList';
  static const String chatName = 'chat';
}