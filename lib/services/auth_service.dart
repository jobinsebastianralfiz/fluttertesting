class AuthService {
  String? _currentUser;
  bool _isLoggedIn = false;

  final Map<String, dynamic> _userDatabase = {
    'user1@example.com': "Password123",
    'user2@example.com': 'SecurePass456',
    'admin@example.com': 'AdminPass789'
  };

  String? get currentUser => _currentUser;

  bool get isLoggedIn => _isLoggedIn;

  // login

  bool login(String email, String password) {
    if (_userDatabase.containsKey(email) && _userDatabase[email] == password) {
      _currentUser = email;
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  // logout
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
  }

// register User

  bool registerUser(String email, String password) {
    if (!_isValidEmail(email)) {
      return false;
    }
    if (!_isValidPassword(password)) {
      return false;
    }

    if (_userDatabase.containsKey(email)) {
      return false;
    }
    _userDatabase[email] = password;
    return true;
  }

  bool changePassword(String email, String oldPassword, String newPassword) {
    if (_userDatabase.containsKey(email) &&
        _userDatabase[email] == oldPassword) {
      if (_isValidPassword(newPassword)) {
        _userDatabase[email] = newPassword;
        return true;
      }
    }
    return false;
  }

// util methods

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains(".");
  }

  bool _isValidPassword(String password) {
    return password.length > 8 && password.contains(RegExp(r'[0-9]'));
  }
}
