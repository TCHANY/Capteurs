#!/bin/bash
#----------------------------------------------------RAM UTILISEE----------------------------------------------------
if [ "$1" = "" ] ; then
  echo -n "Nom du process : "
  read process
else
  process=$1
fi

ps aux | grep $process | grep -v grep | awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("Taille RAM utilisée: %s Mo\n",sum / 1024)}'


#--------------------------------------------------Temperature-----------------------------------------------------

while [ 1 ]
do
    tempGPU=$(aticonfig --od-gettemperature | awk -F " - " '{print $3}')
    notify-send "tempGPU" "$tempGPU"
    sleep 5
done

#ioreg -l | grep Temperature
#sysctl -a | awk -F ": " '/cpu_temp:/ {print $2}'
#------------------------------------------------Charge---------------------------------------------------------------
declare -i chargeTotale
nbC=25 #nombre de boucles à effectuer
while [ ${cycle:-0} -lt $nbC ]
do 
  charge=$(bc <<<"$charge + $(LC_NUMERIC=C uptime | awk -F':' '{sub(", .*","",$4; print $4}') )
   sleep 1
done
echo $charge

#top -n1 | grep 'Cpu(s)'| awk '{print $5;}' | sed -e 's/id,//g'

#------------------------------------------------Memoire----------------------------------------------
mem=$(FREE_SPACE=$((1024 * $ (df  -k  . | awk   ‘	NR == 2 { print  $4} ‘ ))))
echo "la memoire est $mem"
df  /home  | awk  ‘ { print $5 } ‘  |  tail  -n 1
#-----------------------------------------------Cpu+memoire------------------------------------------------------
res=$(ps -o pcpu,pmem -C processus)
#-----------------------------------------------Utilisateurs connectés--------------------------------------------------------				
uti=$(who | awk –F ‘’[ ()] ‘’ ‘{print $1, $(NF-1)}’)
echo "les utilisateurs connectés sont $uti"
#-----------------------------------------------temps allumé-----------------------------------------------------------------
temp=$(ps –eo etime | head –n 2 | tail –n 1 | cut –c-11)
echo "le temps allumé est $temp"

