#!/bin/bash

function convert-web-download-video() {
	file1="$1_0._src"
	file2="$1_1._src"
	target="$1.mp4"

    # 解第一个参数音频
	ffmpeg -i "$file1" -vn -ab 128k -ar 44100 -strict -2 -y "1_audio.aac"

	if [ $? -ne 0 ]; then
		echo -e "\033[31mCOVERT-WEB-DOWNLOAD-VIDER FAIL ON #1 \033[0m"
		if [ -f 1_audio.aac ] ; then
    		rm 1_audio.aac
		fi
		
		# 失败后解第二个参数音频
		ffmpeg -i "$file2" -vn -ab 128k -ar 44100 -strict -2 -y "2_audio.aac"
		if [ $? -ne 0 ]; then
			# 音频失败
			echo -e "\033[31mCOVERT-WEB-DOWNLOAD-VIDER FAIL ON AUDIO.\033[0m"
			if [ -f 2_audio.aac ] ; then
    			rm 2_audio.aac
			fi
		else
			# 解第一个参数视频
			ffmpeg -i "$file1" -i "2_audio.aac" -c copy -shortest "result.mp4"
			if [ $? -ne 0 ]; then
				# 视频失败
				echo -e "\033[31mCOVERT-WEB-DOWNLOAD-VIDER FAIL ON VIDER.\033[0m"
				rm result.mp4
			else
				# 最后转码
				ffmpeg -i "result.mp4" "$target"
				rm 2_audio.aac
				rm result.mp4
			fi
		fi
	else
		# 解第二个参数视频
		ffmpeg -i "$file2" -i "1_audio.aac" -c copy -shortest "result.mp4"
		if [ $? -ne 0 ]; then
			# 视频失败
			echo -e "\033[31mCOVERT-WEB-DOWNLOAD-VIDER FAIL ON VIDER.\033[0m"
		else
			# 最后转码
			ffmpeg -i "result.mp4" "$target"
			rm 1_audio.aac
			rm result.mp4
		fi
	fi
}

convert-web-download-video $1

# 使用方式 
# convert-web-download-video.sh 下载时的名称（不需要后缀名）
