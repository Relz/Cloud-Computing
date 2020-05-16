import 'dart:convert';
import 'package:http/http.dart' as http;

import 'score.dart';

class ScoresRepository {
  ScoresRepository._();

  factory ScoresRepository.instance() => _instance ??= ScoresRepository._();

  // static const String _host = 'http://localhost:4242';
  static const String _host =
      'http://ec2-18-185-71-205.eu-central-1.compute.amazonaws.com:4242';

  static ScoresRepository _instance;

  Future<Iterable<Score>> get scores async => _fetchScores();

  Future<void> add(Score score) async {
    await http.put(
      '$_host/score',
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          'timestamp': score.timestamp,
          'value': score.value,
        },
      ),
    );
  }

  Future<Iterable<Score>> _fetchScores() async {
    final http.Response response = await http.get('$_host/scores');
    return response.statusCode == 200
        ? _deserializeScores(response.body)
        : <Score>[];
  }

  static Iterable<Score> _deserializeScores(String data) =>
      _asIterable<Map<String, dynamic>>(jsonDecode(data))
          .map(_createScoreFromJson);

  static Score _createScoreFromJson(Map<String, dynamic> json) =>
      Score.fromJson(json);

  static Iterable<T> _asIterable<T>(dynamic data) =>
      // ignore:avoid_as
      data.cast<T>() as Iterable<T>;
}
