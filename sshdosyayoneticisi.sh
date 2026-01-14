#!/bin/bash

if [ "$1" == "--gui" ]
then
    BAGLANTIBILGILERI=$(yad --form --center --title="SSH Dosya Yöneticisi" --width=400 --height=300 --borders=40 --field="Sunucu" "" --field="Port" "22" --field="Kullanıcı" "" --field="Şifre:H" "" --button="Bağlan")

    if [ $? -ne 0 ]
    then
        exit
    fi

    IFS="|" read -r SUNUCU PORT KULLANICI SIFRE <<< "$BAGLANTIBILGILERI"
elif [ "$1" == "--tui" ]
then
    SUNUCU=$(whiptail --title="SSH Dosya Yöneticisi" --inputbox "Sunucu:" 10 50 "" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]
    then
        exit
    fi
    PORT=$(whiptail --title="SSH Dosya Yöneticisi" --inputbox "Port:" 10 50 "22" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]
    then
        exit
    fi
    KULLANICI=$(whiptail --title="SSH Dosya Yöneticisi" --inputbox "Kullanıcı:" 10 50 "" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]
    then
        exit
    fi
    SIFRE=$(whiptail --title="SSH Dosya Yöneticisi" --passwordbox "Şifre:" 10 50 "" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]
    then
        exit
    fi
fi

KONTROLYOLU="/tmp/ssh_${SUNUCU}_${PORT}_${KULLANICI}"

DIZIN=$(sshpass -p "$SIFRE" ssh -M -o ControlMaster=yes -o ControlPersist=30m -o ControlPath="$KONTROLYOLU" -p "$PORT" "$KULLANICI@$SUNUCU" "pwd")

if [ $? -ne 0 ]
then
    if [ "$1" == "--gui" ]
    then
        yad --error --center --title="SSH Dosya Yöneticisi" --width=400 --borders=40 --text="SSH bağlantısı kurulamadı." --button="Tamam"
    elif [ "$1" == "--tui" ]
    then
        whiptail --title="SSH Dosya Yöneticisi" --msgbox "SSH bağlantısı kurulamadı." 10 50
    fi
    exit
fi

