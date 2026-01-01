class AppRoutePath {
  final String location;
  AppRoutePath(this.location);

  bool get isWelcome => location == '/';
  bool get isLogin => location == '/login';
  bool get isHome => location == '/home';
  bool get isDenied => location == '/denied';
}
