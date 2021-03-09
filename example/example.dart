import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cookie/shelf_cookie.dart';

void main() {
  /// Request contains cookie header.
  /// e.g. 'cookie': 'ping=foo'
  var handler = const shelf.Pipeline()
      .addMiddleware(cookieParser())
      .addHandler((req) async {
    CookieParser cookies = req.context['cookies'] as CookieParser;
    if (cookies.get('ping') != null) {
      // Clear cookies because Shelf currently only supports
      // a single `Set-Cookie` header in response.
      cookies.clear();
      cookies.set('pong', 'bar', secure: true);
    }

    // Response will set cookie header.
    // e.g. 'set-cookie': 'pong=bar; Secure; HttpOnly'
    return shelf.Response.ok('check your cookies');
  });

  io.serve(handler, 'localhost', 8080).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}
