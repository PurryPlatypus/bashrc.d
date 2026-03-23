
# WARNING: this is an unordered and barely maintained mess!

# it's mostly designed (made to fit) AMD GPUs, via VAAPI
# AMD AMF seems to require recompilation of ffmpeg, and usage of the proprietary amdgpu driver(?), i'm not interested
# Intel QSV / QuickSync doesn't seem to work well, without recompiling ffmpeg
# NVENC works well, but i'm not using Nvidia GPUs

# time, nice, ionice: these functions are tuned to run in the background, while the rest of the box deals with daily driver tasks

# turn anything into an MP3
ffmp3 () {
  ffmpeg -i "$1" -vn -ar 44100 -ac 2 -b:a 192k "$1.mp3"
}

# try, and extract subtitles, transcoded to SRT format
ffsubtosrt () {
  mkdir -p ff_out
  time nice -n19 ionice -c3 ffmpeg -i "$1" -map 0:s:0 -c:s srt "ff_out/$1.srt"
}

# rotate video clockwise, 90 degrees
ffclockwise () {
  time nice -n19 ionice -c3 ffmpeg -i "$1" -vf "transpose=1" "$1.clockwise.mkv"
}

# rotate video counterclockwise, 90 degrees
ffcounterclockwise () {
  time nice -n19 ionice -c3 ffmpeg -i "$1" -vf "transpose=2" "$1.counterclockwise.mkv"
}

# invert video colours
ffinvert () {
  time nice -n19 ionice -c3 ffmpeg -i "$1" -vf negate "$1.inverted.mkv"
}

# print refined ffmpeg transpose/rotate help text
fftranspose () {
  echo -e "\nffmpeg -i in.mov -vf \"transpose=1\" out.mov\n"\
  "0 = 90CounterCLockwise and Vertical Flip (default)\n"\
  "1 = 90Clockwise\n"\
  "2 = 90CounterClockwise\n"\
  "3 = 90Clockwise and Vertical Flip\n"
}
