import 'dart:io';

import 'package:shelf/shelf.dart';

/// Parses cookies from the `Cookie` header of a [Request].
///
/// Stores all cookies in a [Map], with convenience methods to
/// get and set entries. Exposes a `toString()` method to convert
/// entries back to the raw HTTP header value.
class CookieParser {
  /// A list of parsed cookies.
  final List<Cookie> cookies = [];

  /// Creates a new [CookieParser] by parsing the `Cookie` header [value].
  CookieParser.fromCookieValue(String value) {
    // No cookies.
    if (value == null) {
      return;
    }

    // Request header cookies are delimited by a semicolon.
    List<String> items = value.split(';');
    // But there's no delimiter if there's only one cookie.
    if (items.isEmpty) {
      items = <String>[value];
    }
    for (var item in items) {
      var parts = item.trim().split('=');
      cookies.add(Cookie(parts.first, parts.last));
    }
  }

  /// Factory constructor to create a new instance from request [headers].
  factory CookieParser.fromHeader(Map<String, dynamic> headers) {
    return CookieParser.fromCookieValue(headers[HttpHeaders.cookieHeader]);
  }

  /// Denotes whether the [cookies] list is empty.
  bool get isEmpty => cookies.isEmpty;

  /// Retrieves a cookie by [name].
  Cookie get(String name) => cookies
      .firstWhere((Cookie cookie) => cookie.name == name, orElse: () => null);

  /// Adds a new cookie to [cookies] list.
  Cookie set(
    String name,
    String value, {
    String domain,
    String path,
    DateTime expires,
    bool httpOnly,
    bool secure,
    int maxAge,
  }) {
    var cookie = Cookie(name, value);
    if (domain != null) cookie.domain = domain;
    if (path != null) cookie.path = path;
    if (expires != null) cookie.expires = expires;
    if (httpOnly != null) cookie.httpOnly = httpOnly;
    if (secure != null) cookie.secure = secure;
    if (maxAge != null) cookie.maxAge = maxAge;

    // Update existing cookie, or append new one to list.
    var index = cookies.indexWhere((item) => item.name == name);
    if (index != -1) {
      cookies.replaceRange(index, index + 1, [cookie]);
    } else {
      cookies.add(cookie);
    }
    return cookie;
  }

  /// Removes a cookie from list by [name].
  void remove(String name) =>
      cookies.removeWhere((Cookie cookie) => cookie.name == name);

  /// Clears the cookie list.
  void clear() => cookies.clear();

  /// Converts the cookies to a string value to use in a `Set-Cookie` header.
  ///
  /// This implements the old RFC 2109 spec, which allowed for multiple
  /// cookies to be folded into a single `Set-Cookie` header value,
  /// separated by commas.
  ///
  /// As of RFC 6265, this folded mechanism is deprecated in favour of
  /// a multi-header approach.
  ///
  /// Unfortunately, Shelf doesn't currently support multiple headers
  /// of the same type. This is an ongoing issue, but once resolved,
  /// this method can effectively be removed.
  ///
  /// https://github.com/dart-lang/shelf/issues/44
  String toString() {
    return cookies.fold(
      '',
      (prev, element) => prev.isEmpty
          ? element.toString()
          : '${prev.toString()}, ${element.toString()}',
    );
  }
}
