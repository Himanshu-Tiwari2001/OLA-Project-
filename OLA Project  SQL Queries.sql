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

-- modifications 
ALTER TABLE RideBookings
MODIFY cancelled_by_customer VARCHAR(100),
MODIFY cancelled_by_driver VARCHAR(100),
MODIFY   booking_status VARCHAR(70);

-- change the data type of customer_id  from INT to STRING
ALTER TABLE RideBookings
MODIFY COLUMN customer_id VARCHAR(255);



-- cleaning the dataset
UPDATE RideBookings
SET avg_ctat  = 0
WHERE avg_ctat IS NULL OR avg_ctat = '';


UPDATE RideBookings
SET avg_vtat  = 0
WHERE avg_ctat IS NULL OR avg_vtat = '';




UPDATE RideBookings
SET customer_id = CONCAT('CID', customer_id);

Select * from RideBookings;


 -- How many rides were successful vs incomplete?
SELECT booking_status, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY booking_status;

-- What is the average booking value and ride distance per vehicle type?
SELECT vehicle_type, round(AVG(booking_value) ,2) AS avg_value, round(AVG(ride_distance) ,2) AS avg_distance
FROM RideBookings
GROUP BY vehicle_type;


-- What are the average driver and customer ratings per vehicle type?

SELECT vehicle_type, round(AVG(driver_rating),2)  AS avg_driver_rating, round(AVG(customer_rating),2) AS avg_customer_rating
FROM RideBookings
GROUP BY vehicle_type;

-- Which are the top 5 pickup locations by number of bookings?
SELECT pickup_location, COUNT(*) AS num_bookings
FROM RideBookings
GROUP BY pickup_location
ORDER BY num_bookings DESC
LIMIT 5;

-- What is the percentage of rides cancelled by customers vs drivers?

WITH total_booking AS (
    SELECT COUNT(*) AS total FROM RideBookings
),
customer_cancels AS (
    SELECT COUNT(*) AS canceled_by_customer
    FROM RideBookings
    WHERE booking_status ="Cancelled by Customer"
),
driver_cancels AS (
    SELECT COUNT(*) AS canceled_by_driver
    FROM RideBookings
    WHERE booking_status ="Cancelled by Driver"
)
SELECT
    (customer_cancels.canceled_by_customer / total_booking.total) * 100 AS pct_canceled_by_customer,
    (driver_cancels.canceled_by_driver / total_booking.total) * 100 AS pct_canceled_by_driver
FROM total_booking, customer_cancels, driver_cancels;







-- What is the average CTAT and VTAT per vehicle type?
SELECT vehicle_type, round(AVG(avg_ctat),2) AS avg_ctat, round(AVG(avg_vtat) ,2) AS avg_vtat
FROM RideBookings
GROUP BY vehicle_type;

-- Which 5 customers had 2 incomplete rides?
SELECT customer_id, COUNT(*) AS incomplete_count
FROM RideBookings
WHERE booking_status = 'Incomplete'
GROUP BY customer_id
ORDER BY  incomplete_count DESC
LIMIT 5;


-- What is the sum of  booking value per month?
SELECT monthname((booking_date)) AS month, SUM(booking_value) AS avg_booking_value
FROM RideBookings
GROUP BY month
ORDER BY month;

-- What is the top 5 peak  ride distance by hour of the day?
SELECT HOUR(booking_time) AS booking_hour, round(AVG(ride_distance) ,2)AS avg_distance
FROM RideBookings
GROUP BY booking_hour
ORDER BY avg_distance DESC
LIMIT 5;

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

--  Top 5 ride count   per drop location?
SELECT drop_location, COUNT(*) AS num_rides
FROM RideBookings
GROUP BY drop_location
ORDER BY num_rides DESC
LIMIT 5;


-- Which vehicle types have the lowest average driver ratings?
SELECT vehicle_type, round(AVG(driver_rating),2) AS avg_driver_rating
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
HAVING ride_count > 4
ORDER BY ride_count DESC;


