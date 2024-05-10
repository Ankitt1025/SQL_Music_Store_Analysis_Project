--who is the senior most employee based on the job title ?

select * from employee
order by levels desc
OFFSET 0 rows fetch next 5 rows only;

--which country have the most Invoices ?

select count(*) as TotalCount, billing_country
from invoice
group by billing_country
order by TotalCount desc
OFFSET 0 rows FETCH next 1 rows only;

--what are top 3 values of total invoice

select total from invoice
order by total desc
OFFSET 0 rows fetch next 3 rows only;

--which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city 
--that has the highest sum of invoice totals. Return both the city name & the sum of all invoice totals

select billing_city, sum(total) as total_invoice
from invoice
group by billing_city
order by total_invoice desc

--Who is the best customer? The customer who has spent the most money will be declared the best cutomer. Write a query that returns the person who has spent the most
--money.

select cust.customer_id, cust.first_name,cust.last_name, sum(total) as total_money
from customer cust
inner join invoice inv
on inv.customer_id = cust.customer_id
group by cust.customer_id,first_name,last_name
order by total_money desc
offset 0 rows fetch next 1 rows only;

--Write a query to return email,first name,last name,& Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
select first_name,last_name,email
from customer
inner join invoice 
on customer.customer_id = invoice.customer_id
inner join invoice_line inl
on inl.invoice_id = invoice.invoice_id
where track_id in (
	select track_id from track
	inner join genre 
	on track.genre_id = genre.genre_id
	where genre.name = 'Rock'
)
group by first_name,last_name,email
order by email


--Let's invite the artists who have the written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 
--rock bands

select artist.artist_id,artist.name,count(artist.artist_id) as totalcount
from track 
inner join album 
on track.album_id = album.album_id
inner join artist
on album.artist_id = artist.artist_id
inner join genre
on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.artist_id,artist.name
order by totalcount desc
offset 0 rows fetch next 10 rows only;

--alternate method
select artist.name,count(artist.name) as totalcount
from track 
inner join album 
on track.album_id = album.album_id
inner join artist
on album.artist_id = artist.artist_id
inner join genre
on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.name
order by totalcount desc
offset 0 rows fetch next 10 rows only;

--Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length
--with the longest songs listed first.

select name,milliseconds
from track
where milliseconds > (
	select avg(milliseconds) as average
	from track)
--group by name,milliseconds
order by milliseconds desc
