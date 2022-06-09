#!/bin/bash

function convert-web-download-video() {
	ffmpeg -i "$2" -acodec copy "$2_audio.aac"

	ffmpeg -i "$1" -i "$2_audio.aac" -c copy -shortest "$1_result.mp4"

	ffmpeg -i "$1_result.mp4" "$3"

	rm $2_audio.aac
	rm $1_result.mp4
}

convert-web-download-video $1 $2 $3

# 使用方式 
# convert-web-download-video.sh 视频文件.mp4 音频文件.mp4 输出文件.mp4
