class MyOrder{

  String id;
  String name;
  String phone;
  String address;
  double latitude;
  double longitude;
  double amount;

  MyOrder({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.amount
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      address: json["address"],
      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      amount: json["amount"]?.toDouble()
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "amount": amount
  };

}