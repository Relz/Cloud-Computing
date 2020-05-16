import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  const Tile({
    Key key,
    this.number,
    this.size,
    this.color,
    this.fontSize,
  }) : super(key: key);

  final int number;
  final Size size;
  final Color color;
  final double fontSize;

  @override
  State<StatefulWidget> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          widget.number == 0 ? '' : '${widget.number}',
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xff766c62),
          ),
        ),
      ),
    );
  }
}
