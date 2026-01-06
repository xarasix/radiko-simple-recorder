# radiko-simple-recorder
- A simple bash script to record live radiko.jp broadcasts.
- radikoの生放送を簡単に録音するためのシンプルなbashスクリプトです。

## Important Notes / 重要なお知らせ
- This script is for personal use only (private recording within the scope permitted by Japanese copyright law).
- Do not distribute recorded files or use for commercial purposes.
- 本スクリプトは私的使用（著作権法で認められる範囲内の個人的録音）のためだけに使用してください。
- 録音ファイルを配布したり商用利用したりしないでください。

## Features / 特徴
- Record any radiko live stream easily / 保存先フォルダを自由に指定可能
- Specify save directory freely / ファイル名も自由に決められる
- Choose output format (mp3, flac, opus, etc.) / 出力形式を選択可能（mp3 / flac / opus など）
- Minimal dependencies (only streamlink and ffmpeg) / 必要なツールは streamlink と ffmpeg だけ

## Requirements / 必要な物
- streamlink (`pipx install streamlink` or `sudo apt install streamlink`)
- ffmpeg (`sudo apt install ffmpeg`)

## Notes
- Free area only (no premium/time-free support) / フリーエリアのみ使用できます。
- Station ID is case-insensitive (tbs → TBS automatically) / 自動で大文字変換するので気にしないでいいです。
- Full list: https://radiko.jp/index/ / ステーションのリストはhttps://radiko.jp/index/ を確認してください。

## Usage / 使い方
```bash
./radiko-simple-recorder.sh <save_directory> <station> <file_name> <duration> [format]
./radiko-simple-recorder.sh 保存先フォルダ 局コード ファイル名 録音時間 [形式]

# Examples
# Record TBS Radio for 122 minutes as MP3 (default)
./radiko-simple-recorder.sh ~/Radio TBS tamamusubi 122m

# Record as high-quality FLAC
./radiko-simple-recorder.sh ~/Radio TBS tamamusubi 122m flac

# Record J-WAVE as Opus (small file size)
./radiko-simple-recorder.sh ~/Radio FMJ janesu 90m opus

# Station IDs (examples)
TBS Radio: TBS
J-WAVE: FMJ
文化放送(QR): QRR
InterFM: INT
```
