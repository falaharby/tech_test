class Blog {
  final int id;
  final String title, subtitle, photo, content, author, tag;
  final DateTime createdAt;

  Blog(this.id, this.title, this.subtitle, this.photo, this.content,
      this.author, this.tag, this.createdAt);

  Blog.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        subtitle = json['subTitle'],
        content = json['content'],
        author = json['author'],
        tag = json['tag'],
        photo = json['photo'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(
          json['create_at'] * 1000,
        );
}

class BlogResponse {
  final List<Blog> datas;
  final String error;

  BlogResponse(this.datas, this.error);

  BlogResponse.fromJson(Map<String, dynamic> json)
      : datas = (json["results"] as List).map((i) => Blog.fromJson(i)).toList(),
        error = "";

  BlogResponse.withError(String errorValue)
      : datas = [],
        error = errorValue;
}
