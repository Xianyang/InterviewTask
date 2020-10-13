import 'package:test/test.dart';
import 'package:flutter_qr_for_string/main.dart';

void main() {
  test('Httpclient returns random string with 10 characters', () async {
    final httpClient = HttpClient();

    String content = await httpClient.fetchRandomString();

    expect(content.length, 10);
  });
}
