#!/usr/bin/env bash
# Starts a demo Stash for the README screenshots, filled with clips from
# Blender's open movies (CC BY): Tears of Steel, Caminandes: Gran Dillama, and
# the Sintel and Big Buck Bunny trailers.
#
#   tool/screenshots/demo_server.sh <work dir>
#
# Needs curl, ffmpeg, docker and python3. Downloads about 500 MB into
# <work dir>/downloads (once), cuts scenes, portrait clips for the shorts and
# stills into <work dir>/data, runs stashapp/stash on http://localhost:9999 as
# the container "stashtube-demo", and fills it (seed_demo.py). Remove it with
#   docker rm -f stashtube-demo
set -euo pipefail

work=${1:?usage: demo_server.sh <work dir>}
here=$(cd "$(dirname "$0")" && pwd)
downloads=$work/downloads
data=$work/data
mkdir -p "$downloads" "$data/scenes" "$data/shorts" "$data/images" "$work/config" "$work/covers" "$work/portraits"

fetch() { [ -s "$downloads/$1" ] || curl -fL --progress-bar -o "$downloads/$1" "$2"; }
fetch tos.mov https://download.blender.org/demo/movies/ToS/tears_of_steel_720p.mov
fetch sintel_trailer.mp4 https://download.blender.org/durian/trailer/sintel_trailer-720p.mp4
fetch bbb_trailer.mov https://download.blender.org/peach/trailer/trailer_480p.mov
if [ ! -s "$downloads/caminandes_gran_dillama.mp4" ]; then
  fetch caminandes.zip https://download.blender.org/demo/movies/caminandes_gran_dillama.mp4.zip
  unzip -o -q "$downloads/caminandes.zip" -d "$downloads" && rm "$downloads/caminandes.zip"
fi

# scene <name> <source> <start> <seconds>: landscape, at most 720p.
scene() {
  [ -s "$data/scenes/$1.mp4" ] || ffmpeg -v error -y -ss "$3" -t "$4" -i "$downloads/$2" \
    -vf "scale='trunc(min(1280,iw)/2)*2':-2" -c:v libx264 -preset veryfast -crf 24 -c:a aac -b:a 128k \
    -movflags +faststart "$data/scenes/$1.mp4"
}
# short <name> <source> <start> <seconds>: the middle of the frame in 9:16.
short() {
  [ -s "$data/shorts/$1.mp4" ] || ffmpeg -v error -y -ss "$3" -t "$4" -i "$downloads/$2" \
    -vf "crop=ih*9/16:ih,scale=540:960" -c:v libx264 -preset veryfast -crf 24 -c:a aac -b:a 128k \
    -movflags +faststart "$data/shorts/$1.mp4"
}

echo "cutting clips"
scene tos-old-memories tos.mov 120 90
scene tos-the-bridge tos.mov 240 90
scene tos-the-robots tos.mov 330 90
scene tos-last-stand tos.mov 450 90
scene tos-ending tos.mov 540 60
scene caminandes-gran-dillama caminandes_gran_dillama.mp4 0 146
scene sintel-trailer sintel_trailer.mp4 0 52
scene big-buck-bunny-trailer bbb_trailer.mov 0 33
short short-celia-runs tos.mov 270 25
short short-robot tos.mov 330 20
short short-koro caminandes_gran_dillama.mp4 30 25
short short-sintel sintel_trailer.mp4 20 20
short short-bunny bbb_trailer.mov 0 20

# Twelve stills for the images and the gallery.
for i in $(seq 1 12); do
  [ -s "$data/images/still-$i.jpg" ] || ffmpeg -v error -y -ss $((i * 45)) -i "$downloads/tos.mov" \
    -frames:v 1 -q:v 3 "$data/images/still-$i.jpg"
done

# Covers: a frame from each clip (Stash would take the first one, often black
# or a title card), at 40 % or the given second. Kept outside /data.
cover() {
  local clip=$data/$1.mp4 at=${2:-}
  [ -n "$at" ] || at=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$clip" | awk '{print $1 * 0.4}')
  [ -s "$work/covers/$(basename "$1").jpg" ] || ffmpeg -v error -y -ss "$at" -i "$clip" -frames:v 1 -q:v 3 \
    "$work/covers/$(basename "$1").jpg"
}
for clip in "$data"/scenes/*.mp4 "$data"/shorts/*.mp4; do
  name=$(basename "$(dirname "$clip")")/$(basename "$clip" .mp4)
  case $name in
    scenes/big-buck-bunny-trailer) cover "$name" 16.2 ;;
    scenes/sintel-trailer) cover "$name" 26 ;;
    shorts/short-bunny) cover "$name" 16.2 ;;
    shorts/short-sintel) cover "$name" 6 ;;
    *) cover "$name" ;;
  esac
done

# Portraits of the characters: <name> <source> <second> <crop w:h:x:y> [filter].
portrait() {
  [ -s "$work/portraits/$1.jpg" ] || ffmpeg -v error -y -ss "$3" -i "$downloads/$2" -frames:v 1 \
    -vf "crop=$4${5:+,$5},scale=400:400" -q:v 3 "$work/portraits/$1.jpg"
}
portrait Celia tos.mov 320.5 360:360:620:30
portrait Thom tos.mov 316 360:360:300:30
portrait Barley tos.mov 214 300:300:450:20
portrait Koro caminandes_gran_dillama.mp4 28 600:600:260:200
portrait Sintel sintel_trailer.mp4 14.25 440:440:290:60 eq=brightness=0.05:gamma=1.5
portrait "Big Buck Bunny" bbb_trailer.mov 16.2 300:300:302:40

if ! docker ps --format '{{.Names}}' | grep -qx stashtube-demo; then
  docker rm -f stashtube-demo >/dev/null 2>&1 || true
  docker run -d --name stashtube-demo -p 9999:9999 \
    -v "$work/config:/root/.stash" -v "$data:/data" stashapp/stash:latest >/dev/null
fi
python3 "$here/seed_demo.py" http://localhost:9999 "$work"
