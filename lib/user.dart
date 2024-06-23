class User {
  String? name = '';
  String? phoneNumber = '';

  User.init({this.name, this.phoneNumber});

  static final User _instance = User.init();

  static User get instance => _instance;

  void logout() {
    name = null;
    phoneNumber = null;
  }

  void login({
    required String name,
    required String phoneNumber,
  }) {
    _instance.name = name;
    _instance.phoneNumber = phoneNumber;
  }
}
