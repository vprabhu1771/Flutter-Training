class Image {
  String message;

  Image({
    required this.message
  });

  Image.fromJson(Map<String, dynamic> json):
        message = json['message'];
}