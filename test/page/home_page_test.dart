import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:infids/fonts/infids_icons.dart';
import 'package:infids/model/post.dart';
import 'package:infids/page/home_page.dart';

void main() {
  var homeMock;
  final post0 = Post(
      8605,
      '28 Juni 2019',
      PostCategory.AKADEMIK,
      'Jadwal ujian pendadaran periode bulan Juli 2019 dapat dilihat pada laman',
      'https://magister.jteti.ugm.ac.id/s1/index.php?P=JADWAL\nMohon dicermati bila ada perubahan jadwal, profil data mahasiswa, judul, pembimbing dll.\n');
  final post1 = Post(
      8604,
      '26 Juni 2019',
      PostCategory.AKADEMIK,
      'Jadwal UAS Susulan Mahasiswa KKN',
      'UAS susulan bagi mahasiswa peserta KKN antar  semester Genap 2018 - Ganjil 2019 terjadwal sebagai berikut:\nTerima kasih.\n');
  final post2 = Post(
      8602,
      '21 Juni 2019',
      PostCategory.PERKULIAHAN,
      "Up-Date Hari Jum'at, 21 Juni 2019 Jam 14.30 wib Daftar Mahasiswa yang tidak Diperkenankan mengikuti Ujian Akhir Semester Genap 2018/2019",
      '',
      link: 'http://sarjana.jteti.ugm.ac.id/media/30728/70-genap-2018.xlsx');
  final post3 = Post(
      8601,
      '20 Juni 2019',
      PostCategory.AKADEMIK,
      'UAS Susulan bagi Mahasiswa KKN',
      'Bagi mahasiswa yang ingin mengajukan Surat Permohonan Pengajuan UAS Susulan (KHUSUS bagi mahasiswa yang mengikuti KKN antar semester Genap-Ganjil /Juli 2019) paling lambat diterima Bag.Akademik Lt.2 DTETI Rabu, 26 Juni 2019 Jam 12.00 WIB. Pelaksanaan UAS Susulan (Khusus KKN) 27-28 Juni 2019.\nTerima kasih.\n');
  final post4 = Post(
      8599,
      '20 Juni 2019',
      PostCategory.AKADEMIK,
      'UAS Susulan (1)',
      'Diumumkan kepada mahasiswa Prodi Sarjana DTETI bahwa sesuai kalender akademik DTETI, pengumpulan berkas permohonan UAS Susulan paling lambat tanggal 2 Juli 2019 pada jam kerja di Ruang Akademik Lantai 2.\nPelaksanaan UAS Susulan dimulai tanggal 9 Juli 2019.\nTerima kasih.\n');

  setUp(() {
    MockClient client = MockClient((request) async {
      String html = await rootBundle.loadString('test_resources/akademik.html');
      return Response(html, 200);
    });

    homeMock = MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        home: HomePage(client: client, isTest: true,),
      ),
    );
  });

  group('Membuat Page Home', () {
    testWidgets('Mengecek Widget pada Page Home', (WidgetTester tester) async {
      await tester.pumpWidget(homeMock);
      await tester.pump();
      final title = find.text('INFO DTETI');
      final subTitle = find.text('Menampilkan Semua Kategori');
      final btnFilter = find.byKey(Key('button-filter'));
      final listView = find.byKey(Key('post-list'));

      expect(title, findsOneWidget);
      expect(subTitle, findsOneWidget);
      expect(btnFilter, findsOneWidget);
      expect(listView, findsOneWidget);
    });

    testWidgets('Membuat Filter pada Button Filter',
            (WidgetTester tester) async {
          await tester.pumpWidget(homeMock);
          await tester.pump();

          final allCategory = find.text('Semua Kategori');
          final academicCategory = find.text('Kategori Akademik');
          final lectureCategory = find.text('Kategori Perkuliahan');

          expect(allCategory, findsNothing);
          expect(academicCategory, findsNothing);
          expect(lectureCategory, findsNothing);
        });

    testWidgets('Mengganti tulisan subtitle berdasarkan filter',
            (WidgetTester tester) async {
          await tester.pumpWidget(homeMock);

          final allCategory = find.byKey(Key('all-category'));
          final academicCategory = find.byKey(Key('academic-category'));
          final lectureCategory = find.byKey(Key('lecture-category'));

          final subTitle =
          find.text('Menampilkan Semua Kategori', skipOffstage: true);
          final subTitleAcademic =
          find.text('Menampilkan Kategori Akademik', skipOffstage: true);
          final subTitleLecture =
          find.text('Menampilkan Kategori Perkuliahan', skipOffstage: true);

          expect(subTitle, findsOneWidget);
          expect(subTitleAcademic, findsNothing);
          expect(subTitleLecture, findsNothing);

          final btnFilter = find.byKey(Key('button-filter'));

          await tester.tap(btnFilter);
          await tester.pumpAndSettle();
          await tester.tap(academicCategory);
          await tester.pump();

          expect(subTitle, findsNothing);
          expect(subTitleAcademic, findsOneWidget);
          expect(subTitleLecture, findsNothing);

          await tester.tap(btnFilter);
          await tester.pumpAndSettle();
          await tester.tap(lectureCategory);
          await tester.pump();

          expect(subTitle, findsNothing);
          expect(subTitleAcademic, findsNothing);
          expect(subTitleLecture, findsOneWidget);

          await tester.tap(btnFilter);
          await tester.pumpAndSettle();
          await tester.tap(allCategory);
          await tester.pump();

          expect(subTitle, findsOneWidget);
          expect(subTitleAcademic, findsNothing);
          expect(subTitleLecture, findsNothing);
        });

    testWidgets('Menampilkan card dalam listview', (WidgetTester tester) async {
      await tester.pumpWidget(homeMock);

      final listView = find.byKey(Key('post-list'));

      final listCardPost =
      find.descendant(of: listView, matching: find.byType(Card));

      expect(listCardPost, findsNothing);
    });
  });

  group('Pengujian perilaku post', () {
    testWidgets('Menampilkan post dalam card dan list view',
        (WidgetTester tester) async {
          await tester.pumpWidget(homeMock);

      final listView = find.byKey(Key('post-list'));

      await tester.pumpAndSettle();
      expect(listView, findsOneWidget);

      final postCard0 = find.descendant(
          of: find.byKey(Key(post0.id.toString())),
          matching: find.text(post0.title));
      final postCard1 = find.descendant(
          of: find.byKey(Key(post1.id.toString())),
          matching: find.text(post1.title));
      final postCard2 = find.descendant(
          of: find.byKey(Key(post2.id.toString())),
          matching: find.text(post2.title));
      final postCard3 = find.descendant(
          of: find.byKey(Key(post3.id.toString())),
          matching: find.text(post3.title));
      final postCard4 = find.descendant(
          of: find.byKey(Key(post4.id.toString())),
          matching: find.text(post4.title));

      expect(postCard0, findsOneWidget);
      expect(postCard1, findsOneWidget);
      expect(postCard2, findsOneWidget);

          await tester.drag(listView, Offset(0, -300));
          await tester.pumpAndSettle();
      
      expect(postCard3, findsOneWidget);
      expect(postCard4, findsOneWidget);
    });

    testWidgets('Mengecek button action pada post',
        (WidgetTester tester) async {
          await tester.pumpWidget(homeMock);
      await tester.pumpAndSettle();

      final btnSharePost0 = find.descendant(
        of: find.byKey(Key(post0.id.toString())),
        matching: find.byIcon(Icons.share),
      );
      final btnDownloadPost0 = find.descendant(
        of: find.byKey(Key(post0.id.toString())),
        matching: find.byIcon(InfidsIcon.download),
      );
      final btnOpenPost0 = find.descendant(
        of: find.byKey(Key(post0.id.toString())),
        matching: find.byIcon(InfidsIcon.publish),
      );

      final btnSharePost2 = find.descendant(
        of: find.byKey(Key(post2.id.toString())),
        matching: find.byIcon(Icons.share),
      );
      final btnDownloadPost2 = find.descendant(
        of: find.byKey(Key(post2.id.toString())),
        matching: find.byIcon(InfidsIcon.download),
      );
      final btnOpenPost2 = find.descendant(
        of: find.byKey(Key(post2.id.toString())),
        matching: find.byIcon(InfidsIcon.publish),
      );

          final shareTooltip = find.text('Share Informasi');
          final downloadTooltip = find.text('Download File');
          final openInBrowserTooltip = find.text('Buka Dalam Browser');

      expect(btnSharePost0, findsOneWidget);
      expect(btnDownloadPost0, findsNothing);
      expect(btnOpenPost0, findsOneWidget);

          await tester.longPress(btnOpenPost0);
          await tester.pump();

          expect(openInBrowserTooltip, findsOneWidget);

      expect(btnSharePost2, findsOneWidget);
      expect(btnDownloadPost2, findsOneWidget);
      expect(btnOpenPost2, findsOneWidget);

          await tester.longPress(btnSharePost0);
          await tester.pump();

          expect(shareTooltip, findsOneWidget);

          await tester.longPress(btnDownloadPost2);
          await tester.pump();

          expect(downloadTooltip, findsOneWidget);

          await tester.longPress(btnOpenPost2);
          await tester.pump();

          expect(openInBrowserTooltip, findsOneWidget);

          await tester.longPress(btnSharePost2);
          await tester.pump();

          expect(shareTooltip, findsOneWidget);
    });

    testWidgets(
        'Membuka web view salah satu post', (WidgetTester tester) async {
      await tester.pumpWidget(homeMock);
      await tester.pumpAndSettle();
      final btnOpenPost0 = find.descendant(
        of: find.byKey(Key(post0.id.toString())),
        matching: find.byIcon(InfidsIcon.publish),
      );
      await tester.tap(btnOpenPost0);
      expect(btnOpenPost0, findsOneWidget);
    });

    testWidgets(
        'Mendownload file salah satu post', (WidgetTester tester) async {
      await tester.pumpWidget(homeMock);
      await tester.pumpAndSettle();
      final btnDownloadPost2 = find.descendant(
        of: find.byKey(Key(post2.id.toString())),
        matching: find.byIcon(InfidsIcon.download),
      );
      await tester.tap(btnDownloadPost2);
      expect(btnDownloadPost2, findsOneWidget);
    });

    testWidgets('Menyebarkan salah satu post', (WidgetTester tester) async {
      await tester.pumpWidget(homeMock);
      await tester.pumpAndSettle();
      final btnSharePost0 = find.descendant(
        of: find.byKey(Key(post0.id.toString())),
        matching: find.byIcon(Icons.share),
      );
      await tester.tap(btnSharePost0);
      expect(btnSharePost0, findsOneWidget);
    });

    testWidgets('Menampilkan kategori sesuai dengan pilihan',
            (WidgetTester tester) async {
      await tester.pumpWidget(homeMock);
      await tester.pumpAndSettle();

      final btnFilter = find.byKey(Key('button-filter'));
      final allCategory = find.byKey(Key('all-category'));
      final academicCategory = find.byKey(Key('academic-category'));
      final lectureCategory = find.byKey(Key('lecture-category'));
      final post0ByKey = find.byKey(Key(post0.id.toString()));
      final post2ByKey = find.byKey(Key(post2.id.toString()));

      expect(post0ByKey, findsOneWidget);
      expect(post2ByKey, findsOneWidget);

      await tester.tap(btnFilter);
      await tester.pumpAndSettle();
      await tester.tap(academicCategory);
      await tester.pump();

      expect(post0ByKey, findsOneWidget);
      expect(post2ByKey, findsNothing);

      await tester.tap(btnFilter);
      await tester.pumpAndSettle();
      await tester.tap(lectureCategory);
      await tester.pump();

      expect(post0ByKey, findsNothing);
      expect(post2ByKey, findsOneWidget);

      await tester.tap(btnFilter);
      await tester.pumpAndSettle();
      await tester.tap(allCategory);
      await tester.pump();

      expect(post0ByKey, findsOneWidget);
      expect(post2ByKey, findsOneWidget);
    });
  });

  group('Pengambilan data gagal', () {
    var homeMockFailed;

    setUp(() {
      MockClient client = MockClient((request) async {
        return Response('Not found', 404);
      });

      homeMockFailed = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: HomePage(client: client, isTest: true,),
        ),
      );
    });

    testWidgets('Muncul snackbar saat gagal mengambil data',
            (WidgetTester tester) async {
          await tester.pumpWidget(homeMockFailed);

          final textRetry = find.text('Gagal memperbarui data');
          final btnRetry = find.byKey(Key('button-retry'));

          expect(textRetry, findsNothing);
          expect(btnRetry, findsNothing);

          await tester.pumpAndSettle();

          expect(textRetry, findsOneWidget);
          expect(btnRetry, findsOneWidget);

          await tester.tap(btnRetry);
          await tester.pumpAndSettle();

          expect(textRetry, findsNothing);
          expect(btnRetry, findsNothing);
        });
  });
}
