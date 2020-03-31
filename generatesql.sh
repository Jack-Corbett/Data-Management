#!/bin/bash

#Set the internal field seperator to the new lines and return special characters. This prevents data entries with spaces being split over multiple lines when using grep.
IFS=$'\n\r';

{
	#First drop the current table from the database and then recreate the table
	echo "DROP TABLE IF EXISTS 'HotelReviews';"
	echo "CREATE TABLE 'HotelReviews' ('hotelID' integer, 'hotelOverallRating' tinyint, 'hotelAveragePrice' integer, 'hotelURL' varchar(1000), 'author' varchar(20), 'content' text, 'dateWritten' date, 'noReader' integer, 'noHelpful' integer, 'overallRating' tinyint, 'value' tinyint, 'rooms' tinyint, 'location' tinyint, 'cleanliness' tinyint, 'checkIn_frontDesk' tinyint, 'service' tinyint, 'businessService' tinyint, PRIMARY KEY('hotelID', 'author', 'content'));"
} > hotelreviews.sql;

#Loop through each hotel data file
for file in $1/*.dat;
do
	#First store the id, overallRating, averagePrice and URL as these will be the same for that file. Trimming off new line characters.
	hotelID=$(echo "$file" | sed "s/.*hotel_//; s/.dat//");
	hotelOverallRating=$(grep "<Overall Rating>" $file | sed "s/<Overall Rating>//" | tr -d '\n\r');
	#For the average price we also have to trim Unkonwn as this is found in data file 93230
	hotelAveragePrice=$(grep "<Avg. Price>" $file | sed "s/<Avg. Price>//" | tr -d '$\n\rUnkonwn,');
	#Use regex to add speech marks if the URL tag is found, this ensures nulls are submitted correctly
	hotelURL=$(grep "<URL>" $file | sed "s/<URL>\(.*\)$/'\1'/" | tr -d '\n\r');

	#There are multiple entries for the following variables per data file so grep is used to add each to an array.
	#This makes it easy to iterate through when creating our insert array
	author=($(grep "<Author>" $file | sed "s/<Author>//" | tr -d \'\"));
	content=($(grep "<Content>" $file | sed "s/<Content>//" | tr -d \'\"));
	#The date command reformats the date to abide by SQLite formatting
	date=($(grep "<Date>" $file | sed "s/<Date>//" | date +"%Y-%m-%d" -f -));
	noReader=($(grep "<No. Reader>" $file | sed "s/<No. Reader>//; s/-1/NULL/"));
	noHelpful=($(grep "<No. Helpful>" $file | sed "s/<No. Helpful>//; s/-1/NULL/"));
	overall=($(grep "<Overall>" $file | sed "s/<Overall>//; s/-1/NULL/"));
	value=($(grep "<Value>" $file | sed "s/<Value>//; s/-1/NULL/"));
	rooms=($(grep "<Rooms>" $file | sed "s/<Rooms>//; s/-1/NULL/"));
	location=($(grep "<Location>" $file | sed "s/<Location>//; s/-1/NULL/"));
	cleanliness=($(grep "<Cleanliness>" $file | sed "s/<Cleanliness>//; s/-1/NULL/"));
	checkInFrontDesk=($(grep "<Check in / front desk>" $file | sed "s/<Check in \/ front desk>//; s/-1/NULL/"));
	service=($(grep "<Service>" $file | sed "s/<Service>//; s/-1/NULL/"));
	businessService=($(grep "<Business service>" $file | sed "s/<Business service>//; s/-1/NULL/"));

	#Now all the data has been read from the hotel.dat file we can count up to the size of the author array (representing the number of reviews)
	#Echoing each value and using the default operator to write NULL if the variable has not been assigned
	for ((i=0;i<${#author[@]};i++));
	do
		echo "INSERT INTO 'HotelReviews' VALUES ($hotelID,${hotelOverallRating:-NULL},${hotelAveragePrice:-NULL},${hotelURL:-NULL},'${author[$i]}','${content[$i]}','${date[$i]}',${noReader[$i]:-NULL},${noHelpful[$i]:-NULL},${overall[$i]:-NULL},${value[$i]:-NULL},${rooms[$i]:-NULL},${location[$i]:-NULL},${cleanliness[$i]:-NULL},${checkInFrontDesk[$i]:-NULL},${service[$i]:-NULL},${businessService[$i]:-NULL});" >> hotelreviews.sql;
	done
done
