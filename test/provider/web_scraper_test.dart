import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:infids/model/post.dart';
import 'package:infids/provider/web_scraper.dart';
import 'package:test/test.dart';

void main() {
  group('Penanganan Respon', () {
    var webScraper;

    setUp(() {
      webScraper = WebScraper();
    });

    test('Respon 404', () async {
      webScraper.client = MockClient((request) async {
        return Response('Not Found', 404);
      });

      final posts = await webScraper.getPostsFromWebsite();
      expect(posts.length, 0);
    });

    test('Respon 200', () async {
      webScraper.client = MockClient((request) async {
        final file = File('test_resources/akademik.html');
        String html = await file.readAsString();
        return Response(html, 200);
      });

      final posts = await webScraper.getPostsFromWebsite();
      expect(posts.length, greaterThan(0));
    });
  });

  group('Penguraian HTML', () {
    var webScraper;

    setUpAll(() {
      webScraper = WebScraper();
      webScraper.client = MockClient((request) async {
        final file = File('test_resources/akademik.html');
        String html = await file.readAsString();
        return Response(html, 200);
      });
    });

    test('List Post > 20', () async {
      final posts = await webScraper.getPostsFromWebsite();
      expect(posts.length, greaterThan(20));
    });

    test('Pengecekan Isi Post Nomor 1-5', () async {
      final posts = await webScraper.getPostsFromWebsite();
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
          link:
              'http://sarjana.jteti.ugm.ac.id/media/30728/70-genap-2018.xlsx');
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
      expect(posts[0], PostMatcher(post0));
      expect(posts[1], PostMatcher(post1));
      expect(posts[2], PostMatcher(post2));
      expect(posts[3], PostMatcher(post3));
      expect(posts[4], PostMatcher(post4));
    });

    test('Arahkan user membuka browser untuk konten panjang', () async {
      final posts = await webScraper.getPostsFromWebsite();

      final post = Post(
          8577,
          '10 Juni 2019',
          PostCategory.AKADEMIK,
          "Yth. Para Asisten Tutorial Sem. Genap TA 2018/2019 (Daftar nama terlampir)",
          'Untuk melihat konten, buka melalui browser anda.');

      expect(posts[6], PostMatcher(post));
    });
  });
}

class PostMatcher extends Matcher {
  final Post _post;

  PostMatcher(Post post) : this._post = post;

  @override
  Description describe(Description description) {
    return description.addDescriptionOf(_post);
  }

  @override
  bool matches(item, Map matchState) {
    final p = item as Post;
    return p is Post &&
        p.id == _post.id &&
        p.date == _post.date &&
        p.category == _post.category &&
        p.title == _post.title &&
        p.content == _post.content &&
        p.link == _post.link;
  }
}
