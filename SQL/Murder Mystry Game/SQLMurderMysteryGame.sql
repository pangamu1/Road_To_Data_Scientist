/* Decoding Murder Mystery Game offered by https://mystery.knightlab.com/ */

/* 
Problem statement:
    A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. 
    You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. 
    Start by retrieving the corresponding crime scene report from the police department’s database. 
*/

-- Breakdown step by step, first filter by type of crime and date from crime_scene_report
SELECT * 
FROM crime_scene_report
WHERE type = 'murder' AND date = 20180115

-- Narrow down the search even further where the crime took place from the statement
SELECT * 
FROM crime_scene_report
WHERE type = 'murder' AND date = 20180115 AND city = 'SQL City'

/* From the results, look for clues in description. The Description should read
The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave". */

-- Get details about two witnesses from the description, 1st Witness:
SELECT * 
FROM person 
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC LIMIT 1    
/*
id	name	        license_id  address_number	address_street_name  ssn
14887	Morty Schapiro	118009	    4919	        Northwestern Dr	    111564949
*/

-- 2nd Witness:
SELECT * 
FROM person 
WHERE name like 'Annabel%'
AND address_street_name = 'Franklin Ave'
/*
id	name	        license_id   address_number  address_street_name     ssn
16371	Annabel Miller	490173	    103	            Franklin Ave	    318771143
*/

-- Get more deatils about these two witnesses, pull more info from drivers_license table
SELECT * 
FROM drivers_license where ID = 118009 OR ID = 490173
/*
id	age	height	eye_color   hair_color	gender	plate_number	car_make	car_model
118009	64	84	blue	    white	male	00NU00	        Mercedes-Benz	E-Class
490173	35	65	green	    brown	female	23AM98	        Toyota	        Yaris
*/

-- Check for clues in other tables, start from get fit members table and see if they are a member:
SELECT * 
FROM get_fit_now_member 
WHERE person_id = 14887 OR person_id = 16371
/*
id	person_id   name	        membership_start_date	membership_status
90081	16371	    Annabel Miller	20160208	        gold  
*/ -- Morty is not a member and Annabel is a member since 2016

-- Checking for more info from other tables similarly,
SELECT * 
FROM facebook_event_checkin 
WHERE person_id = 14887 OR person_id = 16371
/*
person_id   event_id	event_name	        date
14887	    4719	The Funky Grooves Tour	20180115
16371	    4719	The Funky Grooves Tour	20180115
*/ -- Seems both have attended the same event and it's a possibility that the crime happened in The Funky Grooves Tour EVENT

-- Checking for more info from other tables similarly,
SELECT * 
FROM interview 
WHERE person_id = 14887 OR person_id = 16371
/*
person_id   transcript
14887	    I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
16371	    I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
*/ -- from information here, we need to filter out information one by one from respective tables

-- Check for Membership id starting with 48z and a Gold member
SELECT * 
FROM get_fit_now_member 
WHERE id LIKE '48Z%' 
AND membership_status = 'gold'
/*
id	person_id   name	        membership_start_date	membership_status
48Z7A	28819	    Joe Germuska	20160305	        gold
48Z55	67318	    Jeremy Bowers	20160101	        gold
*/ -- We now have two potential leads, continue to search for more clues provided by Morty and Annabel

-- Check if the Car Number Plate matches these two leads:
SELECT * 
FROM person 
WHERE id = 28819 OR id = 67318
/*
id	    name	        license_id	address_number	address_street_name	    ssn
28819	Joe Germuska	173289	    111	            Fisk Rd	                138909730
67318	Jeremy Bowers	423327	    530	            Washington Pl, Apt 3A	871539279
*/
SELECT * 
FROM drivers_license
WHERE id = 173289 OR id = 423327
/*
id	    age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
423327	30	70	    brown	    brown	    male	0H42W2	        Chevrolet	Spark LS
*/ -- Jeremy Bowers seems to be the prime suspect based on Morty's information as it matches the plate number as well.

-- Confirm the suspicion on Jeremy Bowers based on Annabel's information:
SELECT * 
FROM get_fit_now_check_in 
WHERE check_in_date = 20180109
AND membership_id = '90081' OR membership_id = '48Z55'
/*
membership_id	check_in_date	check_in_time	check_out_time
90081	        20180109	    1600	        1700
48Z55	        20180109	    1530	        1700
*/ -- It further confirms Jeremy Bowers was indeed at Gym during Annabel's visit to the Gym

-- Let's check if our suspicion on this suspect is the murderer:
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;
/*
value
Congrats, you found the murderer! 
But wait, there's more...
If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. 
If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. 
Use this same INSERT statement with your new suspect to check your answer.
*/ -- Looks like we have a lot to unpack here 

-- Let's lookup convict's interview:
SELECT * 
FROM interview 
WHERE person_id = 67318
/*
person_id	transcript
67318	    I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/

-- Go one information after the other:
SELECT * 
FROM drivers_license 
WHERE gender = 'female' 
AND hair_color = 'red'
AND height BETWEEN 65 AND 67
AND car_make = 'Tesla' 
AND car_model = 'Model S'

/*
id	    age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
202298	68	66	    green	    red	        female	500123	        Tesla	    Model S
291182	65	66	    blue	    red	        female	08CM64	        Tesla	    Model S
918773	48	65	    black	    red	        female	917UU3	        Tesla	    Model S
*/

-- Moving on to the next piece of information
SELECT person_id, COUNT (*) as Num_of_visits
FROM facebook_event_checkin 
WHERE event_name LIKE "SQL Symphony%"
AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id
ORDER BY Num_of_visits DESC LIMIT 3
/*
person_id	Num_of_visits
24556	    3
99716	    3
28582	    2
*/

-- Pull information on the two prime suspects who have been to concert thrice
SELECT *
FROM person 
WHERE id = 24556 OR id = 99716
/*
id	    name	            license_id	address_number	address_street_name	ssn
24556	Bryan Pardo	        101191	    703	            Machine Ln	        816663882
99716	Miranda Priestly	202298	    1883	        Golden Ave	        987756388
*/ -- Miranda Priestly should be the culprit but we can confirm once on drivers license table

-- Confirming if the suspect is Miranda Priestly
SELECT * 
FROM drivers_license 
WHERE id = 202298
/*
id	    age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
202298	68	66	    green	    red	        female	500123	        Tesla	    Model S
*/ -- Confirms Miranda is the culprit

-- Check if the answer is correct:
INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;
/*
value
Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
*/






