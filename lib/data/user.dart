class   User {
     static int userID;
     String username;
     static String globalUsername;
     String password;
     static int loginResponse;
     static int responseStatusCreate;
     static bool isLogin = false;
     static bool isOrganiser = false;
User(
  
  this.username, this.password);
User.fromUsername(
  
  this.username );
}
