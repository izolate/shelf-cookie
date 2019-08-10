# shelf_cookie

Cookie parser middleware for Dart Shelf ecosystem.
Adds a `Cookie` instance to `request.context['cookies']` to manipulate cookies.

## Example

```dart
import 'package:shelf_cookie/shelf_cookie.dart';

var handler = const shelf.Pipeline()
    .addMiddleware(cookieParser())
    .addHandler((req) async {
      // Respond with cookies.
      response.ok(jsonEncode(req['cookies']));
    });
```
