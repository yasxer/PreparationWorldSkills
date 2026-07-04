# Module A - AM ("Go Skiing") — Review & العفايس

> Skill 08 - Mobile Applications Development | WSC2024 TP08 MA (morning)
> Marking scheme: `WSC2024_08_Mobile_Applications_Development_marking_scheme.xlsx`
> Score دابا: **≈ 2.9 / 15.0 (~19%)**

هاد الملف كيلخص شنو ناقص فالمشروع (`daythree`) بالنسبة للـ marking scheme الرسمي، مرتب من الأسهل للأصعب باش تقدر تخدم عليه مرحلة بمرحلة.

---

## 1. Organisation / Instructions to the Competitor (2.8 pts — الأسهل، مجانية)

| العفص | الملف | التصحيح |
|---|---|---|
| الفولدر سميتو `daythree` بدل `XX_Module_A_AM` | root folder | سمي الفولدر بـ workstation code ديالك |
| `applicationId` مازال `com.example.daythree` | `android/app/build.gradle.kts:24` | بدلو لـ `edu.ws2024.aXX.am` |
| ماكاينش push للـ git | — | `git add . && git commit -m "..." && git push` بمجرد ما تسالا كل جزء |
| APK ماخداماش rename | — | بعد البناء، سمي الملف `XX_Module_A_AM.apk` وحطو فـ root ديال الفولدر |

**الدرس:** هاد النقط "مجانية" — ماخاصهمش مهارة برمجة، غير انضباط/تنظيم. ديرهم أول شي فأي جلسة تدريب.

---

## 2. General Demands (0.3 pt — ناقص 0.1)

- ✅ اسم التطبيق "Go Skiing" فـ `AndroidManifest.xml` — صحيح
- ✅ الأيقونة `@mipmap/go_skiing` — صحيح
- ❌ **ماكاينش verrouillage portrait** → زيد فـ `AndroidManifest.xml` جوج `<activity>`:
  ```xml
  android:screenOrientation="portrait"
  ```

---

## 3. Home Page (0.9 / 0.9 elements + functions)

- ✅ Elements كاملين (bg, text, input, 3 boutons) — full mark، برافو.
- ❌ **ماكاينش validation** ملي الاسم فارغ → خاص `AlertDialog` بـ "Invalid"
- ❌ **ماكاينش نص "No Ranking"** فـ Rankings page ملي القائمة فارغة
- ⚠️ الاسم ديال اللاعب ماكايتمررش لصفحة Game (hardcoded "Player name" فـ `game.dart:50`)

**Concept باش تتعلم:** `TextEditingController` + `showDialog` + تمرير data بين الصفحات عبر constructor (`Game({required this.playerName})`).

---

## 4. Game Page — أكبر جزء ناقص (≈ 5.9 / 5.9 pts خسرانين)

الملف: `lib/screens/game.dart` — دابا كايوري غير UI ستاتيكية (bg + slope مايل + status bar + toggle ديال pause icon). **الـ skier ماكاينش خالص فالكود.**

### عناصر ناقصين بالكامل:
1. **الـ skier** (widget/image) — ماكاين حتى تلميح ليه فـ `game.dart`
2. **الحركة** (animation loop) — الشجر (`trees.png`) ماخدامش، السلوب ستاتيك
3. **Jump mechanic** — `GestureDetector.onTap` باش السكير يقفز
4. **Timer حقيقي** — الوقت ("10 s") hardcoded، خاص `Timer.periodic`
5. **Coin counter حقيقي** — الرقم "10" hardcoded، خاص `setState` يبدلو
6. **Gyroscope** — خاص package `sensors_plus` باش تحس بميلان الهاتف
7. **صوت** — `bgm.mp3`, `jump.wav`, `coin.wav`, `game_over.wav` — خاص package `audioplayers`
8. **Vibration** — خاص package `vibration`
9. **Obstacle + Coin spawner** — عناصر كايطلعو من اليمين ويتحركو لليسار، بلا تداخل بينهم
10. **Collision detection** — تصادم السكير مع obstacle (game over) ولا coin (+1)
11. **Game Over dialog** — بالاسم/العملات/الوقت الصحيحين + زوج بوتونات (Restart / Go To Rankings)
12. **Swipe-to-quit confirmation** — swipe من اليسار لليمين → dialog "Are you sure to quit?"
13. **Invincibility mode** — long-press → يستهلك coin/ثانية، السكير يبان بلاصة سوداء

