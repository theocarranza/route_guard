class AppRoutePath {
  final String location;
  AppRoutePath(this.location);

  bool get isLogin => location == '/login';
  bool get isHome => location == '/home';
}
