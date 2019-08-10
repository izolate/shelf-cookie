/// The cookies from the header of a [Request].
class Cookies {
  /// The HTTP cookies.
  final Map<String, String> _entries = {};

  /// Creates a new [Cookies] instance from [header] value.
  Cookies.fromHeader(String header) {
    // No cookies.
    if (header == null) {
      return;
    }

    // Parse cookie header and update cookie [Map].
    var cookies = header.split(';');
    for (var cookie in cookies) {
      var parts = cookie.split('=');
      _entries.putIfAbsent(parts.first, () => parts.last);
    }
  }

  /// Retrieves the value of a cookie by [name].
  String get(String name) => _entries[name];
}
