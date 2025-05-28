#!/bin/ash
# Installation script by ARYO.

DIR=/usr/bin
CONF=/etc/config
ETC=/etc/hotplug.d/dhcp
MODEL=/usr/lib/lua/luci/model/cbi
CON=/usr/lib/lua/luci/controller
URL=https://raw.githubusercontent.com/aryobrokollyy/Telegrambuset/main
URL2=https://raw.githubusercontent.com/saputribosen/punduk/main

retry_download() {
    local file_path=$1
    local url=$2
    local max_retries=5
    local attempt=1

    while [ $attempt -le $max_retries ]; do
        wget -O "$file_path" "$url"
        if [ -s "$file_path" ]; then
            echo "Download successful: $file_path"
            return 0
        else
            echo "Download failed or file size 0 KB. Retrying ($attempt/$max_retries)..."
            rm -f "$file_path"
            attempt=$((attempt + 1))
            sleep 2
        fi
    done

    echo "Failed to download $file_path after $max_retries attempts."
    echo "Check your internet connection and try again. Exiting."
    exit 1
}

install_telegram(){
    echo "Install telegram bot Aryo Brokolly"
    clear
    echo "Downloading files from repo.."
    
    retry_download "$MODEL/telegram_config.lua" "$URL/telegram_config.lua"
    retry_download "$DIR/telegram" "$URL/usr/bin/telegram"
    chmod +x "$DIR/telegram"
    
    retry_download "$CONF/telegram" "$URL/etc/config/telegram"
    retry_download "$CON/telegram.lua" "$URL/telegram.lua"
    chmod +x "$CON/telegram.lua"
    retry_download "$DIR/unmonfi" "$URL/unmonfi.sh"
    chmod +x "$DIR/unmonfi"

    clear
}

finish(){
    clear
    echo ""
    echo "INSTALL SUCCESSFULLY ;)"
    echo ""
    sleep 3
    echo "Youtube : ARYO BROKOLLY"
    echo ""
    sleep 5
    echo ""
}

download_files() {
    clear
    echo "Downloading files from repo.."
    
    retry_download "$ETC/99-device-detector" "$URL2/99-device-detector"
    chmod +x "$ETC/99-device-detector"
    
    finish
}
clear
echo ""
echo "============================================================================================="
echo "|| Install Deteksi Monitor Wifi Openwrt                                                     ||"
echo "|| Script ini berfungsi meneruskan informasi perangkat baru yang terkoneksi di OPENWRT kita.||"
echo "|| Dengan syarat dan ketentuan sesuai Tutorial di YOUTUBE                                   ||"
echo "|| A R Y O    B R O K O L L Y                                                               ||"
echo "============================================================================================="
echo ""
read -p "Sudah punya telegram bot (y/n)? " yn
case $yn in
    [Yy]* ) install_telegram;;
    [Nn]* ) echo "Skipping telegram bot installation...";;
    * ) echo "Invalid input. Skipping telegram bot installation...";;
esac

echo ""
echo "Install Script Detector Wifi Connect."

while true; do
    read -p "This will download the files. Do you want to continue (y/n)? " yn
    case $yn in
        [Yy]* ) download_files; break;;
        [Nn]* ) echo "Installation canceled. Ensure you have a stable internet connection before retrying."; exit;;
        * ) echo "Please answer 'y' or 'n'.";;
    esac
done
