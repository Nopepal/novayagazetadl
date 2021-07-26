#!/bin/sh
apiurl='https://novayagazeta.ru/api/v1/get/newspapers'
ngjson=$(curl -fs "$apiurl")
for i in $(seq 0 4)
do
	npurl=$(printf "%s" "$ngjson" | jq ".newspapers|.[${i}]|.pdfFile" | tr -d \")
	nptitle=$(printf "%s" "$ngjson" | jq ".newspapers|.[${i}]|.title" | tr -d \")
	wget -nc "$npurl" -O "${nptitle}.pdf"
done
