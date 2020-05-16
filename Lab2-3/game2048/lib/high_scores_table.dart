import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'score.dart';

class HighScoresTable extends StatelessWidget {
  const HighScoresTable({Key key, this.scores}) : super(key: key);

  final List<Score> scores;

  @override
  Widget build(BuildContext context) => DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('DateTime')),
          DataColumn(label: Text('Score'))
        ],
        rows: scores
            .map((Score score) => DataRow(cells: <DataCell>[
                  DataCell(
                    Text(
                      DateFormat.yMMMMd().add_Hms().format(
                            DateTime.fromMillisecondsSinceEpoch(
                              score.timestamp,
                            ),
                          ),
                    ),
                  ),
                  DataCell(Text('${score.value}')),
                ]))
            .toList(),
      );
}
