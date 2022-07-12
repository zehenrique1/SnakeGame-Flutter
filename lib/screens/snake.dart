import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  // Variables
  final int squaresPerRow = 20;
  final int squaresPerCol = 30;
  TextStyle fontStyle = const TextStyle(color: Colors.white, fontSize: 20);
  List snake = [[0, 1], [0, 0]];
  List food = [0, 2];
  String direction = 'up';
  bool isPlaying = false;
  var randomGen = Random();


  // Function to start the game
  void startGame() {
    const duration = Duration(milliseconds: 250
    );
    snake = [
      [(squaresPerRow / 2).floor(), (squaresPerCol / 2).floor()]
    ];
    snake.add([snake.first[0], snake.first[1] - 1]);

    createFood();
    isPlaying = true;
    Timer.periodic(duration, (Timer timer) {
      moveSnake();
      if (checkGameOver()) {
        timer.cancel();
        endGame();
      }
    });
  }

  // Function to Game over
  bool checkGameOver() {
    if (!isPlaying ||
        snake.first[1] < 0 ||
        snake.first[1] >= squaresPerCol ||
        snake.first[0] < 0 ||
        snake.first[0] > squaresPerRow) {
      return true;
    }
    for (var i = 1; i < snake.length; ++i) {
      if (snake[i][0] == snake.first[0] && snake[i][1] == snake.first[1]) {
        return true;
      }
    }
    return false;
  }

  // Function to end the game
  void endGame() {
    isPlaying = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over!!'),
          content: Text(
            'Score: ${snake.length - 2}',
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to move the snake
  void moveSnake() {
    setState(() {
      switch (direction) {
        case 'up':
          snake.insert(0, [snake.first[0], snake.first[1] - 1]);
          break;
        case 'down':
          snake.insert(0, [snake.first[0], snake.first[1] + 1]);
          break;
        case 'left':
          snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
          break;
        case 'right':
          snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
          break;
      }
      if (snake.first[0] != food[0] || snake.first[1] != food[1]) {
        snake.removeLast();
      } else {
        createFood();
      }
    });
  }

  // Function to create a food
  void createFood() {
    food = [randomGen.nextInt(squaresPerRow), randomGen.nextInt(squaresPerCol)];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          snakeSpace(),
          bottomScreen()
        ],
      ),
    );
  }

  // All space to move the snake
  Widget snakeSpace() => Expanded(
    child: GestureDetector(
      onVerticalDragUpdate: (details){
        if(direction != 'up' && details.delta.dy > 0){
          direction = 'down';
        }else if(direction != 'down' && details.delta.dy < 0){
          direction = 'up';
        }
      },
      onHorizontalDragUpdate: (details){
        if(direction != 'left' && details.delta.dx > 0){
          direction = 'right';
        }else if(direction != 'right' && details.delta.dx < 0){
          direction = 'left';
        }
      },
      child: AspectRatio(
        aspectRatio: squaresPerRow / (squaresPerCol + 2),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: squaresPerRow,
          ),
          itemCount: squaresPerRow * squaresPerCol,
          itemBuilder: (BuildContext context, int index) {
            late var color;
            var x = index % squaresPerRow;
            var y = (index / squaresPerRow).floor();

            bool isSnakeBody = false;
            for (var pos in snake) {
              if (pos[0] == x && pos[1] == y) {
                isSnakeBody = true;
                break;
              }
            }

            if (snake.first[0] == x && snake.first[1] == y) {
              color = Colors.green;
            } else if (isSnakeBody) {
              color = Colors.green[200];
            } else if (food[0] == x && food[1] == y) {
              color = Colors.red;
            } else {
              color = Colors.grey[800];
            }

            return Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    ),
  );

  // Score and start the game
  Widget bottomScreen() => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: isPlaying
                  ? MaterialStateProperty.all(Colors.red)
                  : MaterialStateProperty.all(Colors.blue)),
          child: Text(
            isPlaying ? 'End' : 'Start',
            style: fontStyle,
          ),
          onPressed: () {
            if (isPlaying) {
              isPlaying = false;
            } else {
              startGame();
            }
          },
        ),
        Text(
          'Score: ${snake.length - 2}',
          style: fontStyle,
        )
      ],
    ),
  );
}
