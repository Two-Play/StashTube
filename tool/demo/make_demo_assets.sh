#!/usr/bin/env bash
# Builds the media of the built-in demo (assets/demo/): short clips from the
# opening of Blender's open movie Big Buck Bunny (CC BY 3.0, (c) Blender
# Foundation, www.bigbuckbunny.org), cut into scenes and portrait shorts, with
# covers, animated WebP previews, seek sprites, stills and portraits.
#
#   tool/demo/make_demo_assets.sh [work dir]
#
# Needs curl, ffmpeg (with libx264 and libwebp) and python3. The source is
# the first 87 seconds of the film from the Matroska test files on GitHub.
# Writes assets/demo/manifest.json with each clip's facts (duration, size,
# codecs), which DemoLibrary reads; the titles, people and tags are in
# lib/features/demo/demo_library.dart.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
out=$here/../../assets/demo
work=${1:-${TMPDIR:-/tmp}/stashtube-demo-assets}
rm -rf "$out"
mkdir -p "$work" "$out"/{scenes,covers,previews,sprites,images,portraits}

source=$work/bbb.mkv
[ -s "$source" ] || curl -fL --progress-bar -o "$source" \
  https://raw.githubusercontent.com/Matroska-Org/matroska-test-files/master/test_files/test1.mkv

encode() { # <out> <start> <seconds> <filter>
  ffmpeg -v error -y -ss "$2" -t "$3" -i "$source" -vf "$4" -c:v libx264 -preset slow -crf 30 \
    -profile:v main -pix_fmt yuv420p -c:a aac -b:a 64k -movflags +faststart "$1"
}

# <name> <start> <seconds> <cover second>: landscape 640x360.
scene() {
  encode "$out/scenes/$1.mp4" "$2" "$3" "scale=640:360"
  extras "$1" "$4" 160:90 320:180
}

# <name> <start> <seconds> <cover second> <x of the 9:16 crop>: portrait 360x640.
short() {
  encode "$out/scenes/$1.mp4" "$2" "$3" "crop=270:480:$5:0,scale=360:640"
  extras "$1" "$4" 90:160 180:320
}

# Cover, a 3 s looping WebP preview from the cover on, and a seek sprite
# (one frame per second, five per row).
extras() {
  local clip=$out/scenes/$1.mp4
  ffmpeg -v error -y -ss "$2" -i "$clip" -frames:v 1 -q:v 4 "$out/covers/$1.jpg"
  ffmpeg -v error -y -ss "$2" -t 3 -i "$clip" -vf "fps=8,scale=$4" -an -c:v libwebp_anim -loop 0 -quality 35 \
    "$out/previews/$1.webp"
  local seconds rows
  seconds=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$clip" | awk '{print int($1 + 0.999)}')
  rows=$(( (seconds + 4) / 5 ))
  ffmpeg -v error -y -i "$clip" -vf "fps=1,scale=$3,tile=5x$rows" -frames:v 1 -q:v 6 "$out/sprites/$1.jpg"
}

echo "cutting scenes"
scene morning-sky 1 10 5
scene riverside 10 6.5 3
scene the-early-bird 15 8 2
scene opening-titles 19 11 7
scene the-burrow 28 18 14
scene rise-and-shine 44 14 6
scene sunny-side 56 14 4
scene a-butterfly-appears 68 19 10
short short-bird 15 6 2 290
short short-wake-up 38 9 6 300
short short-stretch 46 8 3 260
short short-butterfly 76 10 2 230

echo "stills and portraits"
i=0
for t in 3 8 13 17 25 42 49 61 66 72 79 85; do
  i=$((i + 1))
  ffmpeg -v error -y -ss "$t" -i "$source" -frames:v 1 -vf scale=854:480 -q:v 4 "$out/images/still-$(printf %02d $i).jpg"
done
portrait() { # <file> <second> <crop w:h:x:y>
  ffmpeg -v error -y -ss "$2" -i "$source" -frames:v 1 -vf "crop=$3,scale=320:320" -q:v 4 "$out/portraits/$1.jpg"
}
portrait big-buck-bunny 49 260:260:250:30
portrait purple-bird 17 260:260:290:40
portrait butterfly 78 260:260:230:0

python3 - "$out" <<'EOF'
import json, os, subprocess, sys
out = sys.argv[1]
clips = {}
for name in sorted(os.listdir(os.path.join(out, 'scenes'))):
    path = os.path.join(out, 'scenes', name)
    probe = json.loads(subprocess.check_output(['ffprobe', '-v', 'error', '-show_format', '-show_streams', '-of', 'json', path]))
    video = next(s for s in probe['streams'] if s['codec_type'] == 'video')
    audio = next((s for s in probe['streams'] if s['codec_type'] == 'audio'), None)
    num, den = video['r_frame_rate'].split('/')
    clips[name.rsplit('.', 1)[0]] = {
        'duration': round(float(probe['format']['duration']), 2),
        'size': os.path.getsize(path),
        'width': video['width'], 'height': video['height'],
        'video_codec': video['codec_name'], 'audio_codec': audio['codec_name'] if audio else '',
        'frame_rate': round(int(num) / int(den), 2),
        'bit_rate': int(probe['format']['bit_rate']),
    }
images = sorted(n.rsplit('.', 1)[0] for n in os.listdir(os.path.join(out, 'images')))
with open(os.path.join(out, 'manifest.json'), 'w') as f:
    json.dump({'clips': clips, 'images': images}, f, indent=1, sort_keys=True)
    f.write('\n')
EOF
du -sh "$out"
