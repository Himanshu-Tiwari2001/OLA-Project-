# OLA-Project-
This project is all about analysis  of OLA Ride Booking in the month of JULY , AUGUST and SEPTEMBER --2024

# 🚖 Bangalore Ride Booking Data Analysis

## 📄 Overview

This project analyzes Bangalore ride booking data to uncover operational, customer, and business insights. It leverages SQL queries for deep data exploration and is designed to support decision-making for ride-sharing platforms.

---

## 📊 Dataset

**Columns:**
- Date & Time
- Booking ID & Status
- Customer ID
- Vehicle Type
- Pickup & Drop locations
- Average VTAT (Vehicle Turnaround Time)
- Average CTAT (Customer Turnaround Time)
- Cancellation indicators
- Incomplete ride indicators & reasons
- Booking value
- Ride distance
- Driver and customer ratings

---

## 🎯 Objectives

- Identify revenue contributors by vehicle type
- Analyze ride status patterns
- Understand customer loyalty
- Examine cancellation and incomplete ride behavior
- Discover operational and rating trends

---

```sql
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
```
### Load Data In to RideBookings Table
```sql

LOAD DATA LOCAL INFILE "C:\Users\virat\Desktop\Imarticus capstone project\Bangalore_Ride_Data_Jul_Sep_2024.csv"
INTO TABLE Ridebookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

```
```sql
SELECT * FROM ridebookings;
desc ridebookings;


```
![image](https://github.com/user-attachments/assets/e5362312-94ad-4f5c-9e95-71f7a6af49fd)

### Modification in existing table
```sql
-- modifications 
ALTER TABLE RideBookings
MODIFY cancelled_by_customer VARCHAR(100),
MODIFY cancelled_by_driver VARCHAR(100),
MODIFY   booking_status VARCHAR(70);

-- change the data type of customer_id  from INT to STRING
ALTER TABLE RideBookings
MODIFY COLUMN customer_id VARCHAR(255);

```
### Data Cleaning Process
```sql
-- cleaning the dataset
UPDATE RideBookings
SET avg_ctat  = 0
WHERE avg_ctat IS NULL OR avg_ctat = '';


UPDATE RideBookings
SET avg_vtat  = 0
WHERE avg_ctat IS NULL OR avg_vtat = '';


UPDATE RideBookings
SET customer_id = CONCAT('CID', customer_id);
```

## 💡 SQL Questions & Queries

### 1️⃣ What is the total number of rides?

```sql

SELECT * FROM ridebookings;
desc ridebookings;
```

 ### How many rides were successful vs incomplete?
 ```sql
SELECT booking_status, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY booking_status;
```
![image](https://github.com/user-attachments/assets/9d0b07b5-5ae7-4f48-884c-d589e64cdc43)

### What is the average booking value and ride distance per vehicle type?
```sql
SELECT vehicle_type, round(AVG(booking_value) ,2) AS avg_value, round(AVG(ride_distance) ,2) AS avg_distance
FROM RideBookings
GROUP BY vehicle_type;
```
![image](https://github.com/user-attachments/assets/a712c0e6-d387-476d-8adc-9193652c83db)


### What are the average driver and customer ratings per vehicle type?
```sql
SELECT vehicle_type, AVG(driver_rating) AS avg_driver_rating, AVG(customer_rating) AS avg_customer_rating
FROM RideBookings
GROUP BY vehicle_type;
```
![image](https://github.com/user-attachments/assets/efbe568c-d80d-421b-b33c-b84aa9543402)

### Which are the top 5 pickup locations by number of bookings?
```sql
SELECT pickup_location, COUNT(*) AS num_bookings
FROM RideBookings
GROUP BY pickup_location
ORDER BY num_bookings DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/54ce021e-25a5-4a57-9261-1347b4ed5166)

### What is the percentage of rides cancelled by customers vs drivers?
```sql
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
```
![image](https://github.com/user-attachments/assets/2f256fe3-deda-43c2-a928-7f6df63b66c0)

### What is the average CTAT and VTAT per vehicle type?
```sql
SELECT vehicle_type, round(AVG(avg_ctat),2) AS avg_ctat, round(AVG(avg_vtat) ,2) AS avg_vtat
FROM RideBookings
GROUP BY vehicle_type;
```
![image](https://github.com/user-attachments/assets/af114744-6725-49c3-81e3-68e38733609c)

### Which 5 customers had 2 incomplete rides?
```sql
SELECT customer_id, COUNT(*) AS incomplete_count
FROM RideBookings
WHERE booking_status = 'Incomplete'
GROUP BY customer_id
ORDER BY  incomplete_count DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/7707b67b-65c6-43b7-ba3b-3f39ad0bfddb)


### What is the total booking value per month?
```sql
SELECT monthname((booking_date)) AS month, SUM(booking_value) AS avg_booking_value
FROM RideBookings
GROUP BY month
ORDER BY month;
```
![image](https://github.com/user-attachments/assets/e1f6844f-21b6-47e3-9f82-f2d233a14f72)



### What is the top 5 peak  ride distance by hour of the day?
```sql
SELECT HOUR(booking_time) AS booking_hour, round(AVG(ride_distance) ,2)AS avg_distance
FROM RideBookings
GROUP BY booking_hour
ORDER BY avg_distance DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/f1ccd55f-cabd-4b2b-a0cb-75a965382137)


### What are the most common reasons for incomplete rides?
```sql
SELECT incomplete_rides_reason, COUNT(*) AS num_rides
FROM RideBookings
WHERE booking_status = 'Incomplete'
GROUP BY incomplete_rides_reason
ORDER BY num_rides DESC;
```
![image](https://github.com/user-attachments/assets/58f78a92-bbfe-4125-be3e-6eb401212165)


### What is the total revenue generated per vehicle type?
```sql
SELECT vehicle_type, SUM(booking_value) AS total_revenue
FROM RideBookings
GROUP BY vehicle_type
ORDER BY total_revenue DESC;
```
![image](https://github.com/user-attachments/assets/fb46e448-2c80-44a4-9dbd-cd8659417e4a)

```sql
-- Which rides have the highest driver rating?
SELECT *
FROM RideBookings
WHERE driver_rating = (SELECT MAX(driver_rating) FROM RideBookings);

 -- Which rides had a long wait time (CTAT > 15)?
 SELECT *
FROM RideBookings
WHERE avg_ctat > 15;
```

### How many rides happened on each day of the week?
```sql
SELECT DAYNAME(booking_date) AS day_of_week, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
```
![image](https://github.com/user-attachments/assets/15457b5d-f1c9-49fb-87a8-e127928d044b)

### What is the average booking value for rides over 20 km?
``` sql
SELECT AVG(booking_value) AS avg_value_long_rides
FROM RideBookings
WHERE ride_distance > 20;
```
![image](https://github.com/user-attachments/assets/d0d13651-10ed-477f-8525-a81fc1c25a1c)


-- Which customers consistently book high-value rides (value > 300)?
```sql
SELECT DISTINCT customer_id
FROM RideBookings
WHERE booking_value > 300;
```
### Top 5 ride count   per drop location?
```sql
SELECT drop_location, COUNT(*) AS num_rides
FROM RideBookings
GROUP BY drop_location
ORDER BY num_rides DESC
LIMIT 5;
```

### Which vehicle types have the lowest average driver ratings?
```sql 
SELECT vehicle_type, round(AVG(driver_rating),2) AS avg_driver_rating
FROM RideBookings
GROUP BY vehicle_type
ORDER BY avg_driver_rating ASC
LIMIT 3;
```
![image](https://github.com/user-attachments/assets/d26daade-6601-4ba4-9cec-8376d31f70c9)

### Find the top  drop locations for each vehicle type
```sql
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
WHERE rank_num <= 3;
```
![image](https://github.com/user-attachments/assets/bfe7cb55-ed04-455e-b5c1-6762003a14b3)

### Calculate the percentage of high-rated rides (driver and customer both > 4) per vehicle type
```sql 
SELECT vehicle_type,
       SUM(CASE WHEN driver_rating > 4 AND customer_rating > 4 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS high_rating_pct
FROM RideBookings
GROUP BY vehicle_type;
```
![image](https://github.com/user-attachments/assets/a6a89ee8-64d8-4c57-98b6-dc916f063ec6)

### Find customers who have both high total spending and high average driver rating
```sql
SELECT customer_id,
       SUM(booking_value) AS total_spent,
       round(AVG(driver_rating) ,2) AS avg_driver_rating
FROM RideBookings
GROUP BY customer_id
HAVING total_spent > 1000 AND avg_driver_rating > 4.0
ORDER BY total_spent DESC;
```
![image](https://github.com/user-attachments/assets/7c3d9e80-5e5b-4ec7-b2c7-b7f0659905ac)


### Detect potential churn risk: customers with recent incomplete rides and low average ratings
```sql
SELECT customer_id,
       COUNT(*) AS incomplete_rides,
       round(AVG(customer_rating),2) AS avg_rating
FROM RideBookings
WHERE booking_status = 'Incomplete'
GROUP BY customer_id
ORDER BY incomplete_rides DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/7b6e80e2-eb22-4b9f-bcc5-b5cc549ff350)

### Compare CTAT trends by vehicle type over months
```sql
SELECT vehicle_type, MONTH(booking_date) AS month, AVG(avg_ctat) AS avg_ctat
FROM RideBookings
GROUP BY vehicle_type, month
ORDER BY vehicle_type, month;
```
![image](https://github.com/user-attachments/assets/aa7b2e17-efb3-453e-86b9-29d650830988)


### find top 5 most frequent routes (pickup → drop)
```sql
WITH route_counts AS (
  SELECT pickup_location, drop_location, COUNT(*) AS ride_count
  FROM RideBookings
  GROUP BY pickup_location, drop_location
)
SELECT *
FROM route_counts
ORDER BY ride_count DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/f2d239a0-44eb-4aed-836d-a79dd3811eaa)

### calculate monthly revenue per vehicle type, then find top performer
```sql
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
```
![image](https://github.com/user-attachments/assets/a668e794-10f5-43af-aa21-a3cef63858cd)


###  Get average ratings and flag underperforming vehicle types
```sql
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
```
![image](https://github.com/user-attachments/assets/b1265a25-5be2-4da0-b8c9-db044716495c)


### Find top  most loyal customers per vehicle type (based on ride count)
```sql 
SELECT vehicle_type, customer_id, ride_count
FROM (
    SELECT vehicle_type, customer_id, COUNT(*) AS ride_count,
           ROW_NUMBER() OVER (PARTITION BY vehicle_type ORDER BY COUNT(*) DESC) AS rank_num
    FROM RideBookings
    GROUP BY vehicle_type, customer_id
) ranked
WHERE rank_num <= 1;
```
![image](https://github.com/user-attachments/assets/b99d0e07-fe2d-455c-9327-c51aa758c41e)


### Detect month-over-month growth in total bookings
```sql
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
  ```
![image](https://github.com/user-attachments/assets/e98f1fc0-c952-4ec0-9730-ef6121712f38)

###  Rank vehicle types by revenue contribution percentage
```sql
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
```
![image](https://github.com/user-attachments/assets/5bbcf9f9-42ca-42d5-8fda-48ef294a372e)


### What are the monthly ride counts?
```sql
SELECT YEAR(booking_date) AS year, MONTH(booking_date) AS month, COUNT(*) AS ride_count
FROM RideBookings
GROUP BY year, month
ORDER BY year, month;
```
![image](https://github.com/user-attachments/assets/a43c7183-9846-428e-9a85-896e93920fa3)

### 5  customers who used more than 3 vehicle types
```sql
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


-- What is the proportion of incomplete rides overall?
SELECT (SUM(CASE WHEN booking_status = 'Incomplete' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS incomplete_percentage
FROM RideBookings;



-- SELECT vehicle_type, SUM(ride_distance) AS total_distance
SELECT vehicle_type, SUM(ride_distance) AS total_distance
FROM RideBookings
GROUP BY vehicle_type
ORDER BY total_distance DESC;






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


```


