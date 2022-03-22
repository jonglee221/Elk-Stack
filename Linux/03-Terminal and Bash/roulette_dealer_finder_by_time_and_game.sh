#!/bin/bash

if [ $1 = "Roulette" ]
then
	cat ${2}_Dealer_schedule | grep $3 | grep $4 | awk -F" " '{print $5,$6}'
fi

if [ $1 = "BlackJack" ]
then
	cat ${2}_Dealer_schedule | grep $3 | grep $4 | awk -F" " '{print $3,$4}'
fi

if [ $1 = "Texas_Hold_EM" ]
then
	cat ${2}_Dealer_schedule | grep $3 | grep $4 | awk -F" " '{print $7,$8}'
fi

