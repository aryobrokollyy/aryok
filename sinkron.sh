#!/bin/ash
# Installation script by ARYO.

DIR=/usr/bin
URL=https://raw.githubusercontent.com/aryobrokollyy/aryok/main/a_sync.sh
RCLOCAL=/etc/rc.local
STARTUP_CMD="sleep 20 && /usr/bin/a_sync.sh &"

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

add_to_startup() {
    # Cek apakah baris sudah ada
    if grep -Fxq "$STARTUP_CMD" "$RCLOCAL"; then
        echo "Startup entry already exists in $RCLOCAL"
    else
        # Sisipkan sebelum 'exit 0'
        sed -i "/exit 0/i $STARTUP_CMD" "$RCLOCAL"
        echo "Startup command added to $RCLOCAL"
    fi
}

finish() {
    clear
    echo ""
    echo "Auto Sinkron Jam saat restart"
    echo "Youtube : ARYO BROKOLLY"
    echo ""
    sleep 5
    echo ""
}

download_files() {
    clear
    echo "Downloading files from repo.."
    retry_download "$DIR/a_sync.sh" "$URL"
    chmod +x "$DIR/a_sync.sh"
    
    add_to_startup
    finish
}

echo ""
echo "Auto sinkron code from repo aryo."

while true; do
    read -p "This will download the files. Do you want to continue (y/n)? " yn
    case $yn in
        [Yy]* ) download_files; break;;
        [Nn]* ) echo "Installation canceled. Ensure you have a stable internet connection before retrying."; exit;;
        * ) echo "Please answer 'y' or 'n'.";;
    esac
done
