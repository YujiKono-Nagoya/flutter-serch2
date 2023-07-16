class Book {
  const Book({
    required this.title,
    required this.content,
    required this.genre,
    required this.author,
  });

  Book.fromJson(Map<String, dynamic> book)
      : this(
          title: book['title']! as String,
          content: book['content']! as String,
          genre: book['genre'] as String? ?? '',
          author: book['author'] as String? ?? '',
        );

  final String title;
  final String content;
  final String genre;
  final String author;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'genre': genre,
      'author': author,
    };
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'title':
        return title;
      case 'author':
        return author;
      case 'content':
        return content;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }
}
