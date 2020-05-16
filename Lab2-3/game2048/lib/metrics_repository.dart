import 'dart:convert';
import 'package:http/http.dart' as http;

class MetricsRepository {
  MetricsRepository._();

  factory MetricsRepository.instance() => _instance ??= MetricsRepository._();

  // static const String _host = 'http://localhost:4242';
  static const String _host =
      'http://ec2-18-185-71-205.eu-central-1.compute.amazonaws.com:4242';

  static MetricsRepository _instance;

  Future<int> get visitCount async => _fetchVisitCount();

  Future<void> addVisit() async {
    await http.put(
      '$_host/visit',
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      ),
    );
  }

  Future<int> _fetchVisitCount() async {
    final http.Response response = await http.get('$_host/visit_count');
    return response.statusCode == 200 ? int.parse(response.body) : 0;
  }
}
