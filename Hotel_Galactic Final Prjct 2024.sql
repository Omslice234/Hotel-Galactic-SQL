MariaDB [oaburubdb]> -- Table for the Galactic Hotels
MariaDB [oaburubdb]> CREATE TABLE Galactic_Hotel (
    ->     HotelID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique ID for each space hotel',
    ->     HotelName VARCHAR(100) NOT NULL COMMENT 'Name of the hotel on Earth',
    ->     Planet VARCHAR(50) DEFAULT 'Earth' COMMENT 'Planet location of the hotel',
    ->     Galaxy VARCHAR(50) DEFAULT 'Milky Way' COMMENT 'Galaxy location of the hotel',
    ->     Sector VARCHAR(10) COMMENT 'Galactic sector code for navigation',
    ->     NumRooms INT NOT NULL COMMENT 'Total number of space-ready rooms',
    ->     CommsFrequency VARCHAR(15) COMMENT 'Earth phone number for hotel communication',
    ->     StarRating DECIMAL(2,1) COMMENT 'Intergalactic star rating'
    -> );
Query OK, 0 rows affected (0.007 sec)

MariaDB [oaburubdb]> -- Table for Cosmic Rooms
MariaDB [oaburubdb]> CREATE TABLE Cosmic_Room (
    ->     RoomID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique ID for each room',
    ->     HotelID INT COMMENT 'Hotel where the room is located',
    ->     RoomType ENUM('Single Pod', 'Double Pod', 'Luxury Suite') NOT NULL COMMENT 'Type of accommodation',
    ->     GalacticRate DECIMAL(10,2) NOT NULL COMMENT 'Room rate in Intergalactic Credits',
    ->     OccupancyStatus ENUM('Available', 'Occupied') DEFAULT 'Available' COMMENT 'Room availability status',
    ->     Amenities SET('WIFI', 'Interstellar TV', 'Anti-Gravity Bed') NOT NULL COMMENT 'Amenities included in the room',
    ->     FOREIGN KEY (HotelID) REFERENCES Galactic_Hotel(HotelID) ON DELETE CASCADE
    -> );
Query OK, 0 rows affected (0.037 sec)

MariaDB [oaburubdb]> -- Table for the Guests
MariaDB [oaburubdb]> CREATE TABLE Intergalactic_Guest (
    ->     GuestID VARCHAR(20) PRIMARY KEY COMMENT 'Guest ID (Passport/Driver License/Alien ID)',
    ->     FirstName VARCHAR(50) NOT NULL COMMENT 'First name of the guest',
    ->     LastName VARCHAR(50) NOT NULL COMMENT 'Last name of the guest',
    ->     Species VARCHAR(50) DEFAULT 'Human' COMMENT 'Species of the guest (e.g., Zoglonian)',
    ->     CommsAddress VARCHAR(100) UNIQUE NOT NULL COMMENT 'Earth email for human guests or galactic address for aliens',
    ->     GalacticNumber VARCHAR(20) COMMENT 'Contact number for intergalactic communication'
    -> );
Query OK, 0 rows affected (0.009 sec)

MariaDB [oaburubdb]> -- Table For the Star Reservations
MariaDB [oaburubdb]> CREATE TABLE Star_Reservation (
    ->     ReservationID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique reservation ID',
    ->     GuestID VARCHAR(20) COMMENT 'Foreign key to Intergalactic_Guest',
    ->     RoomID INT COMMENT 'Foreign key to Cosmic_Room',
    ->     CheckInStardate DATE NOT NULL COMMENT 'Stardate for check-in',
    ->     CheckOutStardate DATE NOT NULL COMMENT 'Stardate for check-out',
    ->     ReservationStatus ENUM('Confirmed', 'Cancelled') NOT NULL COMMENT 'Status of reservation',
    ->     NumberOfZoglings INT DEFAULT 0 COMMENT 'Number of Zoglonian adults accompanying the guest',
    ->     NumberOfJuveniles INT DEFAULT 0 COMMENT 'Number of juvenile aliens or children',
    ->     FOREIGN KEY (GuestID) REFERENCES Intergalactic_Guest(GuestID),
    ->     FOREIGN KEY (RoomID) REFERENCES Cosmic_Room(RoomID),
    ->     CONSTRAINT chk_stardates CHECK (CheckInStardate < CheckOutStardate)
    -> );
