# پیتێن کوردی — Piten Kurdi

A Flutter app for learning the 34 letters of the Kurdish (Arabic-script) alphabet.

- Big letters. Swipe sideways, or use the buttons, to move between letters.
- An example word and picture for every letter, with the letter highlighted.
- The forms of each letter (alone, start, middle, end).
- Mark letters as learned. Progress is saved on the device.
- A quiz: see a picture word and pick the letter it starts with. Wrong choices include letters that look alike (ب پ ت, ر ڕ ز ژ …).
- No sound and no music.

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