**الدرس:** هاد الجزء خاصو يتبنى بخطوات (state machine بسيط):
```
idle → playing → paused → gameOver
```
كل حالة عندها شنو يبان وشنو يخدم. ابدا بـ:
1. `StatefulWidget` مع `int coins`, `int duration`, `bool isPaused`, `bool isInvincible`
2. `Timer.periodic(Duration(seconds: 1))` يزيد الـ duration
3. `AnimationController` أو `Timer` بسيط يحرك obstacles/coins (list of `double x` positions)
4. `GestureDetector` للـ tap (jump) و`onLongPress`/`onLongPressEnd` (invincibility)

---

## 5. Rankings Page (0.5 / 0.8 pts خسرانين)

الملف: `lib/screens/rankings.dart` — دابا فارغة (غير AppBar).

- ❌ ماكاينش `ListView.builder` باش يوري النتائج (rank, name, coin, duration)
- ❌ ماكاينش ترتيب تنازلي حسب الوقت
- ❌ ماكاينش تخزين دائم (persistent storage)
- ❌ ماكاينش highlight للنتيجة الأخيرة

**Concept باش تتعلم:** `shared_preferences` (ولا `sqflite` إذا بغيتي تتعلم SQL) باش تخزن listة ديال records محليا، `List<Map>` + `jsonEncode/jsonDecode` باش تخزنها.

---

## 6. Setting Page (0.2 / 0.9 pts خسرانين)

الملف: `lib/screens/settings.dart`

- ✅ صورة السكير + Done button موجودين
- ❌ **ماكاينش color controller** (color picker) باش تبدل لون الجاكيت
- ❌ اللون المختار ماكايتطبقش فـ Game page

**Concept باش تتعلم:** widget بسيط بحال `Wrap` من `GestureDetector` كل وحدة `Container` بلون، ولا مكتبة `flutter_colorpicker`. باش يتطبق فالـ Game، خاص تمرر اللون عبر `Navigator` (بحال اسم اللاعب) أو `state management` بسيط (`ValueNotifier`/`Provider`).

**ملاحظة صغيرة:** `Settings` كايستعمل `Navigator.push` باش يرجع لـ Home بدل `Navigator.pop` — كايخلق نسخة جديدة فوق الـ stack بدل ما يرجع. الأفضل: `Navigator.pop(context)`.

---

## 7. خريطة الأولويات (لمرة الجاية)

### 🟢 المرحلة 1 — نقط مجانية (دقائق)
Folder name → applicationId → git push → portrait lock

### 🟡 المرحلة 2 — concepts بسيطة كايتكرراو (ساعة/ساعتين)
AlertDialog validation → "No Ranking" text → تمرير playerName بين الصفحات → `Navigator.pop` بدل `push` فـ Setting

### 🟠 المرحلة 3 — state & UI dynamique (نص نهار)
Timer للـ duration → coin counter ديناميكي → skier widget + jump → color controller فـ Setting + تطبيقه فـ Game

### 🔴 المرحلة 4 — الأصعب (يحتاج مكتبات خارجية)
`sensors_plus` (gyroscope) → `audioplayers` (أصوات) → `vibration` → obstacle/coin spawner + collision → game over dialog → invincibility mode → `shared_preferences` (rankings)

---

## 8. مكتبات (packages) لي غادي تحتاجهم

```yaml
dependencies:
  audioplayers: ^6.0.0       # bgm.mp3, jump.wav, coin.wav, game_over.wav
  vibration: ^2.0.0          # device vibration
  sensors_plus: ^6.0.0       # gyroscope tilt control
  shared_preferences: ^2.0.0 # persistent ranking storage
```

خدهم واحد واحد، فهم كل واحدة قبل ما تزيد التالية.
