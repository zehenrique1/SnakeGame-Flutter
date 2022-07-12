import 'package:flutter/material.dart';
import 'screens/snake.dart';

// Run project
void main() => runApp(const MyApp());


//Material App
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: SnakeGame(),
        debugShowCheckedModeBanner: false,
      );
}
