#!/bin/sh
newspaper_directory="."

fromissue=1
toissue=31
while getopts f:t:d: option
do
        case "${option}"
                in
                f) fromissue=${OPTARG};;
                t) toissue=${OPTARG};;
                d) newspaper_directory=${OPTARG};;
        esac
done
limit=$(($toissue - $fromissue + 1))
offset=$(($fromissue - 1))
[ $offset -lt 0 ] && exit 1
[ $limit -lt 1 ] && exit 1
apiurl="https://novayagazeta.ru/api/v1/get/newspapers?limit=${limit}&offset=${offset}"
ngjson=$(wget -q -O - "$apiurl")
for i in $(seq 0 $(($limit - 1)))
do
        npurl=$(printf "%s" "$ngjson" | jq ".newspapers|.[${i}]|.pdfFile" | tr -d \")
        nptitle=$(printf "%s" "$ngjson" | jq ".newspapers|.[${i}]|.title" | tr -d \")
        wget -nc "$npurl" -O "${newspaper_directory}/${nptitle}.pdf"
done
