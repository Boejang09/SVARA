class HeartNewsItem {
  final String title;
  final String category;
  final String source;
  final String date;
  final String description;
  final String url;
  final String imageAsset;

  const HeartNewsItem({
    required this.title,
    required this.category,
    required this.source,
    required this.date,
    required this.description,
    required this.url,
    required this.imageAsset,
  });
}

abstract final class HeartNewsData {
  static const List<HeartNewsItem> all = [
    HeartNewsItem(
      title:
          'Penyakit Jantung Incar Anak Muda, Ada Pria 26 Tahun Terkena Serangan',
      category: 'Kesehatan Jantung',
      source: 'CNBC Indonesia',
      date: '7 Agustus 2026',
      description:
          'Penyakit jantung juga dapat menyerang usia muda. '
          'Kenali faktor risiko dan pentingnya menjaga kesehatan jantung sejak dini.',
      url:
          'https://www.cnbcindonesia.com/lifestyle/20260807111520-33-757369/penyakit-jantung-incar-anak-muda-ada-pria-26-tahun-terkena-serangan',
      imageAsset:
          'assets/images/news/cnbc_2026_young_heart.jpeg',
    ),

    HeartNewsItem(
      title:
          'Semnas di UMS, dr. Gia Pratama Soroti Penyakit Jantung dan Stroke sebagai Penyebab Kematian Tertinggi',
      category: 'Kesehatan',
      source: 'ANTARA News Jateng',
      date: '2026',
      description:
          'Pembahasan mengenai penyakit jantung dan stroke serta pentingnya '
          'meningkatkan kesadaran masyarakat terhadap faktor risikonya.',
      url:
          'https://jateng.antaranews.com/berita/638477/semnas-di-ums-dr-gia-pratama-soroti-penyakit-jantung-dan-stroke-sebagai-penyebab-kematian-tertinggi',
      imageAsset:
          'assets/images/news/antaranews_ums_gia.webp',
    ),

    HeartNewsItem(
      title:
          'Penyakit Jantung dan Kanker Masih Jadi Penyebab Kematian Tertinggi, Gaya Hidup Disebut Faktor Utama',
      category: 'Gaya Hidup',
      source: 'Universitas Muhammadiyah Surakarta',
      date: '2026',
      description:
          'Gaya hidup menjadi salah satu faktor yang mendapat perhatian '
          'dalam upaya pencegahan penyakit jantung dan kanker.',
      url:
          'https://news.ums.ac.id/id/berita/penyakit-jantung-dan-kanker-masih-jadi-penyebab-kematian-tertinggi-gaya-hidup-disebut-faktor-utama/',
      imageAsset:
          'assets/images/news/ums_heart_cancer.jpg',
    ),

    HeartNewsItem(
      title:
          'DIY Catat Kasus Penyakit Jantung Tertinggi di Indonesia',
      category: 'Data Kesehatan',
      source: 'CNN Indonesia',
      date: '7 Oktober 2025',
      description:
          'Informasi mengenai kasus penyakit jantung di Indonesia dan '
          'pentingnya perhatian terhadap kesehatan jantung.',
      url:
          'https://www.cnnindonesia.com/gaya-hidup/20251007131438-255-1281868/diy-catat-kasus-penyakit-jantung-tertinggi-di-indonesia',
      imageAsset:
          'assets/images/news/cnn_diy_heart.jpeg',
    ),

    HeartNewsItem(
      title:
          '10 Provinsi dengan Prevalensi Penyakit Jantung Tertinggi',
      category: 'Data Kesehatan',
      source: 'GoodStats',
      date: '2024',
      description:
          'Data mengenai prevalensi penyakit jantung di berbagai provinsi '
          'di Indonesia berdasarkan data kesehatan yang tersedia.',
      url:
          'https://goodstats.id/article/10-provinsi-dengan-prevalensi-penyakit-jantung-tertinggi-r0yvq',
      imageAsset:
          'assets/images/news/goodstats_prevalence.webp',
    ),

    HeartNewsItem(
      title:
          'Dokter Ungkap Anak Muda Mulai Kena Penyakit Jantung, Begini Alasannya',
      category: 'Kesehatan Jantung',
      source: 'CNBC Indonesia',
      date: '28 Mei 2025',
      description:
          'Dokter menjelaskan sejumlah faktor yang dapat meningkatkan '
          'risiko penyakit jantung pada usia muda.',
      url:
          'https://www.cnbcindonesia.com/lifestyle/20250528175731-33-637079/dokter-ungkap-anak-muda-mulai-kena-penyakit-jantung-begini-alasannya',
      imageAsset:
          'assets/images/news/cnbc_young_heart.jpeg',
    ),
  ];

  static List<HeartNewsItem> get latest {
    return all.take(3).toList(growable: false);
  }
}