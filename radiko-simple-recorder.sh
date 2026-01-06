#!/bin/bash

# radi.sh - Simple radiko live stream recorder
# Usage: radi.sh <save_directory> <station> <file_name> <duration> [format]
#
# Example:
#   radi.sh ~/Radio TBS ijuin 122m               # mp3 (default)
#   radi.sh ~/Radio TBS ijuin 122m flac          # FLAC
#   radi.sh ~/Radio TBS ijuin 122m opus          # Opus
#
# Example cron:
#   59 23 * * 1 radi.sh ~/Radio TBS ijuin 122m   # mp3 (default)
#

if [ $# -lt 4 ] || [ $# -gt 5 ]; then
    echo "Usage: $0 <save_directory> <station> <file_name> <duration> [format]"
    echo "  <save_directory> : Directory to save recorded files"
    echo "  <station>        : Station ID (e.g. TBS, QRR, LFM) - uppercase recommended"
    echo "  <file_name>      : Base name of output file"
    echo "  <duration>       : Recording time (e.g. 122m, 90m, 2h)"
    echo "  [format]         : Output format - mp3 (default), mp4/m4a, flac, opus"
    exit 1
fi

save_dir="$1"
station="${2^^}"          # Convert to uppercase (tbs -> TBS)
file_name="$3"
duration="$4"
format="${5:-mp3}"        # Default to mp3 if not specified

# Create save directory if it doesn't exist
mkdir -p "$save_dir"

# Timestamp for filename (to avoid overwrites)
date_buf=$(date '+%Y-%m-%d_%H%M')

ts_file="${save_dir}/${file_name}_${date_buf}.ts"
out_file="${save_dir}/${file_name}_${date_buf}.${format}"

# Adjust extension for container-specific formats
case "$format" in
    m4a|aac) out_file="${save_dir}/${file_name}_${date_buf}.m4a" ;;
    opus)    out_file="${save_dir}/${file_name}_${date_buf}.opus" ;;
esac

echo "Recording start: $station - $file_name ($duration)"
echo "Output file: $out_file"

# Record using streamlink
timeout "$duration" streamlink \
    "https://radiko.jp/#!/live/$station" best \
    -o "$ts_file" \
    --loglevel error

# Check if recording succeeded
if [ ! -f "$ts_file" ] || [ ! -s "$ts_file" ]; then
    echo "Error: Recording failed (TS file missing or empty)"
    echo "Debug tip: Try running manually:"
    echo "  streamlink 'https://radiko.jp/#!/live/$station' best --stream-url"
    rm -f "$ts_file"
    exit 1
fi

echo "TS recording completed. Size: $(du -h "$ts_file" | cut -f1)"

# Convert to desired format
case "$format" in
    mp3)
        ffmpeg -i "$ts_file" -vn -acodec libmp3lame -b:a 192k -y "$out_file"
        ;;
    mp4|m4a|aac)
        ffmpeg -i "$ts_file" -vn -acodec aac -b:a 192k -y "$out_file"
        ;;
    flac)
        ffmpeg -i "$ts_file" -vn -acodec flac -compression_level 8 -y "$out_file"
        ;;
    opus)
        ffmpeg -i "$ts_file" -vn -acodec libopus -b:a 128k -y "$out_file"
        ;;
    *)
        echo "Error: Unsupported format: $format"
        echo "Supported: mp3, mp4/m4a, flac, opus"
        rm -f "$ts_file"
        exit 1
        ;;
esac

# Clean up temporary TS file
rm -f "$ts_file"

echo "Conversion complete: $out_file"
echo "Final file size: $(du -h "$out_file" | cut -f1)"

