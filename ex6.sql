SELECT author, COUNT(reviewID) AS reviewCount FROM Reviews GROUP BY author HAVING reviewCount > 2 ORDER BY reviewCount DESC;
