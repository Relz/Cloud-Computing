class Score {
  Score(this.value, [int timestamp]) {
    this.timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;
  }

  factory Score.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Score(json['value'] as int, json['timestamp'] as int);

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int value = 0;
}
