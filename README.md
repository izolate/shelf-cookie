# shelf_cookie

Cookie parser middleware for the Dart Shelf ecosystem.
Reads cookies in request, sets cookies in response.

Adds a `CookieParser` instance to `request.context['cookies']` to manipulate cookies.

## Example

```dart
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_cookie/shelf_cookie.dart';

/// Request contains cookie header.
/// e.g. 'cookie': 'ping=foo'
var handler = const shelf.Pipeline()
    .addMiddleware(cookieParser())
    .addHandler((req) async {
      var cookies = req.context['cookies'];
      if (cookies.get('ping') == 'foo') {
        cookies.set('pong', 'bar');
      }
      // Response will set cookie header.
      // e.g. 'set-cookie': 'ping=foo; pong=bar'
      return shelf.Response.ok('OK');
    });
```
