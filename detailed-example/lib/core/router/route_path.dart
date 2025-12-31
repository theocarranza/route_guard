class MyRoutePath {
  final String location;
  MyRoutePath(this.location);

  bool get isWelcome => location == '/';
  bool get isLogin => location == '/sign-in';
  bool get isHome => location == '/home';
  bool get isDenied => location == '/denied';
  bool get isLogout => location == '/sign-out';
}