while true
do
    if [ "$1" == "--gui" ]
    then
        SECIM=$((echo ".."; ssh -o ControlPath="$KONTROLYOLU" -p "$PORT" "$KULLANICI@$SUNUCU" "cd \"$DIZIN\" && ls") | yad --list --center --title="SSH Dosya Yöneticisi" --width=1000 --height=600 --borders=20 \
        --text="$DIZIN\n" --no-headers --column=Ad --button="Aç:0" --button="Yeniden Adlandır:2" --button="Sil:4" --button="Yerel Bilgisayara Aktar:6" --button="Karşıya Dosya Gönder:8" --separator="")
        ISLEM=$(( $? / 2 + 1 ))
    elif [ "$1" == "--tui" ]
    then
        LISTE=$(ssh -o ControlPath="$KONTROLYOLU" -p "$PORT" "$KULLANICI@$SUNUCU" "cd \"$DIZIN\" && ls")
        MENU=".. ..."

        for AD in $LISTE
        do
            MENU="$MENU $AD ..."
        done

        SECIM=$(whiptail --title="SSH Dosya Yöneticisi" --menu "$DIZIN" 25 80 15 $MENU 3>&1 1>&2 2>&3)

        if [ "$?" -ne 0 ]
        then
            break
        fi

        ISLEM=$(whiptail --title="SSH Dosya Yöneticisi" --menu "Yapılacak işlemi seçin." 15 60 6 "1" "Aç" "2" "Yeniden Adlandır" "3" "Sil" "4" "Yerel Bilgisayara Aktar" "5" "Karşıya Dosya Gönder" 3>&1 1>&2 2>&3)
    fi

    if [ "$ISLEM" -eq 1 ]
    then
        TUR=$(ssh -o ControlPath="$KONTROLYOLU" -p "$PORT" "$KULLANICI@$SUNUCU" "cd \"$DIZIN\" && [ -d \"$SECIM\" ] && echo dizin")
        if [ "$TUR" = "dizin" ]
        then
            if [ "$SECIM" = ".." ]
            then
                DIZIN=$(dirname "$DIZIN")
            else
                if [ "$DIZIN" = "/" ]
                then
                    DIZIN="/$SECIM"
                else
                    DIZIN="$DIZIN/$SECIM"
                fi
            fi
        else
            GECICI=$(mktemp)
            scp -o ControlPath="$KONTROLYOLU" -P "$PORT" "$KULLANICI@$SUNUCU:$DIZIN/$SECIM" "$GECICI"
            if [ "$1" == "--gui" ]
            then
                TIP=$(file --mime-type -b "$GECICI")
                if [[ "$TIP" == image/* ]]
                then
                    yad --picture --center --title="$SECIM" --width=1000 --height=600 --borders=20 --filename="$GECICI" --button="Kapat"
                else
                    yad --text-info --center --title="$SECIM" --width=1000 --height=600 --borders=20 --filename="$GECICI" --button="Kapat"
                fi
            elif [ "$1" == "--tui" ]
            then
                whiptail --title="$SECIM" --textbox $GECICI 30 100
            fi
            rm -f "$GECICI"
        fi
    elif [ "$ISLEM" -eq 2 ]
    then
        if [ "$1" == "--gui" ]
        then
            AD=$(yad --entry --center --title="Yeniden Adlandır" --width=400 --borders=40 --text="Yeni ad:" --entry-text="$SECIM" --button="Yeniden Adlandır" --button="İptal")
        elif [ "$1" == "--tui" ]
        then
            AD=$(whiptail --title="Yeniden Adlandır" --inputbox "Yeni ad:" 10 50 "$SECIM" 3>&1 1>&2 2>&3)
        fi
        if [ $? -eq 0 ]
        then
            ssh -o ControlPath="$KONTROLYOLU" -p "$PORT" "$KULLANICI@$SUNUCU" "cd \"$DIZIN\" && mv \"$SECIM\" \"$AD\""
        fi
    elif [ "$ISLEM" -eq 3 ]
    then
        if [ "$1" == "--gui" ]
        then
            yad --question --center --title="Sil" --width=400 --borders=40 --text="$SECIM öğesini silmek istediğinize emin misiniz?" --button="Sil" --button="İptal"
        elif [ "$1" == "--tui" ]
        then
            whiptail --title="Sil" --yesno "$SECIM öğesini silmek istediğinize emin misiniz?" 10 60
        fi
        if [ $? -eq 0 ]
        then
            ssh -o ControlPath="$KONTROLYOLU" -p "$PORT" "$KULLANICI@$SUNUCU" "cd \"$DIZIN\" && rm \"$SECIM\""
        fi
    elif [ "$ISLEM" -eq 4 ]
    then
        if [ "$1" == "--gui" ]
        then
            KONUM=$(yad --file --save --center --title="Yerel Bilgisayarda Kaydedilecek Konumu Seç" --width=1000 --height=600 --borders=20 --filename="$SECIM" --button "Konumu Seç" --button "İptal")
        elif [ "$1" == "--tui" ]
        then
            KONUM=$(whiptail --title="Yerel Bilgisayarda Kaydedilecek Konumu Seç" --inputbox "Dizin yolu:" 10 70 "$SECIM" 3>&1 1>&2 2>&3)
        fi
        if [ $? -eq 0 ]
        then
            scp -o ControlPath="$KONTROLYOLU" -P "$PORT" "$KULLANICI@$SUNUCU:$DIZIN/$SECIM" "$KONUM"
        fi
    elif [ "$ISLEM" -eq 5 ]
    then
        if [ "$1" == "--gui" ]
        then
            DOSYA=$(yad --file --center --title="Karşıya Gönderilecek Dosyayı Seç" --width=1000 --height=600 --borders=20 --button "Dosyayı Seç" --button "İptal")
        elif [ "$1" == "--tui" ]
        then
            DOSYA=$(whiptail --title="Karşıya Gönderilecek Dosyayı Seç" --inputbox "Dosya yolu:" 10 70 "" 3>&1 1>&2 2>&3)
        fi
        if [ $? -eq 0 ]
        then
            scp -o ControlPath="$KONTROLYOLU" -P "$PORT" "$DOSYA" "$KULLANICI@$SUNUCU:$DIZIN"
        fi
    else
        if [ "$1" == "--gui" ]
        then
            break
        fi
    fi
done

ssh -O exit -o ControlPath="$KONTROLYOLU" "$KULLANICI@$SUNUCU"