Query OK, 0 rows affected (0.013 sec)

MariaDB [oaburubdb]> -- Table For the Hotel Staff
MariaDB [oaburubdb]> CREATE TABLE Space_Crew (
    ->     CrewID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique ID for each hotel crew member',
    ->     HotelID INT COMMENT 'Foreign key to Galactic_Hotel',
    ->     CrewName VARCHAR(50) NOT NULL COMMENT 'Name of the crew member',
    ->     GalacticRole ENUM('Front Desk Alien', 'Housekeeping Droid', 'Manager', 'Maintenance Engineer') NOT NULL COMMENT 'Crew role at the hotel',
    ->     GalacticShift TIME COMMENT 'Shift time for the crew member',
    ->     Species ENUM('Human', 'Zoglonian', 'Robotic') DEFAULT 'Human' COMMENT 'Species of the crew member',
    ->     GalacticCredits DECIMAL(10,2) NOT NULL COMMENT 'Salary in intergalactic credits',
    ->     FOREIGN KEY (HotelID) REFERENCES Galactic_Hotel(HotelID) ON DELETE SET NULL
    -> );
Query OK, 0 rows affected (0.008 sec)

MariaDB [oaburubdb]> -- Table for the Payments
MariaDB [oaburubdb]> CREATE TABLE Galactic_Payment (
    ->     PaymentID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique ID for each payment transaction',
    ->     ReservationID INT COMMENT 'Foreign key to Star_Reservation',
    ->     PaymentAmount DECIMAL(10,2) NOT NULL COMMENT 'Amount paid in Intergalactic Credits',
    ->     PaymentStardate DATE DEFAULT CURRENT_DATE COMMENT 'Date of payment (stardate)',
    ->     PaymentMethod ENUM('Galactic Credit Card', 'Cash', 'Space Crystals') NOT NULL COMMENT 'Method of payment',
    ->     FOREIGN KEY (ReservationID) REFERENCES Star_Reservation(ReservationID) ON DELETE CASCADE
    -> );
Query OK, 0 rows affected (0.010 sec)

MariaDB [oaburubdb]> -- Table for the Refunds/Cancelations
MariaDB [oaburubdb]> CREATE TABLE Cosmic_Refund (
    ->     RefundID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique ID for each refund transaction',
    ->     ReservationID INT COMMENT 'Foreign key to Star_Reservation',
    ->     RefundStardate DATE NOT NULL COMMENT 'Stardate of the refund',
    ->     RefundAmount DECIMAL(10,2) NOT NULL COMMENT 'Refund amount in Intergalactic Credits',
    ->     FOREIGN KEY (ReservationID) REFERENCES Star_Reservation(ReservationID) ON DELETE CASCADE
    -> );
Query OK, 0 rows affected (0.011 sec)

MariaDB [oaburubdb]> CREATE VIEW View_SpaceCrewSalaries AS
    -> SELECT 
    ->     Galactic_Hotel.HotelName, Space_Crew.GalacticRole, SUM(Space_Crew.GalacticCredits) AS TotalSalary
    -> FROM 
    ->     Space_Crew
    -> JOIN 
    ->     Galactic_Hotel ON Space_Crew.HotelID = Galactic_Hotel.HotelID
    -> GROUP BY 
    ->     Galactic_Hotel.HotelName, Space_Crew.GalacticRole;
Query OK, 0 rows affected (0.006 sec)

MariaDB [oaburubdb]> -- Now inserting/Popultiong The tables
MariaDB [oaburubdb]> INSERT INTO Galactic_Hotel (HotelName, Planet, Galaxy, Sector, NumRooms, CommsFrequency, StarRating) 
    -> VALUES 
    -> ('Galactic Oasis', 'Earth', 'Milky Way', 'A1B2C3', 200, '123-456-7890', 5.0);
