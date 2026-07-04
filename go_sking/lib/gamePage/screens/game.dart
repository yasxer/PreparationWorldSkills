import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.PlayerName,
    this.jacketColor = Colors.blue,
  });

  // اسم اللاعب جاي من Home Page
  final String PlayerName;

  // لون الجاكيت جاي من Setting Page
  final Color jacketColor;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // -----------------------------
  // VARIABLES PRINCIPALES
  // -----------------------------

  // عدد coins يبدأ بـ 10 كما هو مطلوب
  int coins = 10;

  // المدة الزمنية للعبة، تزيد كل ثانية
  int duration = 0;

  // حالات اللعبة
  bool isPaused = false;
  bool isGameOver = false;
  bool isJumping = false;
  bool isInvincible = false;

  // متغير خاص بالقفزة
  double jumpHeight = 0;

  // زاوية الميلان تاع الثلج
  double slopeAngle = -0.18;

  // سرعة العالم (الأشجار / obstacle / coins)
  double worldSpeed = 6.0;

  // السرعة الأصلية باش نرجعولها بعد التسريع
  double normalSpeed = 6.0;

  // إحداثي X تاع الأشجار في الخلفية باش يديرو loop
  double treeOffset1 = 0;
  double treeOffset2 = 400;

  // حجم اللاعب
  final double skierWidth = 60;
  final double skierHeight = 60;

  // position ثابتة للاعب في الوسط تقريبًا
  double skierX = 140;
  double skierY = 120;

  // لائحة obstacles
  List<Map<String, dynamic>> obstacles = [];

  // لائحة coins objects
  List<Map<String, dynamic>> gameCoins = [];

  // Random لتوليد obstacle/coins
  final Random random = Random();

  // Timers
  Timer? gameLoopTimer;
  Timer? durationTimer;
  Timer? obstacleSpawnTimer;
  Timer? coinSpawnTimer;
  Timer? jumpTimer;
  Timer? invincibleTimer;
  Timer? holdConsumeTimer;
  Timer? boostTimer;

  @override
  void initState() {
    super.initState();
    // نبدأ اللعبة أول ما الصفحة تتحل
    startGame();
  }

  // -----------------------------
  // START / RESET GAME
  // -----------------------------
  void startGame() {
    // نوقف أي timers قدام
    cancelAllTimers();

    // نرجع كل شيء للحالة الابتدائية
    setState(() {
      coins = 10;
      duration = 0;
      isPaused = false;
      isGameOver = false;
      isJumping = false;
      isInvincible = false;

      jumpHeight = 0;
      slopeAngle = -0.18;
      worldSpeed = 6.0;
      normalSpeed = 6.0;

      treeOffset1 = 0;
      treeOffset2 = 400;

      obstacles.clear();
      gameCoins.clear();
    });

    // timer يزيد duration كل ثانية
    durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPaused || isGameOver) return;

      setState(() {
        duration++;
      });
    });

    // game loop رئيسي: يحرك العالم ويشيك collisions
    gameLoopTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (isPaused || isGameOver) return;

      updateWorld();
      checkCollisions();
    });

    // توليد obstacles من حين لآخر
    obstacleSpawnTimer =
        Timer.periodic(const Duration(milliseconds: 1800), (timer) {
          if (isPaused || isGameOver) return;
          spawnObstacle();
        });

    // توليد collectible coins من حين لآخر
    coinSpawnTimer =
        Timer.periodic(const Duration(milliseconds: 1400), (timer) {
          if (isPaused || isGameOver) return;
          spawnCoin();
        });

    // هنا في المشروع الحقيقي:
    // - تشعل bgm.mp3
    // - تدير vibration
    // - تبدا screen recording
    // هذا مطلوب في الـ PDF [file:1]
  }

  // -----------------------------
  // CANCEL TIMERS
  // -----------------------------
  void cancelAllTimers() {
    gameLoopTimer?.cancel();
    durationTimer?.cancel();
    obstacleSpawnTimer?.cancel();
    coinSpawnTimer?.cancel();
    jumpTimer?.cancel();
    invincibleTimer?.cancel();
    holdConsumeTimer?.cancel();
    boostTimer?.cancel();
  }

  // -----------------------------
  // UPDATE WORLD
  // -----------------------------
  void updateWorld() {
    setState(() {
      // نحرك الأشجار لليسار
      treeOffset1 -= worldSpeed;
      treeOffset2 -= worldSpeed;

      // loop effect للأشجار
      if (treeOffset1 < -400) {
        treeOffset1 = treeOffset2 + 400;
      }
      if (treeOffset2 < -400) {
        treeOffset2 = treeOffset1 + 400;
      }

      // نحرك obstacles لليسار
      for (var obstacle in obstacles) {
        obstacle['x'] -= worldSpeed;
      }

      // نحرك coins لليسار
      for (var coin in gameCoins) {
        coin['x'] -= worldSpeed;
      }

      // نحذف أي obstacle خرج من الشاشة
      obstacles.removeWhere((obstacle) => obstacle['x'] < -60);

      // نحذف أي coin خرج من الشاشة
      gameCoins.removeWhere((coin) => coin['x'] < -40);
    });
  }

  // -----------------------------
  // SPAWN OBSTACLE
  // -----------------------------
  void spawnObstacle() {
    // obstacle يبان من اليمين ويمشي لليسار كما هو مطلوب [file:1]
    final obstacleX = MediaQuery.of(context).size.width + random.nextInt(120);

    obstacles.add({
      'x': obstacleX.toDouble(),
      'y': 95.0, // قريب من الأرض
      'width': 40.0,
      'height': 45.0,
    });
  }

  // -----------------------------
  // SPAWN COIN
  // -----------------------------
  void spawnCoin() {
    final coinX = MediaQuery.of(context).size.width + random.nextInt(140);

    // نحاول ما نخليوش coin يخرج فوق obstacle مباشرة
    bool overlapsObstacle = obstacles.any((obstacle) {
      return (coinX - obstacle['x']).abs() < 50;
    });

    if (overlapsObstacle) return;

    gameCoins.add({
      'x': coinX.toDouble(),
      'y': 120.0,
      'size': 24.0,
    });
  }

  // -----------------------------
  // JUMP
  // -----------------------------
  void jump() {
    // إذا اللعبة pause أو game over أو اللاعب راهو يقفز، ما نديروش jump جديد
    if (isPaused || isGameOver || isJumping) return;

    // هنا في المشروع الحقيقي تشغل jump.wav [file:1]

    isJumping = true;

    // الجزء الأول من القفزة: نطلع
    setState(() {
      jumpHeight = 90;
    });

    // بعد شوية نهبط
    jumpTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        jumpHeight = 0;
      });

      // بعد ما يكمل الهبوط نرجع isJumping false
      Timer(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        setState(() {
          isJumping = false;
        });
      });
    });
  }

  // -----------------------------
  // INVINCIBILITY MODE
  // -----------------------------
  void startInvincibility() {
    // ما نقدرش نفعلها إذا pause/game over أو ماكانش coins
    if (isPaused || isGameOver || coins <= 0) return;

    setState(() {
      isInvincible = true;
      coins--; // أول coin يتستهلك مباشرة
    });

    // بعد 1 ثانية إذا المستخدم مازال ضاغط، يبقى يستهلك
    holdConsumeTimer?.cancel();
    holdConsumeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (isPaused || isGameOver || coins <= 0) {
        stopInvincibility();
        return;
      }

      setState(() {
        coins--;
      });

      if (coins <= 0) {
        stopInvincibility();
      }
    });

    // هذا timer شكلي باش يطبق requirement تاع 1 ثانية invincible
    invincibleTimer?.cancel();
    invincibleTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!isInvincible) {
        timer.cancel();
      }
    });
  }

  void stopInvincibility() {
    holdConsumeTimer?.cancel();
    invincibleTimer?.cancel();

    if (!mounted) return;

    setState(() {
      isInvincible = false;
    });
  }

  // -----------------------------
  // PAUSE / PLAY
  // -----------------------------
  void togglePause() {
    if (isGameOver) return;

    setState(() {
      isPaused = !isPaused;
    });

    // في التطبيق الحقيقي:
    // pause => توقف bgm
    // play => تكمل bgm
    // هذا مطلوب في الـ PDF [file:1]
  }

  // -----------------------------
  // BOOST BY SWIPE DOWN
  // -----------------------------
  void speedBoost() {
    if (isPaused || isGameOver) return;

    setState(() {
      worldSpeed = 12.0;
    });

    boostTimer?.cancel();
    boostTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        worldSpeed = normalSpeed;
      });
    });
  }

  // -----------------------------
  // COLLISION DETECTION
  // -----------------------------
  void checkCollisions() {
    // rectangle اللاعب
    final skierRect = Rect.fromLTWH(
      skierX,
      MediaQuery.of(context).size.height - 190 - jumpHeight,
      skierWidth,
      skierHeight,
    );

    // collision مع obstacles
    for (final obstacle in obstacles) {
      final obstacleRect = Rect.fromLTWH(
        obstacle['x'],
        MediaQuery.of(context).size.height - 150,
        obstacle['width'],
        obstacle['height'],
      );

      if (skierRect.overlaps(obstacleRect)) {
        // إذا اللاعب invincible يمر عادي
        if (isInvincible) {
          continue;
        }

        gameOver();
        return;
      }
    }

    // collision مع coins
    for (int i = gameCoins.length - 1; i >= 0; i--) {
      final coin = gameCoins[i];

      final coinRect = Rect.fromLTWH(
        coin['x'],
        MediaQuery.of(context).size.height - 165,
        coin['size'],
        coin['size'],
      );

      if (skierRect.overlaps(coinRect)) {
        setState(() {
          coins++;
          gameCoins.removeAt(i);
        });

        // هنا في التطبيق الحقيقي تشغل coin.wav [file:1]
      }
    }
  }

  // -----------------------------
  // GAME OVER
  // -----------------------------
  void gameOver() {
    if (isGameOver) return;

    setState(() {
      isGameOver = true;
      isPaused = true;
    });

    // في التطبيق الحقيقي:
    // - تشغل gameover.wav
    // - vibration
    // - توقف screen recording وتحفظ الفيديو
    // هذا كله مطلوب [file:1]

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Player: ${widget.PlayerName}'),
              Text('Coins: $coins'),
              Text('Duration: $duration s'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startGame();
              },
              child: const Text('Restart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                // بدلها بالـ route تاعك
                Navigator.pushNamed(
                  context,
                  '/rankings',
                  arguments: {
                    'latestPlayer': widget.PlayerName,
                    'latestCoins': coins,
                    'latestDuration': duration,
                  },
                );
              },
              child: const Text('Go To Rankings'),
            ),
          ],
        );
      },
    );
  }

  // -----------------------------
  // CONFIRM QUIT
  // -----------------------------
  Future<void> confirmQuit() async {
    if (isGameOver) return;

    final wasPausedBeforeDialog = isPaused;

    setState(() {
      isPaused = true;
    });

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'The game is in progress. Are you sure to quit?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (result == true) {
      Navigator.pop(context);
    } else {
      setState(() {
        isPaused = wasPausedBeforeDialog;
      });
    }
  }

  @override
  void dispose() {
    cancelAllTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // نحسب position اللاعب في الوسط
    skierX = (screenWidth / 2) - (skierWidth / 2);

    return Scaffold(
      body: GestureDetector(
        // tap في أي مكان = jump
        onTap: jump,

        // long press = invincibility mode
        onLongPressStart: (_) => startInvincibility(),
        onLongPressEnd: (_) => stopInvincibility(),

        // swipe down = تسريع مؤقت
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 300) {
            speedBoost();
          }
        },

        // swipe left to right = confirmation quit
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 300) {
            confirmQuit();
          }
        },

        child: SafeArea(
          child: Stack(
            children: [
              // -----------------------------
              // BACKGROUND
              // -----------------------------
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF90CAF9),
                        Color(0xFFEAF6FF),
                      ],
                    ),
                  ),
                ),
              ),

              // -----------------------------
              // TREES LAYER 1
              // -----------------------------
              Positioned(
                left: treeOffset1,
                bottom: 170,
                child: Row(
                  children: List.generate(
                    6,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.park,
                        color: Colors.green.shade700,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------
              // TREES LAYER 2
              // -----------------------------
              Positioned(
                left: treeOffset2,
                bottom: 170,
                child: Row(
                  children: List.generate(
                    6,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.park,
                        color: Colors.green.shade500,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------
              // STATUS BOX TOP RIGHT
              // -----------------------------
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Player: ${widget.PlayerName}'),
                        const SizedBox(height: 4),
                        Text('Coins: $coins'),
                        const SizedBox(height: 4),
                        Text('Duration: $duration s'),
                      ],
                    ),
                  ),
                ),
              ),

              // -----------------------------
              // PAUSE / PLAY BUTTON
              // -----------------------------
              Positioned(
                top: 16,
                left: 16,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: togglePause,
                    icon: Icon(
                      isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // -----------------------------
              // SLOPE (WHITE SNOW)
              // -----------------------------
              Positioned(
                left: -40,
                right: -40,
                bottom: 0,
                child: Transform.rotate(
                  angle: slopeAngle,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 150,
                    color: Colors.white,
                  ),
                ),
              ),

              // -----------------------------
              // OBSTACLES
              // -----------------------------
              ...obstacles.map((obstacle) {
                return Positioned(
                  left: obstacle['x'],
                  bottom: obstacle['y'],
                  child: const Icon(
                    Icons.park,
                    size: 42,
                    color: Colors.brown,
                  ),
                );
              }),

              // -----------------------------
              // COLLECTIBLE COINS
              // -----------------------------
              ...gameCoins.map((coin) {
                return Positioned(
                  left: coin['x'],
                  bottom: coin['y'],
                  child: const Icon(
                    Icons.monetization_on,
                    size: 26,
                    color: Colors.amber,
                  ),
                );
              }),

              // -----------------------------
              // SKIER
              // -----------------------------
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: skierX,
                bottom: skierY + jumpHeight,
                child: Column(
                  children: [
                    // نعرض النص فقط إذا invincible mode مفعّل
                    if (isInvincible)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          'Invincibility Mode',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),

                    // اللاعب نفسه
                    Icon(
                      Icons.downhill_skiing,
                      size: 64,
                      // إذا invincible نخلي الجاكيت بالأسود كما مطلوب [file:1]
                      color: isInvincible ? Colors.black : widget.jacketColor,
                    ),
                  ],
                ),
              ),

              // -----------------------------
              // PAUSED OVERLAY
              // -----------------------------
              if (isPaused && !isGameOver)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Text(
                        'Paused',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              // -----------------------------
              // DEBUG BUTTON GAME OVER
              // -----------------------------
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: gameOver,
                  child: const Text('Test Game Over'),
                ),
              ),

              // -----------------------------
              // DEBUG INFO
              // -----------------------------
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.2),
                  child: Text(
                    'Speed: ${worldSpeed.toStringAsFixed(1)}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}