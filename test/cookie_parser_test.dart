import 'package:shelf_cookie/shelf_cookie.dart';
import 'package:test/test.dart';

void main() {
  test('isEmpty is true if header is empty', () {
    var cookies = CookieParser.fromHeader(null);
    expect(cookies.isEmpty, isTrue);
  });

  test('parses cookies from header', () {
    var cookies = CookieParser.fromHeader('foo=bar; baz=qux');
    expect(cookies.isEmpty, isFalse);
    expect(cookies.get('foo'), equals('bar'));
    expect(cookies.get('baz'), equals('qux'));
  });

  test('adds cookie to entries map', () {
    var cookies = CookieParser.fromHeader('foo=bar');
    expect(cookies.isEmpty, isFalse);
    expect(cookies.get('baz'), isNull);
    cookies.set('baz', 'qux');
    expect(cookies.get('baz'), 'qux');
  });

  test('removes cookie from entries map', () {
    var cookies = CookieParser.fromHeader('foo=bar; baz=qux');
    expect(cookies.get('baz'), equals('qux'));
    cookies.remove('baz');
    expect(cookies.get('baz'), isNull);
  });

  test('converts entries back to header string', () {
    var cookies = CookieParser.fromHeader('foo=bar');
    expect(cookies.toString(), equals('foo=bar'));
    cookies.set('baz', 'qux');
    expect(cookies.toString(), equals('foo=bar, baz=qux'));
  });
}
