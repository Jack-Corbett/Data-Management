SELECT h.hotelID FROM Hotels h
INNER JOIN Reviews r on h.hotelID = r.hotelID GROUP BY h.hotelID
HAVING h.overallRating > 3 AND AVG(r.cleanliness) >= 4.5;
