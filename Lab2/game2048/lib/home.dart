import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game.dart';
import 'high_scores_table.dart';
import 'overlay_message.dart';
import 'score.dart';
import 'score_container.dart';
import 'scores_repository.dart';
import 'tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _headerContainerHeight = 8.0 * 8;
  static const Color _gridBackground = Color(0xffa2917d);
  static const Color _transparentWhite = Color(0x80ffffff);
  static const BorderRadius _containerBorderRadius =
      BorderRadius.all(Radius.circular(8.0 * 2));

  static const Map<int, Color> _colorMap = <int, Color>{
    0: Color(0xffbfafa0),
    2: Color(0xffeee4da),
    4: Color(0xfff5b27e),
    8: Color(0xfff77b5f),
    16: Color(0xffecc402),
    32: Color(0xffeee4da),
    64: Color(0xfff5b27e),
    128: Color(0xfff77b5f),
    256: Color(0xffecc402),
    512: Color(0xfff5b27e),
    1024: Color(0xffecc402),
    2048: Color(0xff60d992),
  };

  Game _game;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _initGame();
    super.initState();
  }

  void _initGame() {
    _game = Game()..addNumber()..addNumber();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);

    final Size availableSize = MediaQuery.of(context).size;

    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      title: const Text(
        '2048',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      backgroundColor: _gridBackground,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext builderContext) => AlertDialog(
                title: const Text('Hight Scores table'),
                content: FutureBuilder<Iterable<Score>>(
                  future: ScoresRepository.instance().scores,
                  builder: (BuildContext _,
                      AsyncSnapshot<Iterable<Score>> snapshot) {
                    final List<Score> scores =
                        snapshot.hasData ? snapshot.data.toList() : <Score>[];
                    if (snapshot.hasData) {
                      scores.sort(
                          (Score a, Score b) => b.value.compareTo(a.value));
                    }
                    return snapshot.hasData
                        ? HighScoresTable(scores: scores)
                        : const SizedBox(
                            width: 8.0 * 10,
                            height: 8.0 * 10,
                            child: Center(child: CircularProgressIndicator()),
                          );
                  },
                ),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  )
                ],
              ),
            );
          },
          child: const Text(
            'High Scores table',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    final double appBarHeight = appBar.preferredSize.height;
    const double spacing = 8.0 * 2;

    final Size gridAvailableSize = Size(
      availableSize.width - spacing * 2,
      availableSize.height -
          _headerContainerHeight -
          appBarHeight -
          spacing * 4,
    );
    final Size gridSize =
        Size.square(min(gridAvailableSize.width, gridAvailableSize.height));

    final Size tileSize = Size(gridSize.width / 4, gridSize.height / 4);

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing,
          horizontal: (gridAvailableSize.width - gridSize.width) / 2 + spacing,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: spacing),
            SizedBox(
              height: _headerContainerHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: _containerBorderRadius,
                      color: _gridBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        iconSize: 8.0 * 4,
                        icon: Icon(Icons.refresh, color: Colors.white70),
                        onPressed: () => setState(_initGame),
                      ),
                    ),
                  ),
                  ScoreContainer(
                    label: 'Score',
                    score: Future<int>.value(_game.score),
                    backgroundColor: _gridBackground,
                    borderRadius: _containerBorderRadius,
                  ),
                  ScoreContainer(
                    label: 'High Score',
                    score: _game.highScore,
                    backgroundColor: _gridBackground,
                    borderRadius: _containerBorderRadius,
                  ),
                ],
              ),
            ),
            const SizedBox(height: spacing),
            Container(
              height: gridSize.height,
              color: _gridBackground,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RawKeyboardListener(
                      focusNode: _focusNode,
                      onKey: (RawKeyEvent event) {
                        if (event.runtimeType != RawKeyDownEvent ||
                            _game.isGameOver) {
                          return;
                        }
                        final LogicalKeyboardKey logicalKeyboardKey =
                            event.data.logicalKey;
                        if (logicalKeyboardKey == LogicalKeyboardKey.arrowUp) {
                          setState(_game.stepUp);
                        } else if (logicalKeyboardKey ==
                            LogicalKeyboardKey.arrowRight) {
                          setState(_game.stepRight);
                        } else if (logicalKeyboardKey ==
                            LogicalKeyboardKey.arrowDown) {
                          setState(_game.stepDown);
                        } else if (logicalKeyboardKey ==
                            LogicalKeyboardKey.arrowLeft) {
                          setState(_game.stepLeft);
                        }
                      },
                      child: GestureDetector(
                        onVerticalDragEnd: (DragEndDetails details) {
                          if (_game.isGameOver) {
                            return;
                          }
                          if (details.primaryVelocity < 0) {
                            setState(_game.stepUp);
                          } else if (details.primaryVelocity > 0) {
                            setState(_game.stepDown);
                          }
                        },
                        onHorizontalDragEnd: (DragEndDetails details) {
                          if (details.primaryVelocity > 0) {
                            setState(_game.stepRight);
                          } else if (details.primaryVelocity < 0) {
                            _game.stepLeft();
                            setState(_game.stepLeft);
                          }
                        },
                        child: GridView.count(
                          primary: false,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          crossAxisCount: 4,
                          children: _createGridChildren(tileSize),
                        ),
                      ),
                    ),
                  ),
                  if (_game.isGameOver)
                    const OverlayMessage(
                      message: 'Game over!',
                      backgroundColor: _transparentWhite,
                      textColor: _gridBackground,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _createGridChildren(Size tileSize) {
    final List<Widget> grids = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        final int number = _game.getCellValue(i, j);
        final double size = number < 100 ? 40 : number < 1000 ? 30 : 20;
        grids.add(
          Tile(
            number: number,
            size: tileSize,
            color: _colorMap[number],
            fontSize: size,
          ),
        );
      }
    }
    return grids;
  }
}
