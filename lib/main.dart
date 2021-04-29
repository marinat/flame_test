import 'package:flame/game/game.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  final manager = DefaultCacheManager();
  //await flameUtil.fullScreen();
  final file = await manager.getSingleFile(
      "https://backendlessappcontent.com/A27D7568-B7AD-DC84-FFE6-1DE40A40E500/199CC629-9F69-48FF-8F4B-7D1F3AB353FF/files/games/balloon_final_1.json");
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  var bytes = file.readAsBytesSync();
  final composition =
  await LottieComposition.fromByteData(ByteData.view(bytes.buffer));
  List<Offset> paintPositions = List();
  BoxGame game = BoxGame(composition, paintPositions);
  //runApp(game.widget);

  runApp(MyApp(
    paintPositions: paintPositions,
    game: game,
  ));
}

class BoxGame extends Game {
  Size screenSize;
  final LottieComposition composition;
  final LottieDrawable drawable;
  final frameCount = 40.0;
  final List<Offset> paintPositions;
  double currentFrame = 0;
  final StrokeCap _strokeCap = StrokeCap.round;

  BoxGame(this.composition, this.paintPositions)
      : drawable = LottieDrawable(composition);

  void render(Canvas canvas) {
    // Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    // Paint bgPaint = Paint();
    // bgPaint.color = Colors.red;
    // canvas.drawRect(bgRect, bgPaint);
    //canvas.drawColor(Colors.green, BlendMode.overlay);
    // var frameCount = 40;
    // var columns = 10;
    // for (var i = 0; i < frameCount; i++) {
    //   var destRect =
    //       Offset(i % columns * 50.0, i ~/ 10 * 80.0) & (screenSize / 5);
    //   drawable
    //     ..setProgress(i / frameCount)
    //     ..draw(canvas, destRect);
    // }
    drawable..draw(canvas, Offset(100.0, 50.0) & (screenSize));
    double screenCenterX = screenSize.width / 2;
    double screenCenterY = screenSize.height / 2;
    Rect boxRect =
    Rect.fromLTWH(screenCenterX - 75, screenCenterY - 75, 150, 150);
    Paint boxPaint = Paint();
    boxPaint.color = Colors.red;
    canvas.drawRect(boxRect, boxPaint);

    final linePaint = Paint();
    linePaint.color = Colors.red;
    linePaint.strokeCap = _strokeCap;
    linePaint.strokeWidth = 2;
    for (var i = 0; i < paintPositions.length - 1; i++) {
      final from = paintPositions[i];
      final to = paintPositions[i + 1];
      canvas.drawLine(
          Offset(from.dx, from.dy), Offset(to.dx, to.dy), linePaint);
    }
  }

  void update(double t) {
    if (currentFrame < frameCount)
      currentFrame++;
    else
      currentFrame = 0;
    drawable.setProgress(currentFrame / frameCount);
    //print('update' + t.toString());
  }

  @override
  void resize(Size size) {
    // TODO: implement resize
    screenSize = size;
    super.resize(size);
  }
}

class MyApp extends StatelessWidget {
  final Game game;
  final List<Offset> paintPositions;

  const MyApp({Key key, this.game, this.paintPositions}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          print('drag ' + details.toString());
          final RenderBox object = context.findRenderObject();
          final localPosition = object.globalToLocal(details.globalPosition);
          paintPositions.add(localPosition);
        },
        onPanEnd: (DragEndDetails details) {
          print('drag end' + details.toString());
        },
        child: MyHomePage(
          title: 'Flutter Demo Home Page',
          game: game,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Game game;

  MyHomePage({Key key, this.title, this.game}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        // width: MediaQuery.of(context).size.width / 2,
        // height: MediaQuery.of(context).size.height / 2,
        color: Colors.greenAccent,
        child: Stack(
          children: [

            widget.game.widget,
            RaisedButton(onPressed: () {}, child: Text('button')),
            Center(
              child: Text('ok'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