Query OK, 1 row affected (0.002 sec)

MariaDB [oaburubdb]> INSERT INTO Cosmic_Room (HotelID, RoomType, GalacticRate, OccupancyStatus, Amenities) 
    -> VALUES 
    -> (1, 'Single Pod', 100.00, 'Available', 'WIFI,Interstellar TV,Anti-Gravity Bed'),
    -> (1, 'Luxury Suite', 500.00, 'Occupied', 'WIFI,Interstellar TV,Anti-Gravity Bed');
Query OK, 2 rows affected (0.001 sec)
Records: 2  Duplicates: 0  Warnings: 0

MariaDB [oaburubdb]> INSERT INTO Intergalactic_Guest (GuestID, FirstName, LastName, Species, CommsAddress, GalacticNumber)
    -> VALUES 
    -> ('Z123456789', 'Appolo', 'The Explorer', 'Apoololion', 'Appolo@Appolo.space', '9876543210');
Query OK, 1 row affected (0.001 sec)

MariaDB [oaburubdb]> INSERT INTO Space_Crew (HotelID, CrewName, GalacticRole, GalacticShift, Species, GalacticCredits) 
    -> VALUES 
    -> (1, 'Robo-Janitor X9', 'Housekeeping Droid', '08:00:00', 'Robotic', 15000.00);
Query OK, 1 row affected (0.011 sec)

MariaDB [oaburubdb]> INSERT INTO Star_Reservation (GuestID, RoomID, CheckInStardate, CheckOutStardate, ReservationStatus, NumberOfZoglings, NumberOfJuveniles) 
    -> VALUES 
    -> ('Z123456789', 1, '2024-12-10', '2024-12-24', 'Confirmed', 1, 0);
Query OK, 1 row affected (0.001 sec)

MariaDB [oaburubdb]> INSERT INTO Galactic_Payment (ReservationID, PaymentAmount, PaymentMethod) 
    -> VALUES 
    -> (1, 1500.00, 'Galactic Credit Card');
Query OK, 1 row affected (0.002 sec)

MariaDB [oaburubdb]> INSERT INTO Cosmic_Refund (ReservationID, RefundStardate, RefundAmount) 
    -> VALUES 
    -> (1, '2024-12-22', 300.00);
Query OK, 1 row affected (0.001 sec)

MariaDB [oaburubdb]> SELECT RoomID, RoomType, GalacticRate, Amenities
    -> FROM Cosmic_Room
    -> WHERE OccupancyStatus = 'Available' AND HotelID = 1
    -> ORDER BY GalacticRate ASC;
+--------+------------+--------------+---------------------------------------+
| RoomID | RoomType   | GalacticRate | Amenities                             |
+--------+------------+--------------+---------------------------------------+
|      1 | Single Pod |       100.00 | WIFI,Interstellar TV,Anti-Gravity Bed |
+--------+------------+--------------+---------------------------------------+
1 row in set (0.001 sec)

MariaDB [oaburubdb]> SELECT Star_Reservation.ReservationID, Intergalactic_Guest.FirstName, Intergalactic_Guest.LastName, 
    ->        Star_Reservation.CheckInStardate, Star_Reservation.CheckOutStardate, Star_Reservation.ReservationStatus
    -> FROM Star_Reservation
    -> JOIN Intergalactic_Guest ON Star_Reservation.GuestID = Intergalactic_Guest.GuestID
    -> WHERE Intergalactic_Guest.LastName = 'Apollo';
Empty set (0.001 sec)

MariaDB [oaburubdb]> SELECT CrewName, GalacticRole, GalacticShift, Species
    -> FROM Space_Crew
    -> WHERE HotelID = 1
    -> ORDER BY GalacticShift ASC;
+-----------------+--------------------+---------------+---------+
| CrewName        | GalacticRole       | GalacticShift | Species |
+-----------------+--------------------+---------------+---------+
| Robo-Janitor X9 | Housekeeping Droid | 08:00:00      | Robotic |
+-----------------+--------------------+---------------+---------+
1 row in set (0.001 sec)

