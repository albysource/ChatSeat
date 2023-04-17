class ConnectionManager {
  static ConnectionManager? _instance;

  static ConnectionManager getInstance() {
    return _instance ??= ConnectionManager();
  }
}
