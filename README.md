# shelf_cookie

Cookie parser middleware for the Dart Shelf ecosystem.
Reads cookies in request, sets cookies in response.

Adds a `CookieParser` instance to `request.context['cookies']` to help
manipulate cookies.

## Example

```dart
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_cookie/shelf_cookie.dart';

/// Handle a request that contains a `Cookie` header.
/// e.g. 'Cookie': 'ping=foo'
var handler = const shelf.Pipeline()
    // initialize cookie parser middleware
    .addMiddleware(cookieParser())
    .addHandler((req) async {
  CookieParser cookies = req.context['cookies'];

  // Retrieve request cookies.
  var reqCookie = cookies.get('ping');
  print(reqCookie.name); // foo

  // Clear cookies because Shelf currently only supports
  // a single `Set-Cookie` header in response.
  cookies.clear();

  // Create a cookie for response.
  var resCookie = cookies.set('pong', 'bar', secure: true);

  // Middleware will add `Set-Cookie` response header.
  // e.g. 'Set-Cookie': 'pong=bar; Secure; HttpOnly'
  return shelf.Response.ok('OK');
});
```
