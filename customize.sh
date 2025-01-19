#!/sbin/sh
#!/bin/bash
# Module Protecter_Install
# 警告:不要修改这个文件，除非你知道你在做什么
# 使用提醒:请在安全/正规的环境下载并使用,谨防他人二改中招
# 请勿测/超/意淫作者，否则后果自负
# Update by Jusvain_ui V0.8.73
# Customization script by Jusvain_ui - @baiyao105
SKIPUNZIP=1

function get_config() {
  cat $sundry_config | grep -v '^#' | grep "^$1=" | cut -f2 -d '='
}

on_sundry(){
  unzip -j -o "${ZIPFILE}" 'Sundry/Tbest' -d $TMPDIR >&2 || abort "解压临时文件出错"
  unzip -j -o "${ZIPFILE}" 'Sundry/md5' -d $TMPDIR >&2 || abort "解压临时文件出错"
  unzip -j -o "${ZIPFILE}" 'Sundry/config.conf' -d $TMPDIR >&2 || abort "解压临时文件出错"
  unzip -j -o "${ZIPFILE}" 'module.prop' -d $TMPDIR >&2 || abort "解压临时文件出错"
  mkdir "/sdcard/Android/Jusvain"
  sundry_config="$TMPDIR/config.conf"
  bindnumber=$(getprop ro.boot.bindnumber)
  chipid=$(getprop ro.boot.xtc.chipid)
  serverinner=$(getprop persist.sys.serverinner)
  model="`grep_prop ro.product.innermodel`"
  if [[ "$serverinner" == "" ]]; then
    serverinner=$model
  fi
  if [[ "$chipid" == "" ]]; then
    abort "Chipid获取失败????"
  fi
  Hwmac=$(cat /sys/class/net/wlan0/address)
  input_string="${bindnumber}${serverinner}${chipid}${Hwmac}"
  hash=$(echo -n "$input_string" | sha256sum | awk '{print $1}')
  Ostring=${hash:0:8}
  OMODPATH=${MODPATH}.${string}
  dlog=$(get_config log)
  ddev=$(get_config developer)
  if [["$ddev" == "ture"]]; then
    ui_print "- [开发者]开发者模式被开启"
    target_dev=10
  else
    target_dev=00
  fi
  if [[ "$dlog" == "ture" ]]; then
    Clog=1
    Flog="$TMPDIR/installer.log"
    touch ${Flog}
    ui_print "- [开发者]日志模式被开启"
  else
    Clog=0
    Flog="/dev/null 2>&1"
  fi
  # 定义颜色代码,基本ANSI转义序列
  Red='\033[0;31m'
  Green='\033[0;32m'
  Yellow='\033[0;33m'
  Blue='\033[0;34m'
  NC='\033[0m' #默认
  # echo -e "${RED}Error:${NC} Something went wrong."  #输出红色字符串
}
print_Temp() {
  if ping -c 1 -W 1 gitee.com >> ${Flog}; then
      URL="https://gitee.com/baiyao105/jusvain/raw/master/Web/Best"
      data=$(curl -s "$URL")
      number=$(echo "$data" | grep -oP 'number="\K[0-9]+')
      startdate=$(echo "$data" | grep -oP 'startdate="\K[0-9]+')
      enddate=$(echo "$data" | grep -oP 'enddate="\K[0-9]+')
      text=$(echo "$data" | grep -oP 'text:\[\K[^\]]+')
      current_date=$(date +%Y%m%d)
      if [[ "$current_date" -ge "$startdate" && "$current_date" -le "$enddate" ]]; then
        text_array=($(  echo "$text" | tr -d '[]" ' | tr ',' '\n'))
        random_index=$((RANDOM % ${#text_array[@]}))
        best_text="${text_array[$random_index]}"
      fi
  else
      webstate=0
      if [[ -f "$TMPDIR/Tbest" ]]; then
          decoded_tbest=$(base64 -d "$TMPDIR/Tbest")
          text=$(echo "$decoded_tbest" | grep -oP 'text:\[\K[^\]]+')
          text_array=($(echo "$text" | tr -d '[]" ' | tr ',' '\n'))
          random_index=$((RANDOM % ${#text_array[@]}))
          number=0
          best_text="${text_array[$random_index]}"
      else
          abort "! 文件不可用，无法获取文本。"
      fi
  fi
    ver="`grep_prop version $TMPDIR/module.prop`"
    code="`grep_prop versionCode $TMPDIR/module.prop`"
    id="`grep_prop id $TMPDIR/module.prop`"
    imoo_ver="`grep_prop ro.product.current.softversion`"
    produce="`grep_prop ro.product.manufacturer`"
}
print_modname() {
  ui_print "#####################################################"
  ui_print "Jusvain UI - ${ver}($code).${webstate}_${target_dev}"
  ui_print "- *$best_text"
  if [ "$number" == 0 ];then
    ui_print "- *感谢有你 - 以本模块基础分支刷入次数超过6000 次!"
  else 
    ui_print "- *感谢有你 - 以本模块基础分支刷入次数超过${number}次!" 
    fi
  ui_print "#####################################################"
  if [ "$model" == I25 ];then
    ui_print "- 您的机型: Z7-${imoo_ver}_$produce.$API"
  elif [ "$model" == I32 ];then
      ui_print "- 您的机型: Z8&Z8少年版-${imoo_ver}_$produce.$API"
      elif [ "$model" == I20 ];then
          ui_print "- 您的机型: Z6DFB-${imoo_ver}_$produce.$API"
          elif [ "$model" == I25A ];then
            ui_print "- 您的机型: Z7A-${imoo_ver}_$produce.$API"
              elif [ "$model" == I25C ];then
                  ui_print "- 您的机型: Z7S-${imoo_ver}_$produce.$API"
                  elif [ "$model" == ND07 ];then
                      ui_print "- 您的机型: Z8A-${imoo_ver}_$produce.$API"
                      elif [ "$model" == ND01 ];then
                          ui_print "- 您的机型: Z9&Z9少年版-${imoo_ver}_$produce.$API"
                          elif [ "$model" == ND03 ];then
                                ui_print "- 您的机型: Z10-${imoo_ver}_$produce.$API"
                                abort "! 不支持此(Z10)机型"
                  else
                    abort "! 不支持该机型-$model"
                    fi
  ui_print "- 您的设备唯一标识符: ${Ostring}"
  ui_print "- 按照隐私协议,我们将保证您的的唯一标识符及设备信息不会用于其他用途."
  ui_print "- 隐私协议: gitee.com/baiyao105/jusvain_ui#隐私协议"
  ui_print "- 使用协议: gitee.com/baiyao105/jusvain_ui#使用协议"
  ui_print "- 安装位置: $MODPATH"
  ui_print "######################################################"
}
module_validation(){
  if $BOOTMODE; then
    ui_print " - 验证..."
    else
      ui_print "***************************"
      ui_print "! 不支持从Twrp或非标准环境安装"
      ui_print "! 将会导致出现非预期中的情况"
      ui_print "! 请使用magsik23.0及以上安装"
      abort "! 非标准环境"
  fi
    if [[ "$KSU" == "true" ]]; then
      ui_print "- KernelSU 用户空间当前的版本号: $KSU_VER_CODE"
      ui_print "- KernelSU 内核空间当前的版本号: $KSU_KERNEL_VER_CODE"
      ui_print "- [KernelSU]这对吗?"
      elif [ "$MAGISK_VER_CODE" -lt 23000 ];then
        ui_print "! Magisk版本低于23.0: $MAGISK_VER_CODE，安装终止。" 
        abort "!  Magisk版本低于23.0" 
      else
        ui_print " - Magisk版本: $MAGISK_VER ($MAGISK_VER_CODE)"
    fi
  if [ "$API" -ne 27 ]; then
    ui_print "! 安卓版本不兼容: $API，安装终止。"
    abort "! 设备SDK应为27 (Android 8.1)"
  fi
  for f in /data/adb/modules/*/module.prop; do
    sed -i '/^priority=/d' "$f"
    done
}
check(){
# 嗅探模块结构
nature_names=()
sky_imoo_names=()
for dir in /data/adb/modules/*/; do
  if [ -f "$dir/module.prop" ]; then
    if grep -q "极光" "$dir/module.prop" || grep -q "Nature" "$dir/module.prop"; then
      name=$(grep_prop name "$dir/module.prop")
      id=$(grep_prop id "$dir/module.prop")
      if [ -n "$name" ]; then
        nature_names+=("$name")
        touch "$dir/disable"
        touch "$dir/skip_mount"
        echo "[开发模式] 禁用挂载模块'${name}_${id}'"
      fi
    fi
  fi
  if grep -q "Sky-iMoo" "$dir/module.prop"; then
      name=$(grep_prop name "$dir/module.prop")
      id=$(grep_prop id "$dir/module.prop")
      if [ -n "$name" ]; then
        sky_imoo_names+=("$name")
        if [[ "$id" == *XTCPatch* ]]; then
          fpatch=1
        fi
      fi
  fi
done
if ["$fpatch" == "1"] ;then
  patchver=$(getprop persist.xtcpatch.version)
  pa_model=$(grep_prop ro.product.codebranch $dir/system.prop | cut -d'/' -f2)
  if [ "$model" != "$pa_model" ]; then
      ui_print "-警告 [XTCPatch]Patch信息与您的设备固件不符"
      elif [ "$webstate" != "0" ]; then 
            verurl="https://vip.123pan.cn/1814215835/xtc_root/xtcp_$model.txt"
            zipurl="https://vip.123pan.cn/1814215835/xtc_root/xtcpatch_$model.zip"
            webver=$(curl -s $verurl)
          fi
          if [ "$patchver" != "$webver" ]; then
              ui_print "- [XTCPatch]云端版本与您的版本不符[$webver]-[$patchver]"
              ui_print "- [XTCPatch]准备开始更新xtcpatch"
              curl -# ${zipurl} -o $TMPDIR/xtcpatch.zip
              ui_print "- [XTCPatch]开始安装xtcpatch,此过程可能需要大约1min,请耐心等待"
              magisk --install-module $TMPDIR/xtcpatch.zip >> ${Flog}
              patchver=$(getprop persist.xtcpatch.version)
              if [ "$patchver" == "$webver" ]; then
                  ui_print "- [XTCPatch]xtcpatch更新完成"
              else
                  ui_print "! [XTCPatch]xtcpatch更新失败"
              fi
          fi
fi
if [ ${#nature_names[@]} -gt 0 ]; then
  echo -n "- 包含'Nature'的模块："
  printf "%s " "${nature_names[@]}"
  echo
fi
if [ ${#sky_imoo_names[@]} -gt 0 ]; then
  echo -n "- 包含 'Sky-iMoo' 的模块名称："
  printf "%s " "${sky_imoo_names[@]}"
  echo
fi
}
install(){
  if ["$Clog" = "1"];then
    move ${Flog} /sdcard/Android/Jusvain/ || abort " 移动log文件出错"
  fi
  unzip -j -o "${ZIPFILE}" 'system/*' -d $MODPATH/system >&2 || abort "解压挂载文件出错"
  unzip -j -o "${ZIPFILE}" 'common/post-fs-data.sh' -d $MODPATH >&2 || abort "解压脚本时出错"
  unzip -j -o "${ZIPFILE}" 'common/service.sh' -d $MODPATH >&2 || abort "解压脚本时出错"
  unzip -j -o "${ZIPFILE}" 'common/system.prop' -d $MODPATH >&2 || abort "解压脚本时出错"
  unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d $MODPATH >&2 || abort "解压挂载文件出错"
  rm -rf $MODPATH/module.prop
  touch $MODPATH/module.prop
  echo "ro.Jusvain.ipmentId=${Ostring}" >>$MODPATH/system.prop
  echo "id=Jusvain_UI.${Ostring}" >$MODPATH/module.prop
  echo "name=Jusvain UI" >>$MODPATH/module.prop
  echo -n "version=V0.8.73_" >>$MODPATH/module.prop
  echo "${Ostring}" >>$MODPATH/module.prop
  echo "versionCode=0087320250101" >>$MODPATH/module.prop
  echo "author=白杳(@baiyao105)" >>$MODPATH/module.prop
  echo "description=JusvainUI主分支,感谢有你.您的设备标识符: $string" >>$MODPATH/module.prop
  echo "updateJson=https://gitee.com/baiyao_file/Bayui/raw/master/update.json" >>$MODPATH/module.prop
  echo "update=true" >>$MODPATH/module.prop
  echo "minMagisk=23000" >>$MODPATH/module.prop
  echo "priority=999999" >>$MODPATH/module.prop
  post_md5=$(md5sum "$MODPATH/post-fs-data.sh" | awk '{print $1}')
  service_md5=$(md5sum "$MODPATH/service.sh" | awk '{print $1}')
  if [[ -f "$TMPDIR/md5" ]]; then
    Fmd5_post="`grep_prop post-fs-data $TMPDIR/md5`"
    Fmd5_service="`grep_prop service $TMPDIR/md5`"
  else
    abort "MD5 文件不存在"
  fi
  if [[ "$post_fs_data_md5" != "$Fmd5_post" ]]; then
    abort "post-fs-data的MD5不匹配,模块很有可能损坏了,请重新下载后安装"
  elif [[ "$service_md5" != "$Fmd5_service" ]]; then
    abort "Service的MD5不匹配,模块很有可能损坏了,请重新下载后安装"
  fi
}