/// Parses cookies from the `Cookie` header of a [Request].
///
/// Stores all cookies in a [Map], with convenience methods to
/// get and set entries. Exposes a `toString()` method to convert
/// entries back to the raw HTTP header value.
class CookieParser {
  /// A [Map] of HTTP cookies.
  final Map<String, String> entries = {};

  /// Creates a new [CookieParser] instance from an HTTP [header] value.
  CookieParser.fromHeader(String header) {
    // No cookies.
    if (header == null) {
      return;
    }

    // Parse cookie header and update entries [Map].
    List<String> cookies = header.split(';');
    // There's no delimiter if there's only one cookie.
    if (cookies.isEmpty) {
      cookies = <String>[header];
    }
    for (var cookie in cookies) {
      var parts = cookie.trim().split('=');
      entries.putIfAbsent(parts.first, () => parts.last);
    }
  }

  /// Denotes whether [entries] is empty.
  bool get isEmpty => entries.isEmpty;

  /// Convenience method to retrieve a cookie by [name].
  String get(String name) => entries[name];

  /// Convenience method to add a new cookie entry to [entries].
  // void set(String name, value) => _entries.putIfAbsent(name, () => value);
  String set(String name, value) =>
      entries.update(name, (_) => value, ifAbsent: () => value);

  /// Convenience method to remove a cookie by [name].
  String remove(String name) => entries.remove(name);

  /// Converts the [entries] to a HTTP header string value.
  String toString() {
    var str = '';
    entries.forEach((entry, value) => str += '$entry=$value; ');
    // Trim the trailing delimiter from the end of the string.
    return str.endsWith('; ') ? str.substring(0, str.length - 2) : str;
  }
}
