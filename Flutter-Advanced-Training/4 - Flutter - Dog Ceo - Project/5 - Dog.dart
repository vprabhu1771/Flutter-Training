class Dog {
  String message;
  String status;

  Dog({
    required this.message,
    required this.status,
  });

  Dog.fromJson(Map<String, dynamic> json)
      :
        message = json['message'],
        status = json['status'];
}