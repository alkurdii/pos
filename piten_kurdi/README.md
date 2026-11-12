# پیتێن کوردی — Piten Kurdi

A Flutter app for learning the 34 letters of the Kurdish (Arabic-script) alphabet.

- Big letters. Swipe sideways, or use the buttons, to move between letters.
- An example word and picture for every letter, with the letter highlighted.
- The forms of each letter (alone, start, middle, end).
- Mark letters as learned. Progress is saved on the device.
- A quiz: see a picture word and pick the letter it starts with. Wrong choices include letters that look alike (ب پ ت, ر ڕ ز ژ …).
- **Daily plan** (the "ئەڤرۆ" tab): 4 new letters a day, each repeated 100 times;
  every letter from earlier days reviewed 25 times a day until it is starred as known.
  34 letters take 9 days; after that only review remains. The next day opens on the
  next calendar day once today's work is done. Built for an adult who cannot read yet:
  big letters, progress rings, icons, one tap = one repetition.
- **Letter sounds from YouTube**: the 🔊 button plays the part of
  [this video](https://www.youtube.com/watch?v=MvKsM_omhKs) (Helat Abdullah Sharafani)
  where the letter is said, in an embedded YouTube player. The audio is not copied
  into the app. Someone who can read marks each letter's place once, under
  ⚙ → دەنگێن پیتان ژ یوتیوبێ: play the video and tap each letter as it is said.
  The marks can be copied and built into `defaultSoundStarts` in `lib/sounds.dart`.
- No music.

The interface is in Kurdish (Badini) and right to left.

## Run

```sh
flutter pub get
flutter run            # phone or emulator
flutter run -d chrome  # in the browser
flutter test
```

## Fonts

`assets/fonts` holds Noto Naskh Arabic and Noto Sans Arabic from Google Fonts
(SIL Open Font License 1.1), so the letters look right without an internet connection.
Only the letter sounds need the internet.
