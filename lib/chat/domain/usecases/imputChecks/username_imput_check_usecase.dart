class UserNameInputCheck {
  String call(String username) {
    var error = '';
    if (username.isEmpty) {
      error = 'Enter Name';
    }
    return error;
  }
}
