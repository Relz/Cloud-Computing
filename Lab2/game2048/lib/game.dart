import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'matrix4_extensions.dart';
import 'score.dart';
import 'scores_repository.dart';

class Game {
  final Matrix4 _matrix = Matrix4.zero();

  int _score = 0;
  int get score => _score;

  int getCellValue(int rowIndex, int columnIndex) =>
      _matrix.entry(rowIndex, columnIndex).toInt();

  Future<int> get highScore async => <Score>[
        ...await ScoresRepository.instance().scores,
        Score(0)
      ].reduce((Score a, Score b) => a.value > b.value ? a : b).value;

  void stepUp() {
    _matrix.transpose();

    _step();

    _matrix.transpose();
  }

  void stepRight() {
    _matrix.flip();

    _step();

    _matrix.flip();
  }

  void stepDown() {
    _matrix
      ..transpose()
      ..flip();

    _step();

    _matrix
      ..flip()
      ..transpose();
  }

  void stepLeft() {
    _step();
  }

  void addNumber() {
    final List<Point<int>> emptyCellPoints = _getEmptyCellPoints();
    if (emptyCellPoints.isNotEmpty) {
      final int spotRandomIndex = Random().nextInt(emptyCellPoints.length);
      final Point<int> point = emptyCellPoints[spotRandomIndex];
      _matrix.setEntry(point.y, point.x, Random().nextBool() ? 2 : 4);
    }
  }

  bool get isGameOver {
    if (_matrix.storage.any((double cellValue) => cellValue == 0)) {
      return false;
    }
    for (int rowIndex = 0; rowIndex < _matrix.dimension; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < _matrix.dimension;
          columnIndex++) {
        final int cellValue = getCellValue(rowIndex, columnIndex);
        if ((columnIndex != _matrix.dimension - 1 &&
                cellValue == getCellValue(rowIndex, columnIndex + 1)) ||
            (rowIndex != _matrix.dimension - 1 &&
                cellValue == getCellValue(rowIndex + 1, columnIndex))) {
          return false;
        }
      }
    }
    return true;
  }

  void _step() {
    final Matrix4 matrixBeforeStep = _matrix.clone();

    for (int rowIndex = 0; rowIndex < _matrix.dimension; rowIndex++) {
      _matrix.setRow(rowIndex, _operateRow(_matrix.getRow(rowIndex)));
    }

    if (matrixBeforeStep != _matrix) {
      addNumber();
    }

    if (isGameOver) {
      ScoresRepository.instance().add(Score(score));
    }
  }

  List<Point<int>> _getEmptyCellPoints() {
    final List<Point<int>> result = <Point<int>>[];
    for (int rowIndex = 0; rowIndex < _matrix.dimension; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < _matrix.dimension;
          columnIndex++) {
        if (_matrix.entry(rowIndex, columnIndex) == 0) {
          result.add(Point<int>(columnIndex, rowIndex));
        }
      }
    }
    return result;
  }

  Vector4 _operateRow(Vector4 row) => _slide(_combine(_slide(row)));

  Vector4 _slide(Vector4 row) {
    final List<double> rowWithoutZeros =
        row.storage.where((double value) => value != 0).toList();
    final List<double> zeroes =
        List<double>.filled(_matrix.dimension - rowWithoutZeros.length, 0);
    return Vector4.array(rowWithoutZeros + zeroes);
  }

  Vector4 _combine(Vector4 row) {
    final Vector4 result = row.clone();
    for (int i = 0; i < _matrix.dimension - 1; i++) {
      final double a = result[i];
      final double b = result[i + 1];
      if (a == b) {
        result[i] = a + b;
        result[i + 1] = 0;

        _score += result[i].toInt();
      }
    }
    return result;
  }
}
