import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final id1 = 2901;
  final id2 = 2198;

  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });

  test('Memasukkan data id dan mendapatkan id terakhir dari Shared Preferences',
      () async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('id', id1);
    expect(sharedPreferences.getInt('id'), id1);
    expect(sharedPreferences.getInt('id'), isNot(id2));

    await sharedPreferences.setInt('id', id2);
    expect(sharedPreferences.getInt('id'), id2);
    expect(sharedPreferences.getInt('id'), isNot(id1));
  });
}
