/*	Question Set 1     */

/* Q1: Who is the senior most employee based on job title? */
SELECT *
FROM employee 
ORDER BY levels desc
LIMIT 1

/* Q2: Which countries have the most Invoices? */
SELECT COUNT(*), billing_country
FROM invoice
GROUP BY billing_country

/* Q3: What are top 3 values of total invoice? */
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT billing_country, SUM(total) AS Invoicetotal
FROM invoice
GROUP BY billing_country
ORDER BY invoicetotal
LIMIT 1

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_spending DESC
LIMIT 1;



/*      Question Set 2      */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/*Method 1 */

SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
where track_id in 
(
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like 'rock'
)
order by email


/* Method 2 */

SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoiceline ON invoiceline.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoiceline.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

/*Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
FROM artist
JOIN album2 on artist.artist_id = album2.artist_id
JOIN track on album2.album_id = track.album_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT track.name, track.milliseconds, ROUND(track.milliseconds / 60000, 2) AS minutes
FROM track
WHERE milliseconds >
     (SELECT AVG(track.milliseconds) as avg_length_of_song
     FROM track)
     ORDER BY track.milliseconds
     




