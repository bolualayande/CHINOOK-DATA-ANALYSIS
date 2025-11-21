#TOP COUNTRY BY REVENUE 
SELECT 
   billing_country,
   COALESCE (SUM(total),0) AS total_revenue
FROM invoice
GROUP BY billing_country
ORDER BY total_revenue DESC
LIMIT 5; 


#TOP 10 SPENDING CUSTOMERS 
SELECT 
       customer.customer_id,
       first_name,
	   last_name, 
	   SUM(invoice.total) AS top_spending
FROM customer
INNER JOIN invoice 
     ON invoice.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY top_spending DESC
LIMIT 10;


#BEST SELLING GENRE
SELECT 
   genre.name,  
   SUM (invoice_line.unit_price * invoice_line.quantity) AS top_genre 
FROM genre
JOIN track 
     ON genre.genre_id = track.genre_id
JOIN invoice_line
     ON invoice_line.track_id = track.track_id
GROUP BY genre.name
ORDER BY top_genre DESC
LIMIT 5;

#MOST PURCHASED ARTISTS - TOP 10 
SELECT artist.name, 
      SUM (invoice_line.unit_price * invoice_line.quantity) AS top_artist
FROM artist
INNER JOIN album 
      ON artist.artist_id = album.artist_id
INNER JOIN track
      ON track.album_id = album.album_id
INNER JOIN invoice_line
       ON invoice_line.track_id = track.track_id
GROUP BY artist.name 
ORDER BY top_artist DESC
LIMIT 10;


#REVENUE ACCROSS MEDIA TYPES 
SELECT media_type.name, 
    SUM (invoice_line.unit_price * invoice_line.quantity) AS rev_by_media_type 
FROM media_type
FULL JOIN track
     ON track.media_type_id = media_type.media_type_id
FULL JOIN invoice_line
     ON invoice_line.track_id = track.track_id
GROUP BY media_type.name
ORDER BY rev_by_media_type DESC;


#REVENUE BY MONTHLY TREND 
SELECT DATE_TRUNC ('month', invoice_date) :: date 
      AS monthly_trend,
        ROUND(SUM(invoice_line.unit_price * invoice_line.quantity),2) 
		  AS total_revenue
FROM invoice
JOIN invoice_line
     ON invoice_line.invoice_id = invoice.invoice_id
GROUP BY 1
ORDER BY 1;


#COUNTRY SPENDING ANALYSIS 
SELECT  
    country,
	SUM (invoice_line.unit_price * invoice_line.quantity) 
	    AS total_spend,
	COUNT(DISTINCT customer.customer_id) 
	    AS amount_of_customers,
	ROUND(SUM (invoice_line.unit_price * invoice_line.quantity)
	/COUNT(DISTINCT customer.customer_id))
	    AS avg_spend_per_customer 
FROM customer
JOIN invoice
     ON customer.customer_id = invoice.customer_id
JOIN invoice_line
      ON invoice.invoice_id = invoice_line.invoice_id
GROUP BY country
ORDER BY amount_of_customers DESC;


#BREAKDOWN OF COMPOSER SALES BY TRACK PRICE
SELECT DISTINCT 
   composer,
   track.unit_price AS price_of_track,
   SUM(invoice_line.quantity) AS total_units
FROM track
JOIN invoice_line
     ON track.track_id = invoice_line.track_id
GROUP BY track.unit_price, composer
ORDER BY track.unit_price;




