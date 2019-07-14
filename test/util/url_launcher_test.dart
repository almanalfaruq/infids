import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infids/provider/web_scraper.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/url_launcher');
  final List<MethodCall> log = <MethodCall>[];
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    log.add(methodCall);
  });

  tearDown(() {
    log.clear();
  });

  test('canLaunch', () async {
    await canLaunch(WebScraper.ACADEMIC_URL);
    expect(
      log,
      <Matcher>[
        isMethodCall('canLaunch', arguments: <String, Object>{
          'url': WebScraper.ACADEMIC_URL,
        })
      ],
    );
  });

  test('launch default behavior', () async {
    await launch(WebScraper.ACADEMIC_URL);
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, Object>{
          'url': WebScraper.ACADEMIC_URL,
          'useSafariVC': true,
          'useWebView': false,
          'enableJavaScript': false,
          'enableDomStorage': false,
          'universalLinksOnly': false,
        })
      ],
    );
  });
}
