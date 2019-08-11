import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_cookie/shelf_cookie.dart';

void main() {
  /// Request contains cookie header.
  /// e.g. 'cookie': 'ping=foo'
  var _ = const shelf.Pipeline()
      .addMiddleware(cookieParser())
      .addHandler((req) async {
    CookieParser cookies = req.context['cookies'];
    if (cookies.get('ping') == 'foo') {
      cookies.set('pong', 'bar');
    }
    // Response will set cookie header.
    // e.g. 'set-cookie': 'ping=foo, pong=bar'
    return shelf.Response.ok('OK');
  });
}
