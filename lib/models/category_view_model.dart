class Category {
  final String name;
  final String created;

  Category({
    this.name,
    this.created
  });

  Category.fromJson(Map json)
      : name = json['name'],
        created = json['created'];
}