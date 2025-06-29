create database OLA_project;
use OLA_project;

CREATE TABLE RideBookings (
    booking_date DATE,
    booking_time TIME,
    booking_id VARCHAR(20),
    booking_status VARCHAR(20),
    customer_id INT,
    vehicle_type VARCHAR(50),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    avg_vtat FLOAT,
    avg_ctat FLOAT,
    cancelled_by_customer VARCHAR(5),
    cancelled_by_driver VARCHAR(5),
    incomplete_rides VARCHAR(5),
    incomplete_rides_reason VARCHAR(50),
    booking_value INT,
    ride_distance FLOAT,
    driver_rating FLOAT,
    customer_rating FLOAT
);

LOAD DATA LOCAL INFILE "C:\Users\virat\Desktop\Imarticus capstone project\Bangalore_Ride_Data_Jul_Sep_2024.csv"
INTO TABLE Ridebookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ridebookings;
desc ridebookings;

 -- How many rides were successful vs incomplete?
SELECT booking_status, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY booking_status;

-- What is the average booking value and ride distance per vehicle type?
SELECT vehicle_type, AVG(booking_value) AS avg_value, AVG(ride_distance) AS avg_distance
FROM RideBookings
GROUP BY vehicle_type;


-- What are the average driver and customer ratings per vehicle type?

SELECT vehicle_type, AVG(driver_rating) AS avg_driver_rating, AVG(customer_rating) AS avg_customer_rating
FROM RideBookings
GROUP BY vehicle_type;

-- Which are the top 5 pickup locations by number of bookings?
SELECT pickup_location, COUNT(*) AS num_bookings
FROM RideBookings
GROUP BY pickup_location
ORDER BY num_bookings DESC
LIMIT 5;

-- What is the percentage of rides cancelled by customers vs drivers?
SELECT
    SUM(CASE WHEN cancelled_by_customer = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS pct_canceled_by_customer,
    SUM(CASE WHEN cancelled_by_driver = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS pct_canceled_by_driver
FROM RideBookings;

-- What is the average CTAT and VTAT per vehicle type?
SELECT vehicle_type, AVG(avg_ctat) AS avg_ctat, AVG(avg_vtat) AS avg_vtat
FROM RideBookings
GROUP BY vehicle_type;

-- Which customers had more than 3 incomplete rides?
SELECT customer_id, COUNT(*) AS incomplete_count
FROM RideBookings
WHERE booking_status = 'Incomplete'
GROUP BY customer_id
HAVING incomplete_count > 3;

-- What is the average booking value per month?
SELECT MONTH(booking_date) AS month, AVG(booking_value) AS avg_booking_value
FROM RideBookings
GROUP BY month
ORDER BY month;

-- What is the average ride distance by hour of the day?
SELECT HOUR(booking_time) AS booking_hour, AVG(ride_distance) AS avg_distance
FROM RideBookings
GROUP BY booking_hour
ORDER BY booking_hour;

--  What are the most common reasons for incomplete rides?
SELECT incomplete_rides_reason, COUNT(*) AS num_rides
FROM RideBookings
WHERE booking_status = 'Incomplete'
GROUP BY incomplete_rides_reason
ORDER BY num_rides DESC;


-- What is the total revenue generated per vehicle type?
SELECT vehicle_type, SUM(booking_value) AS total_revenue
FROM RideBookings
GROUP BY vehicle_type
ORDER BY total_revenue DESC;


-- Which rides have the highest driver rating?
SELECT *
FROM RideBookings
WHERE driver_rating = (SELECT MAX(driver_rating) FROM RideBookings);

 -- Which rides had a long wait time (CTAT > 15)?
 SELECT *
FROM RideBookings
WHERE avg_ctat > 15;

-- How many rides happened on each day of the week?

SELECT DAYNAME(booking_date) AS day_of_week, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- What is the average booking value for rides over 20 km?

SELECT AVG(booking_value) AS avg_value_long_rides
FROM RideBookings
WHERE ride_distance > 20;


-- Which customers consistently book high-value rides (value > 300)?
SELECT DISTINCT customer_id
FROM RideBookings
WHERE booking_value > 300;

--  How many rides per drop location?
SELECT drop_location, COUNT(*) AS num_rides
FROM RideBookings
GROUP BY drop_location
ORDER BY num_rides DESC;


-- Which vehicle types have the lowest average driver ratings?
SELECT vehicle_type, AVG(driver_rating) AS avg_driver_rating
FROM RideBookings
GROUP BY vehicle_type
ORDER BY avg_driver_rating ASC
LIMIT 3;


-- What is the proportion of incomplete rides overall?
SELECT (SUM(CASE WHEN booking_status = 'Incomplete' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS incomplete_percentage
FROM RideBookings;

-- SELECT vehicle_type, SUM(ride_distance) AS total_distance
SELECT vehicle_type, SUM(ride_distance) AS total_distance
FROM RideBookings
GROUP BY vehicle_type
ORDER BY total_distance DESC;

-- What are the monthly ride counts?
SELECT YEAR(booking_date) AS year, MONTH(booking_date) AS month, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY year, month
ORDER BY year, month;

-- What is the average booking value for successful vs incomplete rides?
SELECT booking_status, AVG(booking_value) AS avg_value
FROM RideBookings
GROUP BY booking_status;

-- How many rides have both driver and customer ratings above 4?
SELECT COUNT(*) AS high_rating_rides
FROM RideBookings
WHERE driver_rating > 4 AND customer_rating > 4;

-- What are the average CTAT and VTAT per weekday?

SELECT DAYNAME(booking_date) AS day_of_week, AVG(avg_ctat) AS avg_ctat, AVG(avg_vtat) AS avg_vtat
FROM RideBookings
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- Which customers are considered loyal (more than 5 rides)?
SELECT customer_id, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY customer_id
HAVING ride_count > 5
ORDER BY ride_count DESC;


-- How many short rides (< 5 km) are there per vehicle type?
SELECT vehicle_type, COUNT(*) AS short_ride_count
FROM RideBookings
WHERE ride_distance < 5
GROUP BY vehicle_type
ORDER BY short_ride_count DESC;










