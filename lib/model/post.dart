enum PostCategory { AKADEMIK, PERKULIAHAN }

class Post {
  int id;
  String date;
  PostCategory category;
  String title;
  String content;
  String link = '';

  Post(this.id, this.date, this.category, this.title, this.content,
      {this.link});

  @override
  String toString() {
    return "id: ${this.id}\n"
        "date: ${this.date}\n"
        "category: ${this.category == PostCategory.AKADEMIK ? 'Akademik' : 'Perkuliahan'}\n"
        "title: ${this.title}\n"
        "content: ${this.content}\n"
        "link: ${this.link}";
  }

  String get categoryString =>
      this.category == PostCategory.AKADEMIK ? 'Akademik' : 'Perkuliahan';

  String get postFormattedString {
    if (this.content.isNotEmpty && this.link != null) {
      return "[Info ${this.categoryString}]" +
          "\n${this.title}" +
          "\n${this.date}" +
          "\n\n${this.content}" +
          "\nLink Download: ${this.link}";
    } else if (this.content.isNotEmpty) {
      return "[Info ${this.categoryString}]" +
          "\n${this.title}" +
          "\n${this.date}" +
          "\n\n${this.content}";
    } else if (this.link != null) {
      return "[Info ${this.categoryString}]" +
          "\n${this.title}" +
          "\n${this.date}" +
          "\n\nLink Download: ${this.link}";
    } else {
      return "[Info ${this.categoryString}]" +
          "\n${this.title}" +
          "\n${this.date}";
    }
  }

  @override
  operator ==(dynamic other) {
    return other is Post &&
        other.id == this.id &&
        other.date == this.date &&
        other.category == this.category &&
        other.title == this.title &&
        other.content == this.content &&
        other.link == this.link;
  }

  Post.fromMap(Map<String, dynamic> map,
      {String columnId = 'id',
        String columnDate = 'date',
        String columnCategory = 'category',
        String columnTitle = 'title',
        String columnContent = 'content',
      String columnLink = 'link'}) {
    this.id = map[columnId];
    this.date = map[columnDate];
    this.category = PostCategory.values[map[columnCategory]];
    this.title = map[columnTitle];
    this.content = map[columnContent];
    this.link = map[columnLink];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'date': this.date,
      'category': this.category.index,
      'title': this.title,
      'content': this.content,
      'link': this.link,
    };
  }
}
