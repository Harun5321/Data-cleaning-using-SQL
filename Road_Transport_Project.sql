--What is the total number of accidents across all states?

SELECT SUM(Speed_violation+Use_Of_Phone+Tyre_Burst+Brake_Failure+Overloading+Dangerous_Overtaking+Wrongful_Overtaking+Dangerous_Driving+Bad_Road+Sign_Light_Violation+OTHERS) AS TotalAccidents
FROM Road_transport..Causes_of_road_accidents

--What is the total number of accidents in the Northern region
SELECT SUM(Speed_violation+Use_Of_Phone+Tyre_Burst+Brake_Failure+Overloading+Dangerous_Overtaking+Wrongful_Overtaking+Dangerous_Driving+Bad_Road+Sign_Light_Violation+OTHERS) AS TotalAccidents
FROM Road_transport..Causes_of_road_accidents
WHERE STATE IN ('Adamawa', 'Bauchi', 'Borno', 'Gombe', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Plateau', 'Sokoto', 'Taraba', 'Yobe', 'Zamfara')

--What is the total number of accidents in the Southern region
SELECT SUM(Speed_violation+Use_Of_Phone+Tyre_Burst+Brake_Failure+Overloading+Dangerous_Overtaking+Wrongful_Overtaking+Dangerous_Driving+Bad_Road+Sign_Light_Violation+OTHERS) AS TotalAccidents
FROM Road_transport..Causes_of_road_accidents
WHERE STATE NOT IN ('Adamawa', 'Bauchi', 'Borno', 'Gombe', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Plateau', 'Sokoto', 'Taraba', 'Yobe', 'Zamfara')

-- Which state has the highest number of accidents?

SELECT TOP 1 STATE, (Speed_violation+Use_Of_Phone+Tyre_Burst+Brake_Failure+Overloading+Dangerous_Overtaking+Wrongful_Overtaking+Dangerous_Driving+Bad_Road+Sign_Light_Violation+OTHERS) AS TotalAccidents
FROM Road_transport..Causes_of_road_accidents
ORDER BY TotalAccidents DESC


-- Which state has the lowest number of accidents?

SELECT TOP 1 STATE, (Speed_violation+Use_Of_Phone+Tyre_Burst+Brake_Failure+Overloading+Dangerous_Overtaking+Wrongful_Overtaking+Dangerous_Driving+Bad_Road+Sign_Light_Violation+OTHERS) AS TotalAccidents
FROM Road_transport..Causes_of_road_accidents
ORDER BY TotalAccidents 

--Which state has the highest number of accidents due to speed violation?
SELECT  TOP 1 STATE, Speed_violation 
FROM Road_transport..Causes_of_road_accidents
ORDER BY 2 DESC

--What is the average number of accidents due to speed violation across all states?


SELECT AVG(Speed_violation) AS Average_speed_violation
FROM Road_transport..Causes_of_road_accidents
--ORDER BY 2 DESC


--Which state has the highest number of accidents related to the use of phones?
SELECT  TOP 1 STATE, Use_Of_Phone 
FROM Road_transport..Causes_of_road_accidents
ORDER BY 2 DESC

--What is the overall percentage of accidents caused by the use of phones?

SELECT (SUM(Use_Of_Phone) * 100 / SUM(Speed_violation + Use_Of_Phone + Tyre_Burst + Brake_Failure +
                                        Overloading + Dangerous_Overtaking + Wrongful_Overtaking +
                                        Dangerous_Driving + Bad_Road + Sign_Light_Violation + OTHERS)) AS OverallPhonePercentage
FROM Road_transport..Causes_of_road_accidents;

--How many states have reported incidents of dangerous overtaking?

SELECT COUNT(Dangerous_Overtaking) AS States
FROM Road_transport..Causes_of_road_accidents
Where Dangerous_Overtaking > 0
GROUP BY Dangerous_Overtaking

--Identify the top three states with the highest total violations.
SELECT TOP 3 STATE, Speed_violation
FROM Road_transport..Causes_of_road_accidents
ORDER BY 2 DESC


--What is the percentage of accidents caused by brake failure compared to the total accidents?

SELECT (SUM(Brake_Failure) * 100 / SUM(Speed_violation + Use_Of_Phone + Tyre_Burst + Brake_Failure +
                                        Overloading + Dangerous_Overtaking + Wrongful_Overtaking +
                                        Dangerous_Driving + Bad_Road + Sign_Light_Violation + OTHERS)) AS OverallPhonePercentage
FROM Road_transport..Causes_of_road_accidents;

--Compare the distribution of tire burst incidents in the northern and southern states.

--Northern States
SELECT SUM(Tyre_Burst)
FROM Road_transport..Causes_of_road_accidents
WHERE STATE  IN ('Adamawa', 'Bauchi', 'Borno', 'Gombe', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Plateau', 'Sokoto', 'Taraba', 'Yobe', 'Zamfara') 

--Southern States
SELECT SUM(Tyre_Burst)
FROM Road_transport..Causes_of_road_accidents
WHERE STATE NOT IN ('Adamawa', 'Bauchi', 'Borno', 'Gombe', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Plateau', 'Sokoto', 'Taraba', 'Yobe', 'Zamfara')

--Percentages

--Northern States
SELECT (SUM(Tyre_Burst) * 100 / SUM(Speed_violation + Use_Of_Phone + Tyre_Burst + Brake_Failure +
                                        Overloading + Dangerous_Overtaking + Wrongful_Overtaking +
                                        Dangerous_Driving + Bad_Road + Sign_Light_Violation + OTHERS)) AS Tyre_burst
FROM Road_transport..Causes_of_road_accidents
WHERE STATE IN ('Adamawa', 'Bauchi', 'Borno', 'Gombe', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Plateau', 'Sokoto', 'Taraba', 'Yobe', 'Zamfara')

--Southern States
SELECT (SUM(Tyre_Burst) * 100 / SUM(Speed_violation + Use_Of_Phone + Tyre_Burst + Brake_Failure +
                                        Overloading + Dangerous_Overtaking + Wrongful_Overtaking +
                                        Dangerous_Driving + Bad_Road + Sign_Light_Violation + OTHERS)) AS Tyre_burst
FROM Road_transport..Causes_of_road_accidents
WHERE STATE NOT IN ('Adamawa', 'Bauchi', 'Borno', 'Gombe', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Plateau', 'Sokoto', 'Taraba', 'Yobe', 'Zamfara')