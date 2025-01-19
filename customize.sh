#!/sbin/sh
#!/bin/bash
# Module Protecter_Install
# ����:��Ҫ�޸�����ļ���������֪��������ʲô
# ʹ������:���ڰ�ȫ/����Ļ������ز�ʹ��,�������˶�������
# �����/��/�������ߣ��������Ը�
# Update by Jusvain_ui V0.8.73
# Customization script by Jusvain_ui - @baiyao105
SKIPUNZIP=1

function get_config() {
  cat $sundry_config | grep -v '^#' | grep "^$1=" | cut -f2 -d '='
}

on_sundry(){
  unzip -j -o "${ZIPFILE}" 'Sundry/Tbest' -d $TMPDIR >&2 || abort "��ѹ��ʱ�ļ�����"
  unzip -j -o "${ZIPFILE}" 'Sundry/md5' -d $TMPDIR >&2 || abort "��ѹ��ʱ�ļ�����"
  unzip -j -o "${ZIPFILE}" 'Sundry/config.conf' -d $TMPDIR >&2 || abort "��ѹ��ʱ�ļ�����"
  unzip -j -o "${ZIPFILE}" 'module.prop' -d $TMPDIR >&2 || abort "��ѹ��ʱ�ļ�����"
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
    abort "Chipid��ȡʧ��????"
  fi
  Hwmac=$(cat /sys/class/net/wlan0/address)
  input_string="${bindnumber}${serverinner}${chipid}${Hwmac}"
  hash=$(echo -n "$input_string" | sha256sum | awk '{print $1}')
  Ostring=${hash:0:8}
  OMODPATH=${MODPATH}.${string}
  dlog=$(get_config log)
  ddev=$(get_config developer)
  if [["$ddev" == "ture"]]; then
    ui_print "- [������]������ģʽ������"
    target_dev=10
  else
    target_dev=00
  fi
  if [[ "$dlog" == "ture" ]]; then
    Clog=1
    Flog="$TMPDIR/installer.log"
    touch ${Flog}
    ui_print "- [������]��־ģʽ������"
  else
    Clog=0
    Flog="/dev/null 2>&1"
  fi
  # ������ɫ����,����ANSIת������
  Red='\033[0;31m'
  Green='\033[0;32m'
  Yellow='\033[0;33m'
  Blue='\033[0;34m'
  NC='\033[0m' #Ĭ��
  # echo -e "${RED}Error:${NC} Something went wrong."  #�����ɫ�ַ���
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
          abort "! �ļ������ã��޷���ȡ�ı���"
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
    ui_print "- *��л���� - �Ա�ģ�������֧ˢ���������6000 ��!"
  else 
    ui_print "- *��л���� - �Ա�ģ�������֧ˢ���������${number}��!" 
    fi
  ui_print "#####################################################"
  if [ "$model" == I25 ];then
    ui_print "- ���Ļ���: Z7-${imoo_ver}_$produce.$API"
  elif [ "$model" == I32 ];then
      ui_print "- ���Ļ���: Z8&Z8�����-${imoo_ver}_$produce.$API"
      elif [ "$model" == I20 ];then
          ui_print "- ���Ļ���: Z6DFB-${imoo_ver}_$produce.$API"
          elif [ "$model" == I25A ];then
            ui_print "- ���Ļ���: Z7A-${imoo_ver}_$produce.$API"
              elif [ "$model" == I25C ];then
                  ui_print "- ���Ļ���: Z7S-${imoo_ver}_$produce.$API"
                  elif [ "$model" == ND07 ];then
                      ui_print "- ���Ļ���: Z8A-${imoo_ver}_$produce.$API"
                      elif [ "$model" == ND01 ];then
                          ui_print "- ���Ļ���: Z9&Z9�����-${imoo_ver}_$produce.$API"
                          elif [ "$model" == ND03 ];then
                                ui_print "- ���Ļ���: Z10-${imoo_ver}_$produce.$API"
                                abort "! ��֧�ִ�(Z10)����"
                  else
                    abort "! ��֧�ָû���-$model"
                    fi
  ui_print "- �����豸Ψһ��ʶ��: ${Ostring}"
  ui_print "- ������˽Э��,���ǽ���֤���ĵ�Ψһ��ʶ�����豸��Ϣ��������������;."
  ui_print "- ��˽Э��: gitee.com/baiyao105/jusvain_ui#��˽Э��"
  ui_print "- ʹ��Э��: gitee.com/baiyao105/jusvain_ui#ʹ��Э��"
  ui_print "- ��װλ��: $MODPATH"
  ui_print "######################################################"
}
module_validation(){
  if $BOOTMODE; then
    ui_print " - ��֤..."
    else
      ui_print "***************************"
      ui_print "! ��֧�ִ�Twrp��Ǳ�׼������װ"
      ui_print "! ���ᵼ�³��ַ�Ԥ���е����"
      ui_print "! ��ʹ��magsik23.0�����ϰ�װ"
      abort "! �Ǳ�׼����"
  fi
    if [[ "$KSU" == "true" ]]; then
      ui_print "- KernelSU �û��ռ䵱ǰ�İ汾��: $KSU_VER_CODE"
      ui_print "- KernelSU �ں˿ռ䵱ǰ�İ汾��: $KSU_KERNEL_VER_CODE"
      ui_print "- [KernelSU]�����?"
      elif [ "$MAGISK_VER_CODE" -lt 23000 ];then
        ui_print "! Magisk�汾����23.0: $MAGISK_VER_CODE����װ��ֹ��" 
        abort "!  Magisk�汾����23.0" 
      else
        ui_print " - Magisk�汾: $MAGISK_VER ($MAGISK_VER_CODE)"
    fi
  if [ "$API" -ne 27 ]; then
    ui_print "! ��׿�汾������: $API����װ��ֹ��"
    abort "! �豸SDKӦΪ27 (Android 8.1)"
  fi
  for f in /data/adb/modules/*/module.prop; do
    sed -i '/^priority=/d' "$f"
    done
}
check(){
# ��̽ģ��ṹ
nature_names=()
sky_imoo_names=()
for dir in /data/adb/modules/*/; do
  if [ -f "$dir/module.prop" ]; then
    if grep -q "����" "$dir/module.prop" || grep -q "Nature" "$dir/module.prop"; then
      name=$(grep_prop name "$dir/module.prop")
      id=$(grep_prop id "$dir/module.prop")
      if [ -n "$name" ]; then
        nature_names+=("$name")
        touch "$dir/disable"
        touch "$dir/skip_mount"
        echo "[����ģʽ] ���ù���ģ��'${name}_${id}'"
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
      ui_print "-���� [XTCPatch]Patch��Ϣ�������豸�̼�����"
      elif [ "$webstate" != "0" ]; then 
            verurl="https://vip.123pan.cn/1814215835/xtc_root/xtcp_$model.txt"
            zipurl="https://vip.123pan.cn/1814215835/xtc_root/xtcpatch_$model.zip"
            webver=$(curl -s $verurl)
          fi
          if [ "$patchver" != "$webver" ]; then
              ui_print "- [XTCPatch]�ƶ˰汾�����İ汾����[$webver]-[$patchver]"
              ui_print "- [XTCPatch]׼����ʼ����xtcpatch"
              curl -# ${zipurl} -o $TMPDIR/xtcpatch.zip
              ui_print "- [XTCPatch]��ʼ��װxtcpatch,�˹��̿�����Ҫ��Լ1min,�����ĵȴ�"
              magisk --install-module $TMPDIR/xtcpatch.zip >> ${Flog}
              patchver=$(getprop persist.xtcpatch.version)
              if [ "$patchver" == "$webver" ]; then
                  ui_print "- [XTCPatch]xtcpatch�������"
              else
                  ui_print "! [XTCPatch]xtcpatch����ʧ��"
              fi
          fi
fi
if [ ${#nature_names[@]} -gt 0 ]; then
  echo -n "- ����'Nature'��ģ�飺"
  printf "%s " "${nature_names[@]}"
  echo
fi
if [ ${#sky_imoo_names[@]} -gt 0 ]; then
  echo -n "- ���� 'Sky-iMoo' ��ģ�����ƣ�"
  printf "%s " "${sky_imoo_names[@]}"
  echo
fi
}
install(){
  if ["$Clog" = "1"];then
    move ${Flog} /sdcard/Android/Jusvain/ || abort " �ƶ�log�ļ�����"
  fi
  unzip -j -o "${ZIPFILE}" 'system/*' -d $MODPATH/system >&2 || abort "��ѹ�����ļ�����"
  unzip -j -o "${ZIPFILE}" 'common/post-fs-data.sh' -d $MODPATH >&2 || abort "��ѹ�ű�ʱ����"
  unzip -j -o "${ZIPFILE}" 'common/service.sh' -d $MODPATH >&2 || abort "��ѹ�ű�ʱ����"
  unzip -j -o "${ZIPFILE}" 'common/system.prop' -d $MODPATH >&2 || abort "��ѹ�ű�ʱ����"
  unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d $MODPATH >&2 || abort "��ѹ�����ļ�����"
  rm -rf $MODPATH/module.prop
  touch $MODPATH/module.prop
  echo "ro.Jusvain.ipmentId=${Ostring}" >>$MODPATH/system.prop
  echo "id=Jusvain_UI.${Ostring}" >$MODPATH/module.prop
  echo "name=Jusvain UI" >>$MODPATH/module.prop
  echo -n "version=V0.8.73_" >>$MODPATH/module.prop
  echo "${Ostring}" >>$MODPATH/module.prop
  echo "versionCode=0087320250101" >>$MODPATH/module.prop
  echo "author=����(@baiyao105)" >>$MODPATH/module.prop
  echo "description=JusvainUI����֧,��л����.�����豸��ʶ��: $string" >>$MODPATH/module.prop
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
    abort "MD5 �ļ�������"
  fi
  if [[ "$post_fs_data_md5" != "$Fmd5_post" ]]; then
    abort "post-fs-data��MD5��ƥ��,ģ����п�������,���������غ�װ"
  elif [[ "$service_md5" != "$Fmd5_service" ]]; then
    abort "Service��MD5��ƥ��,ģ����п�������,���������غ�װ"
  fi
}