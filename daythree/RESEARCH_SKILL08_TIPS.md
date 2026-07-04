# Recherche: WorldSkills Skill 08 - Mobile Applications Development
## ملخص العفايس/الأخطاء الشائعة لي كتأثر على Module A (Functionality)

> بنيت هاد الملف من: الوصف التقني الرسمي (WorldSkills Singapore 2025), الـ WSOS الرسمي (من marking scheme ديالك), وتحليل الأخطاء لي لقيتهم فمشروعك `daythree` ديال Module A - AM.

---

## 1. الـ WSOS الرسمي — فين كاينين النقط الحقيقيين (100%)

هاد الجدول رسمي وثابت فكل الدورات (Lyon 2024, Singapore 2025...):

| القسم | الوزن | شنو يعني |
|---|---|---|
| Work organization and management | 8% | كيفاش كتنظم وقتك، كتحترم الـ deadlines، كتخدم بمنهجية |
| Communication and interpersonal skills | 7% | كتفهم البريف صح، كتوثق شغلك |
| Sustainable Practice | 5% | تنظيم الموارد، بلا هدر |
| **Initial planning, design and test framework** | **25%** | التخطيط قبل الكود + test plan |
| **System architecture planning** | **15%** | بنية المشروع، فصل الطبقات (layers) |
| **Implementation and product development** | **30%** | الكود الفعلي — هنا كاين معظم النقط |
| Final product tests, troubleshooting and optimization | 10% | اختبار، تصحيح، تحسين |

**الدرس الكبير:** 20% من النقط (Work org + Communication + Sustainable) **ماعندهاش علاقة بالكود** — كتخسرها غير بسوء التنظيم (بحال ماوقع معاك: folder name خاطئ، ماكاينش push، applicationId خاطئ). هادوك النقط "السهلين" لي حكينا عليهم قبل هوما بالضبط من هنا.

---

## 2. الأخطاء الشائعة (l3fayas) — Module Functionality تحديداً

### 🔴 خطأ #1: التركيز على الكود ونسيان "Instructions to the Competitor"
هاد الصفحة الأخيرة ديال كل PDF (المشروع ديالك، صفحة 11) دايماً فيها 2.8 نقطة "مجانية" (folder name, package name, git push) — وهي أول حاجة كيهدرها المتنافسين لأنهم كيركزو غير على الفيتشرات. **تحقق منها أول شي، قبل ما تبدا تكتب كود.**

### 🔴 خطأ #2: بناء الـ UI الستاتيكية بلا state حقيقية
لاحظتها بالضبط فمشروعك: `Text('10')`, `Text('10 s')` مكتوبين hardcoded بدل ما يكونو مربوطين بـ variable فـ `State`. هاد الشيء كيبان "خدام" فأول screenshot ولكن الـ marking scheme كيفرق بزاف — الـ judges كيديرو manipulation فعلية (اختبار الميزة، ماشي غير تصوير).

### 🔴 خطأ #3: نسيان `dispose()` على الموارد
`Timer`, `StreamSubscription` (لـ gyroscope عبر `sensors_plus`), `AnimationController`, `TextEditingController` — إلا نسيتيهم فـ `dispose()`، كيبقاو خدامين فالخلفية ("memory leak") حتى بعد ما تخرج من الصفحة، وهادشي كيبان فـ "Final product tests, troubleshooting" (10%) ملي كيديرو تست طويل.

### 🔴 خطأ #4: عدم احترام "Measured" vs "Judged" aspects
فالـ xlsx، الغالبية العظمى ديال الأسپكتات نوعها `M` (Measurement = objective, كاين ولا ماكاينش، بلا نقاش) و غير وحدة `J` (Judgement = subjective تقييم). **استراتيجياً: أولوية للـ M aspects** لأن كل وحدة فيهم نقطة مضمونة إلا خدمتيها بالضبط بحال ماهي مكتوبة، بينما الـ J aspect (كيفية الـ UX) صعيب توصل للنقطة الكاملة ديالو حتى لو الكود نظيف.

### 🔴 خطأ #5: قراءة البريف بالتقريب بدل الحرفية
مثال من مشروعك: البريف كيقول "If the player name input box is empty, a prompt box will pop up with the message **'Invalid'**" — النص خاصو يكون بالضبط "Invalid"، ماشي "خطأ" ولا "Please enter a name". الـ Measurement aspects غالباً كيتحققو بالنص الحرفي.

