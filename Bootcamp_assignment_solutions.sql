-- 1
CREATE DATABASE event_management;
USE event_management;

-- 2
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    age INT
);
-- 3
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    ticket_price DECIMAL(10,2)
);

-- 4
CREATE TABLE Registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    event_id INT,
    feedback_rating DECIMAL(3,1),  -- rating out of 10
    attended BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- 5
INSERT INTO Users (name, city, age) VALUES
('Amit Sharma', 'Delhi', 28),
('Riya Kapoor', 'Mumbai', 24),
('Veer Singh', 'Pune', 22),
('Arjun Mehta', 'Bangalore', 30),
('Sneha Rao', 'Hyderabad', 26),
('Karan Patel', 'Ahmedabad', 29);

-- 6
INSERT INTO Events (event_name, category, ticket_price) VALUES
('Tech Innovators Summit', 'Technology', 1500),
('Music Fiesta', 'Entertainment', 800),
('Startup Pitch Day', 'Business', 1200),
('Art & Design Expo', 'Art', 600),
('AI & ML Workshop', 'Technology', 2000);

--  7
INSERT INTO Registrations (user_id, event_id, feedback_rating, attended) VALUES
(1, 1, 9.0, TRUE),
(1, 2, 8.5, TRUE),
(2, 1, 7.5, TRUE),
(2, 3, NULL, FALSE),
(3, 5, 9.5, TRUE),
(3, 2, 6.5, TRUE),
(4, 4, NULL, FALSE),
(5, 3, 8.0, TRUE),
(6, 5, 9.0, TRUE),
(6, 1, NULL, FALSE);

-- 8 
INSERT INTO Users (name, city, age) VALUES ('New User', 'Goa', 27);

-- 9
SELECT * FROM Events;

-- 10
UPDATE Users
SET city = 'Chennai'
WHERE user_id = 3;

-- 11
DELETE FROM Registrations
WHERE registration_id = 10;

-- 12
SELECT * FROM Events
WHERE category = 'Technology';

-- 13
SELECT * FROM Events
ORDER BY ticket_price DESC;

-- 14
SELECT * FROM Users
LIMIT 3;

-- Analysis 
-- A
SELECT e.event_name, COUNT(r.registration_id) AS total_registrations
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id
GROUP BY e.event_id;

-- B

SELECT e.event_name,
       COUNT(r.registration_id) AS total_registrations,
       AVG(r.feedback_rating) AS avg_rating
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id
GROUP BY e.event_id;

-- C
SELECT e.event_name, AVG(r.feedback_rating) AS avg_rating
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
WHERE r.feedback_rating IS NOT NULL
GROUP BY e.event_id
HAVING avg_rating > 8;


-- D
SELECT e.event_name,
       COUNT(r.registration_id) * e.ticket_price AS total_revenue
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id AND r.attended = TRUE
GROUP BY e.event_id;


-- E
SELECT category, event_name, avg_rating
FROM (
    SELECT e.category, e.event_name,
           AVG(r.feedback_rating) AS avg_rating,
           ROW_NUMBER() OVER (PARTITION BY e.category ORDER BY AVG(r.feedback_rating) DESC) AS rn
    FROM Events e
    LEFT JOIN Registrations r ON e.event_id = r.event_id
    GROUP BY e.event_id
) ranked
WHERE rn = 1;


-- F
SELECT u.user_id, u.name, COUNT(r.registration_id) AS attended_count
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id AND r.attended = TRUE
GROUP BY u.user_id
HAVING attended_count > 1;

-- G
SELECT u.user_id, u.name
FROM Users u
LEFT JOIN Registrations r ON u.user_id = r.user_id AND r.attended = TRUE
WHERE r.registration_id IS NULL;

-- H 
SELECT u.user_id, u.name
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
JOIN Events e ON r.event_id = e.event_id
WHERE e.ticket_price = (SELECT MAX(ticket_price) FROM Events)
  AND r.attended = TRUE;

-- I 
SELECT u.user_id, u.name,
       COUNT(r.registration_id) AS total_attended,
       AVG(r.feedback_rating) AS avg_rating
FROM Users u
LEFT JOIN Registrations r ON u.user_id = r.user_id AND r.attended = TRUE
GROUP BY u.user_id
ORDER BY total_attended DESC, avg_rating DESC;

