INSERT INTO Hotels
SELECT DISTINCT hotelID, hotelOverallRating, hotelAveragePrice, hotelURL
FROM HotelReviews;

INSERT INTO Reviews (hotelID, author, content, dateWritten, noReader, noHelpful, overallRating, value, rooms, location, cleanliness, checkIn_frontDesk, service, businessService) 
SELECT hotelID, author, content, dateWritten, noReader, noHelpful, overallRating, value, rooms, location, cleanliness, checkIn_frontDesk, service, businessService 
FROM HotelReviews;
