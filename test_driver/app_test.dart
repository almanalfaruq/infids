import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  // This test may become fail if website's content has been changed
  test('Memeriksa informasi yang didapatkan', () async {
    await driver.waitFor(find.byValueKey('8635'));

    final title8635 = find.descendant(
        of: find.byValueKey('8635'), matching: find.byValueKey('8635-title'));

    final content8635 = find.descendant(
        of: find.byValueKey('8635'), matching: find.byValueKey('8635-content'));

    expect(await driver.getText(title8635), 'Perkuliahan MANAJEMEN INDUSTRI');
    expect(await driver.getText(content8635),
        'DIumumkan kepada mahasiswa Sarjana DTETI bahwa dikarenakan terjadi kesalahan teknis, maka perkuliahan Manajemen Industri yang sebelumnya terjadwal Hari Selasa jam 07.15 WIB di Ruang E7 diganti menjadi Kamis jam 07.15 di Ruang TE3 PAU. Mohon maaf atas ketidaknyamanan ini. Terima kasih.\nAkademik DTETI.\n');

    // Bug on scrollUntilVisible - It will goes up when the widget was found
//    await driver.scrollUntilVisible(
//        find.byType('ListView'), find.byValueKey('8569'),
//        dyScroll: -300);
    // Cannot use this method because of multiple scrollable widget
//    await driver.scrollIntoView(find.byValueKey('8569'));

    // dy value depends on device size - iPhone 8 = -3000
    await driver.scroll(
        find.byType('ListView'), 0, -3000, Duration(milliseconds: 100));

    final title8569 = find.descendant(
        of: find.byValueKey('8569'), matching: find.byValueKey('8569-title'));

    final content8569 = find.descendant(
        of: find.byValueKey('8569'), matching: find.byValueKey('8569-content'));
    expect(await driver.getText(title8569),
        'Jadwal Ujian Akhir Semester Genap 2018/2019 dari Fakultas Filsafat UGM');
    expect(await driver.getText(content8569), '');
  }, timeout: Timeout(Duration(minutes: 1)));
}
