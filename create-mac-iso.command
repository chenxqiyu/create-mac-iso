#!/bin/bash
#===========================================================================
# 仅适用于Mac App Store提供的官方镜像。
# 确保在运行此脚本之前下载官方安装程序。
#===========================================================================

# 提示用户输入所需磁盘大小
read -p "请输入磁盘大小（以千兆字节为单位，默认为 15G）: " DISK_SIZE
DISK_SIZE=${DISK_SIZE:-15G}  # 默认值改成 15G


read -p "1.打开pkg安装，2.打开访达-应用程序-拖动Installxxx.app到终端（例如，/Applications/Install\ macOS\ Sonoma.app）: " INSTALL_NAME
INSTALL_NAME=${INSTALL_NAME:-/Applications/Install\ macOS\ Sonoma.app}

INSTALL_NAME=$(basename "$INSTALL_NAME" .app)
echo $INSTALL_NAME

# 提示用户是否将 dmg 转换为 iso，默认为 'y'
read -p "是否将 dmg 转换为 iso？(y/n，默认为 y): " CONVERT_TO_ISO
CONVERT_TO_ISO=${CONVERT_TO_ISO:-y}
echo "制作中。。。。"
#===========================================================================

hdiutil create -o /tmp/"$INSTALL_NAME".cdr -size $DISK_SIZE -layout SPUD -fs HFS+J
hdiutil attach /tmp/"$INSTALL_NAME".cdr.dmg -noverify -mountpoint "/Volumes/$INSTALL_NAME"
sudo "/Applications/$INSTALL_NAME.app/Contents/Resources/createinstallmedia"  --volume "/Volumes/$INSTALL_NAME" --nointeraction
hdiutil detach "/Volumes/Shared Support"
hdiutil detach "/Volumes/$INSTALL_NAME"

if [ "$CONVERT_TO_ISO" == "y" ]; then
  hdiutil convert /tmp/"$INSTALL_NAME".cdr.dmg -format UDTO -o /tmp/"$INSTALL_NAME".iso
  mv /tmp/"$INSTALL_NAME".iso.cdr ~/Desktop/"$INSTALL_NAME".iso
else
  mv /tmp/"$INSTALL_NAME".cdr.dmg ~/Desktop/"$INSTALL_NAME".dmg
fi

# 删除临时文件
rm -f /tmp/"$INSTALL_NAME".cdr.dmg