### 🔴 خطأ #6: تجاهل "Sustainable Practice" (5%) و"Communication" (7%)
هاد الجوج أقسام (12% مجتمعين) كيتقيسو بحوار مع الـ expert ("ليش خدمتي هكاك؟") و commit messages واضحة. **كل ما commit ديالك عندو رسالة وصفية (`feat: add jump mechanic` بدل `update`)، كل ما بنيتي "trace" ديال العمل ديالك.**

### 🔴 خطأ #7: الاعتماد الكلي على مكتبات بلا فهم
البريف كيتطلب `sensors_plus` (gyroscope), `audioplayers`, `vibration` — خاصك تفهم كيفاش كيخدمو (streams, async, permissions) باش تقدر تصلح bug تحت ضغط الوقت. الوصف الرسمي كيحدد بالضبط: *"Capability of smart terminals such as cameras, GPS, gyroscopes, accelerometers, and Bluetooth"* كجزء من المعرفة المطلوبة (C2 - Core Function Modules Development).

### 🔴 خطأ #8: نسيان اختبار الحالات الحدية (edge cases)
- شنو كيوقع ملي الـ coins يوصلو لـ 0 فالـ invincibility mode؟
- شنو كيوقع ملي الـ Rankings list فارغة؟
- شنو كيوقع ملي كتدير swipe فنفس الوقت لي كاين dialog مفتوح؟
هاد الحالات دايماً كيتختبرو من طرف الـ judges لأنها سهلة الاختبار وكتبين جودة الكود.

---

## 3. نصائح استراتيجية للمنافسة (من الوصف الرسمي)

1. **Version control حقيقي** — الوصف التقني الرسمي كيذكر *"the principles and applications of version control"* كجزء من المعرفة المطلوبة، ماشي غير "push فالآخر" — يعني commits منتظمة خلال الخدمة، ماشي commit واحد فالنهاية.
2. **Coding specifications** — الوصف كيذكر *"specifications for writing codes"* و*"the importance of mobile application codes"* — يعني naming conventions, formatting, لا تخلط منطق الـ UI مع منطق الـ business logic فنفس الملف.
3. **Test report** — جزء "Testing and Delivery" (C3) كيتطلب *"generate a test report"* — درب روحك تكتب ملاحظات قصيرة على شنو جربتي وشنو خدام.
4. **الأداة الرسمية هي Flutter** (مذكورة صراحة فالمتطلبات: Flutter 3.22+, Android SDK 34+) — راك ديجا فالطريق الصحيح بلا مانستعمل React Native ولا Kotlin native.

---

## 4. خلاصة: شنو دير المرة الجاية بالترتيب

1. ✅ إحترم بنية الفولدر والتسمية (نقط مجانية) — أول شي
2. ✅ Commit منتظم بـ رسائل واضحة (ماشي غير فالآخر)
3. ✅ اربط كل عنصر فالـ UI بـ state حقيقي (بلا hardcoded values) من البداية
4. ✅ نفذ النصوص/الرسائل بالحرف كيفما مكتوبين فالبريف
5. ✅ `dispose()` لكل Controller/Timer/Stream
6. ✅ جرب edge cases قبل ما تقول "خلصت"
7ـ ✅ اكتب تعليق قصير (أو commit message) كيوثق القرارات التقنية ديالك (تخدم عليه الـ Communication/Sustainable Practice)

---

## Sources
- [Mobile Applications Development | WorldSkills](https://worldskills.org/skills/id/562/)
- [WorldSkills Occupational Standards - Mobile Applications Development](https://worldskills.org/what/projects/wsos/2024/events/579/skills/1659)
- [WorldSkills Singapore 2025 - Technical Description, Mobile Application Development (PDF)](https://www.worldskills.sg/docs/default-source/default-document-library/wss2025_technical-description_mobile-application-development.pdf?sfvrsn=4cf6d903_0)
- [Mobile Applications Development - WorldSkills Lyon 2024](https://worldskills2024.com/en/skills/mobile-applications-development/index.html)
- [GitHub - Alexis764/Mobile-Application-Development-WorldSkills-Test-Projects](https://github.com/Alexis764/Mobile-Application-Development-WorldSkills-Test-Projects) (أمثلة ديال test projects من دورات سابقة، مفيدة للتمرن)
- Marking scheme محلي: `WSC2024_08_Mobile_Applications_Development_marking_scheme.xlsx`
