///model class for User
class User {
  static int userID;
  String username;
  static String globalUsername;
  String password;
  static String email;
  static int loginResponse;
  static int responseStatusCreate;
  static bool isLogin = false;
  static bool isOrganiser = false;
  static bool isAdmin = false;
  static bool isSubscriber = false;

  User(this.username, this.password);
  User.fromUsername(this.username);
}
