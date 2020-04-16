import 'package:vector_math/vector_math_64.dart';

extension Matrix4Extensions on Matrix4 {
  void flip() {
    for (int i = 0; i < dimension; i++) {
      setRow(i, getRow(i).wzyx);
    }
  }
}