-- How many short rides (< 5 km) are there per vehicle type?
SELECT vehicle_type, COUNT(*) AS short_ride_count
FROM RideBookings
WHERE ride_distance < 5
GROUP BY vehicle_type
ORDER BY short_ride_count DESC;

--  Find customers whose average booking value is higher than the overall average
SELECT customer_id, AVG(booking_value) AS avg_booking_value
FROM RideBookings
GROUP BY customer_id
HAVING AVG(booking_value) > (SELECT AVG(booking_value) FROM RideBookings);

 -- Identify vehicle types that have a higher than average cancellation rate by drivers
 SELECT vehicle_type,
       SUM(CASE WHEN cancelled_by_driver = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS driver_cancellation_pct
FROM RideBookings
GROUP BY vehicle_type
HAVING driver_cancellation_pct > (
    SELECT SUM(CASE WHEN cancelled_by_driver = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 FROM RideBookings
);

-- Find the top 3 drop locations for each vehicle type
WITH RankedRides AS (
    SELECT 
        vehicle_type, 
        drop_location, 
        COUNT(*) AS ride_count,
        ROW_NUMBER() OVER (PARTITION BY vehicle_type ORDER BY COUNT(*) DESC) AS rank_num
    FROM RideBookings
    GROUP BY vehicle_type, drop_location
)
SELECT 
    vehicle_type, 
    drop_location, 
    ride_count
FROM RankedRides
WHERE rank_num <= 1;

-- Calculate the percentage of high-rated rides (driver and customer both > 4) per vehicle type
SELECT vehicle_type,
       SUM(CASE WHEN driver_rating > 4 AND customer_rating > 4 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS high_rating_pct
FROM RideBookings
GROUP BY vehicle_type
ORDER BY high_rating_pct DESC;


-- Find customers who have both high total spending and high average driver rating

SELECT customer_id,
       SUM(booking_value) AS total_spent,
       round(AVG(driver_rating) ,2) AS avg_driver_rating
FROM RideBookings
GROUP BY customer_id
HAVING total_spent > 1000 AND avg_driver_rating > 4.0
ORDER BY total_spent DESC;


-- Detect potential churn risk: customers with recent incomplete rides and low average ratings
SELECT customer_id,
       COUNT(*) AS incomplete_rides,
       round(AVG(customer_rating),2) AS avg_rating
FROM RideBookings
WHERE booking_status = 'Incomplete'
GROUP BY customer_id
ORDER BY incomplete_rides DESC
LIMIT 5;


-- Compare CTAT trends by vehicle type over months
SELECT vehicle_type, monthname((booking_date)) AS month, 
round(AVG(avg_ctat) ,2) AS avg_ctat
FROM RideBookings
GROUP BY vehicle_type, month
ORDER BY vehicle_type, month;


--  Find top 5 customers by total distance traveled
SELECT customer_id, round(SUM(ride_distance) ,2)AS total_distance
FROM RideBookings
GROUP BY customer_id
ORDER BY total_distance DESC
LIMIT 5;

-- Get hourly ride distribution
SELECT DAYNAME(booking_date) AS day_of_week, HOUR(booking_time) AS hour_of_day, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY day_of_week, hour_of_day
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), hour_of_day;


-- find top 5 most frequent routes (pickup → drop)
WITH route_counts AS (
  SELECT pickup_location, drop_location, COUNT(*) AS ride_count
  FROM RideBookings
  GROUP BY pickup_location, drop_location
)
SELECT *
FROM route_counts
ORDER BY ride_count DESC
LIMIT 5;


-- calculate monthly revenue per vehicle type, then find top performer
WITH monthly_revenue AS (
  SELECT vehicle_type, MONTH(booking_date) AS month, SUM(booking_value) AS total_revenue
  FROM RideBookings
  GROUP BY vehicle_type, month
),
ranked_revenue AS (
  SELECT *, RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS rank_num
  FROM monthly_revenue
)
SELECT *
FROM ranked_revenue
WHERE rank_num = 1;

-- find customers with ride counts and their average CTAT
WITH customer_summary AS (
  SELECT customer_id, COUNT(*) AS total_rides, AVG(avg_ctat) AS avg_ctat
  FROM RideBookings
  GROUP BY customer_id
)
SELECT *
FROM customer_summary;

--  get average ratings and flag underperforming vehicle types
WITH rating_summary AS (
  SELECT vehicle_type,
         round (AVG(driver_rating),2) AS avg_driver_rating,
         round(AVG(customer_rating) ,2)AS avg_customer_rating
  FROM RideBookings
  GROUP BY vehicle_type
)
SELECT *,
       CASE 
           WHEN avg_driver_rating < 3.5 OR avg_customer_rating < 3.5 THEN 'Underperforming'
           ELSE 'Healthy'
       END AS performance_status
FROM rating_summary;

-- find customers with high cancellations AND low rating
WITH cancellation_behavior AS (
  SELECT customer_id,
        SUM(CASE WHEN cancelled_by_customer <> 'No' THEN 1 ELSE 0 END) AS total_cancels,
         AVG(customer_rating) AS avg_rating
  FROM RideBookings
  GROUP BY customer_id
)
SELECT *
FROM cancellation_behavior
WHERE total_cancels > 3 AND avg_rating < 2.5
ORDER BY total_cancels desc;





--  Find top 3 most loyal customers per vehicle type (based on ride count)
SELECT vehicle_type, customer_id, ride_count
FROM (
    SELECT vehicle_type, customer_id, COUNT(*) AS ride_count,
           ROW_NUMBER() OVER (PARTITION BY vehicle_type ORDER BY COUNT(*) DESC) AS rank_num
    FROM RideBookings
    GROUP BY vehicle_type, customer_id
) ranked
WHERE rank_num = 3;


-- Detect month-over-month growth in total bookings
WITH monthly_counts AS (
    SELECT YEAR(booking_date) AS yr, MONTH(booking_date) AS mo, COUNT(*) AS total_rides
    FROM RideBookings
    GROUP BY yr, mo
)
SELECT a.yr, a.mo, a.total_rides,
       ((a.total_rides - b.total_rides) / b.total_rides) * 100 AS growth_pct
FROM monthly_counts a
JOIN monthly_counts b
  ON a.yr = b.yr AND a.mo = b.mo + 1;
  

-- Identify "long wait" rides (CTAT and VTAT both higher than global average)
WITH avg_times AS (
    SELECT AVG(avg_ctat) AS global_ctat, AVG(avg_vtat) AS global_vtat
    FROM RideBookings
)
SELECT *
FROM RideBookings, avg_times
WHERE avg_ctat > global_ctat AND avg_vtat > global_vtat;

--  Rank vehicle types by revenue contribution percentage
WITH total_revenue AS (
    SELECT SUM(booking_value) AS grand_total
    FROM RideBookings
),
vehicle_revenue AS (
    SELECT vehicle_type, SUM(booking_value) AS V_type_Revenue
    FROM RideBookings
    GROUP BY vehicle_type
)
SELECT v.vehicle_type,
       v.V_type_Revenue,
       (v.V_type_Revenue / t.grand_total) * 100 AS revenue_pct
FROM vehicle_revenue v, total_revenue t
ORDER BY revenue_pct DESC;


-- 5  customers who used more than 3 vehicle types
SELECT customer_id, COUNT(DISTINCT vehicle_type) AS vehicle_type_count
FROM RideBookings
GROUP BY customer_id
HAVING vehicle_type_count  >=3;

-- Find peak hours for high-value rides (value > 300)
SELECT HOUR(booking_time) AS hour_of_day, COUNT(*) AS high_value_rides
FROM RideBookings
WHERE booking_value > 300
GROUP BY hour_of_day
ORDER BY high_value_rides DESC;




























