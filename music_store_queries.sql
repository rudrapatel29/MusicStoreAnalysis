-- Who is the senior most employee based on job title?
SELECT *
FROM employee 
ORDER BY levels DESC
LIMIT 1;

-- Which countries have the most invoices?
SELECT COUNT(*) AS invoice_count, billing_country
FROM invoice
GROUP BY billing_country;

-- What are the top 3 values of total invoice?
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

-- Which city has the best customers? We would like to throw a promotional Music Festival in the city where we made the most money. 
-- Write a query that returns the city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals.
SELECT billing_city, SUM(total) AS invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;

-- Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_spending DESC
LIMIT 1;

-- Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.
SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN 
    (SELECT track_id 
     FROM track
     JOIN genre ON track.genre_id = genre.genre_id
     WHERE genre.name LIKE 'Rock')
ORDER BY email;

-- Method 2
SELECT DISTINCT email AS Email, first_name AS FirstName, last_name AS LastName, genre.name AS Genre
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

-- Write a query that returns the Artist name and total track count of the top 10 rock bands.
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON album.album_id = track.album_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC
LIMIT 10;

-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
SELECT track.name, track.milliseconds, ROUND(track.milliseconds / 60000, 2) AS minutes
FROM track
WHERE milliseconds > 
    (SELECT AVG(track.milliseconds) 
     FROM track)
ORDER BY track.milliseconds DESC;

-- We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared, return all Genres.
WITH popular_genre AS
(
    SELECT 
        COUNT(invoice_line.quantity) AS purchases, 
        customer.country, 
        genre.name, 
        genre.genre_id, 
        ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS rowno
    FROM invoice_line
    JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN customer ON customer.country = invoice.billing_country
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN genre ON genre.genre_id = track.genre_id
    GROUP BY customer.country, genre.name, genre.genre_id
    ORDER BY customer.country ASC, purchases DESC
)
SELECT * 
FROM popular_genre 
WHERE rowno <= 1;

