import 'package:flutter/material.dart';
import 'package:goban/data_classes/move.dart';
import 'package:goban/data_classes/position.dart';
import 'package:goban/enums/boardSize.dart';
import 'package:goban/enums/player.dart';
import 'package:goban/gobanController.dart';
import 'package:goban/themes/gobanTheme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Player player = Player.Black;
  String gobanTheme = 'default';
  BoardSize boardSize = BoardSize.Thirteen;

  GobanController gobanController;

  GobanTheme _getThemeFromString(String themeStr) {
    GobanTheme theme = GobanTheme.defaultTheme();

    if (themeStr == 'book') {
      theme = GobanTheme.bookTheme();
    } else if (themeStr == 'jade') {
      theme = GobanTheme.jadeTheme();
    }

    return theme;
  }

  @override
  void initState() {
    gobanController = GobanController(
        boardSize: boardSize, gobanTheme: _getThemeFromString(gobanTheme));

    gobanController.gobanStream.stream.listen((Position pos) {
      var clickedPlayer = gobanController.getPlayerFromPosition(pos);
      if (clickedPlayer == Player.Empty) {
        var move = Move(player, pos);

        gobanController.addMove(move);

        setState(() {
          player = player == Player.Black ? Player.White : Player.Black;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        gobanController.goban,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Theme:',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: DropdownButton<String>(
                value: gobanTheme,
                onChanged: (String theme) => setState(() {
                  gobanTheme = theme;
                  gobanController.setTheme(_getThemeFromString(gobanTheme));
                }),
                items: const [
                  DropdownMenuItem(
                    child: Text('Default'),
                    value: 'default',
                  ),
                  DropdownMenuItem(
                    child: Text('Book'),
                    value: 'book',
                  ),
                  DropdownMenuItem(
                    child: Text('Jade'),
                    value: 'jade',
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Size:',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: DropdownButton<BoardSize>(
                value: boardSize,
                onChanged: (BoardSize size) => setState(() {
                  boardSize = size;
                  gobanController.setSize(boardSize);
                }),
                items: const [
                  DropdownMenuItem(
                    child: Text('9x9'),
                    value: BoardSize.Nine,
                  ),
                  DropdownMenuItem(
                    child: Text('13x13'),
                    value: BoardSize.Thirteen,
                  ),
                  DropdownMenuItem(
                    child: Text('19x19'),
                    value: BoardSize.Nineteen,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }
}
