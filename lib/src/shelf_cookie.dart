import 'package:shelf/shelf.dart' as shelf;

import 'cookies.dart';

/// Creates a Shelf [Middleware] to parse cookies.
shelf.Middleware cookieParser() {
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) {
      return Future.sync(() {
        return innerHandler(request.change(
          context: {
            'cookies': Cookies.fromHeader(
              request.headers[HttpHeaders.cookieHeader],
            ),
          },
        ));
      });
    };
  };
}
