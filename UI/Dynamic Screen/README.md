`lib/utils/Constants.dart`

```dart
class Constants {

  static const String SERVER_DOMAIN= "https://127.0.0.1:8000";

  static const String BASE_URL = SERVER_DOMAIN + "/api";

  static const String HOME_ROUTE = "/home";
}
```

`lib/models/HomeResponse.dart`

```dart
import 'HomeBanner.dart';
import 'Ticker.dart';

class HomeResponse {
  final String logo;
  final String app_name;
  final String credit_meter;
  final String crif;

  // My Files
  final int pipeline;
  final int pending;
  final int logged_in;
  final int disbursed;

  // My Earnings
  final double expected_payout;
  final double ready_for_invoice;
  final double awaited_payment;
  final double payment_received;

  final double amount;
  final List<HomeBanner> banners;
  final List<Ticker> bazaarTicker;

  HomeResponse({
    required this.logo,
    required this.app_name,
    required this.credit_meter,
    required this.crif,

    // My Files
    required this.pipeline,
    required this.pending,
    required this.logged_in,
    required this.disbursed,

    // My Earnings
    required this.expected_payout,
    required this.ready_for_invoice,
    required this.awaited_payment,
    required this.payment_received,

    required this.amount,
    required this.banners,
    required this.bazaarTicker,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      logo: json['logo'],
      app_name: json['app_name'],
      credit_meter: json['credit_meter'],
      crif: json['crif'],

      // My Files
      pipeline: json['pipeline'],
      pending: json['pending'],
      logged_in: json['logged_in'],
      disbursed: json['disbursed'],

      // My Earnings
      expected_payout: (json['expected_payout'] as num).toDouble(),
      ready_for_invoice: (json['ready_for_invoice']  as num).toDouble(),
      awaited_payment: (json['awaited_payment']  as num).toDouble(),
      payment_received: (json['payment_received']  as num).toDouble(),

      // amount: json['amount'],
      amount: (json['amount'] as num).toDouble(),
      banners: (json['banners'] as List)
          .map((e) => HomeBanner.fromJson(e))
          .toList(),

      // ✅ BAZAAR TICKER
      bazaarTicker: (json['bazaar_ticker'] as List)
          .map((e) => Ticker.fromJson(e))
          .toList(),
    );
  }
}
```

`lib/services/HomeService.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/HomeResponse.dart';
import '../utils/Constants.dart';

class HomeService {
  static const String apiUrl = Constants.BASE_URL + Constants.HOME_ROUTE;

  static const String _tokenKey = 'auth_token';

  /// Load token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Auth headers
  static Future<Map<String, String>> authHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<HomeResponse> fetchHome() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: await authHeaders(),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return HomeResponse.fromJson(body['data']);
    } else {
      throw Exception('Home API failed');
    }
  }
}
```

`lib/screens/HomeScreen.dart`