class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.company = '',
    this.location = '',
    this.rating = 0.0,
  });

  String title;
  String company;
  String location;
  double rating;
  String imagePath;

  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'Thực Tập Sinh  Full-Time Lương Hỗ Trợ 6 Triệu/Tháng',
      company: 'CÔNG TY CỔ PHẦN ĐẦU TƯ VÀ KINH DOANH NHÀ THỜI ĐẠI',
      location: '25',
      rating: 4.3,
    ),
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'User interface Design',
      company: '22',
      location: '18',
      rating: 4.6,
    ),
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'User interface Design',
      company: '24',
      location: '25',
      rating: 4.3,
    ),
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'User interface Design',
      company: '22',
      location: '18',
      rating: 4.6,
    ),
  ];

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'App Design Course',
      company: '12',
      location: '25',
      rating: 4.8,
    ),
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'Web Design Course',
      company: '28',
      location: '208',
      rating: 4.9,
    ),
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'App Design Course',
      company: '12',
      location: '25',
      rating: 4.8,
    ),
    Category(
      imagePath: 'https://static.topcv.vn/company_logos/cong-ty-co-phan-dau-tu-va-kinh-doanh-nha-thoi-dai-5f800f8a86151.jpg',
      title: 'Web Design Course',
      company: '28',
      location: '208',
      rating: 4.9,
    ),
  ];
}
