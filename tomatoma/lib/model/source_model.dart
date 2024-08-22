class Source {
  dynamic name;

  Source({ required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      name: json['name'] as String,
    );
  }
}
