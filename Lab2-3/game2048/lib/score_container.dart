import 'package:flutter/material.dart';

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({
    Key key,
    this.label,
    this.score,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  final String label;
  final Future<int> score;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FutureBuilder<int>(
                future: score,
                builder: (
                  _,
                  AsyncSnapshot<int> snapshot,
                ) =>
                    Text(
                  snapshot.hasData ? '${snapshot.data}' : '0',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
