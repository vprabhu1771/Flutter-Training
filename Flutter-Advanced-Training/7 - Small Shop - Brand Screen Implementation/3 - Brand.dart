class Brand {
  int id;
  String name;

  Brand({
    required this.id,
    required this.name,
  });

  Brand.fromJson(Map<String, dynamic> json)
      :
        id = json['id'],
        name = json['name'];
}