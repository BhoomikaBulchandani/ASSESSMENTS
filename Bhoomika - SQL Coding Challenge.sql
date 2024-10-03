---SQL SCHEMA----
USE CODINGCHALLENGE
GO
---CREATE TABLE VEHICLE---

CREATE TABLE Vehicle (
  VehicleID INT PRIMARY KEY IDENTITY(1,1),
  Make VARCHAR(50),
  Model VARCHAR(50),
  Year INT,
  DailyRate DECIMAL(10, 2),
  Status BIT NOT NULL,
  PassengerCapacity INT,
  EngineCapacity DECIMAL(5, 2)
)


---CREATE TABLE CUSTOMER---

CREATE TABLE Customer (
  CustomerID INT PRIMARY KEY IDENTITY(1,1),
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Email VARCHAR(100) UNIQUE,
  PhoneNumber VARCHAR(20) UNIQUE
)

---CREATE TABLE LEASE---

CREATE TABLE Lease (
  LeaseID INT PRIMARY KEY IDENTITY(1,1),
  VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),
  CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
  StartDate DATE,
  EndDate DATE,
  Type VARCHAR(15),
  CONSTRAINT t_check CHECK (Type IN ('DailyLease', 'MonthlyLease'))
)

---CREATE TABLE PAYMENT---

CREATE TABLE Payment (
  PaymentID INT PRIMARY KEY IDENTITY(1,1),
  LeaseID INT FOREIGN KEY REFERENCES Lease(leaseID),
  PaymentDate DATE,
  Amount DECIMAL(10, 2)
)



INSERT INTO Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
VALUES 
('Toyota', 'Camry', 2022, 50.00, 1, 4, 145.00),
('Honda', 'Civic', 2023, 45.00, 1, 7, 150.00),
('Ford', 'Focus', 2022, 48.00, 0, 4, 140.00),
('Nissan', 'Altima', 2023, 52.00, 1, 7, 120.00),
('Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 180.00),
('Hyundai', 'Sonata', 2023, 49.00, 0, 7, 140.00),
('BMW', '3 Series', 2023, 60.00, 1, 7, 249.00)

INSERT INTO Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
VALUES 
('Mercedes', 'C-Class', 2022, 58.00, 1, 5, 259.00),
('Audi', 'A4', 2022, 55.00, 0, 4, 250.00),
('Lexus', 'ES', 2023, 54.00, 1, 4, 250.00)


INSERT INTO Customer (firstName, lastName, email, phoneNumber)
VALUES 
('John', 'Doe', 'johndoe@example.com', '555-555-5555'),
('Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
('Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
('Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
('David', 'Lee', 'david@example.com', '555-987-6543'),
('Laura', 'Hall', 'laura@example.com', '555-234-5678'),
('Michael', 'Davis', 'michael@example.com', '555-876-5432'),
('Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
('William', 'Taylor', 'william@example.com', '555-321-6547'),
('Olivia', 'Adams', 'olivia@example.com', '555-765-4321')

INSERT INTO Lease (vehicleID, customerID, startDate, endDate, type)
VALUES 
(11, 1, '2023-01-01', '2023-01-05', 'DailyLease'),
(12, 2, '2023-02-15', '2023-02-28', 'MonthlyLease'),
(13, 3, '2023-03-10', '2023-03-15', 'DailyLease'),
(14, 4, '2023-04-20', '2023-04-30', 'MonthlyLease'),
(15, 5, '2023-05-05', '2023-05-10', 'DailyLease'),
(14, 3, '2023-06-15', '2023-06-30', 'MonthlyLease'),
(17, 7, '2023-07-01', '2023-07-10', 'DailyLease'),
(18, 8, '2023-08-12', '2023-08-15', 'MonthlyLease'),
(13, 3, '2023-09-07', '2023-09-10', 'DailyLease'),
(20, 10, '2023-10-10', '2023-10-31', 'MonthlyLease')


INSERT INTO Payment (leaseID, paymentDate, amount)
VALUES 
(3, '2023-01-03', 200.00),
(4, '2023-02-20', 1000.00),
(5, '2023-03-12', 75.00),
(6, '2023-04-25', 900.00),
(7, '2023-05-07', 60.00),
(8, '2023-06-18', 1200.00),
(9, '2023-07-03', 40.00),
(10, '2023-08-14', 1100.00),
(11, '2023-09-09', 80.00),
(12, '2023-10-25', 1500.00)


SELECT * FROM Vehicle
SELECT * FROM Customer
SELECT * FROM Lease
SELECT * FROM Payment


-----WRITING QUERIES-----


---1: Update the daily rate for a Mercedes car to 68.

UPDATE Vehicle
SET dailyRate = 68
WHERE make = 'Mercedes'


---2: Delete a specific customer and all associated leases and payments.

DELETE FROM Payment
WHERE LeaseID IN (SELECT LeaseID FROM Lease WHERE CustomerID = 1)

DELETE FROM Lease
WHERE CustomerID = 1

DELETE FROM Customer
WHERE CustomerID = 1


---3: Rename the "paymentDate" column in the Payment table to "transactionDate".

sp_rename 'Payment.PaymentDate', 'TransactionDate', 'column'


---4: Find a specific customer by email.

SELECT *
FROM Customer
WHERE email = 'robert@example.com'


---5: Get active leases for a specific customer.

SELECT *
FROM Lease
WHERE CustomerID = 3
  AND endDate >= GETDATE()

SELECT C.CustomerID, C.FirstName, C.LastName, L.LeaseID, L.StartDate, L.EndDate
FROM Lease L
JOIN Customer C ON L.CustomerID = C.CustomerID
WHERE C.CustomerID = 3
  AND L.EndDate >= GETDATE()


---6: Find all payments made by a customer with a specific phone number:

SELECT P.*
FROM Payment P
JOIN Lease L ON P.LeaseID = L.LeaseID
JOIN Customer C ON L.CustomerID = C.CustomerID
WHERE C.PhoneNumber = '555-123-4567'


---7: Calculate the average daily rate of all available cars:

SELECT AVG(DailyRate) AS AverageDailyRate
FROM Vehicle
WHERE Status = '1'


---8: Find the car with the highest daily rate:

SELECT TOP 1 *
FROM Vehicle
ORDER BY DailyRate DESC


---9:  Retrieve all cars leased by a specific customer:

SELECT V.*
FROM Vehicle V
JOIN Lease L ON V.VehicleID = L.VehicleID
JOIN Customer C ON L.CustomerID = C.CustomerID
WHERE C.CustomerID = 3


---10: Find the details of the most recent lease:


SELECT TOP 1 L.*
FROM Lease L
ORDER BY L.StartDate DESC


---11: List all payments made in the year 2023:

SELECT *
FROM Payment
WHERE YEAR(TransactionDate) = 2023


---12: Retrieve customers who have not made any payments:

SELECT C.*
FROM Customer C
LEFT JOIN Lease L ON C.CustomerID = L.CustomerID
LEFT JOIN Payment P ON L.LeaseID = P.LeaseID
WHERE P.PaymentID IS NULL


---13: Retrieve Car Details and Their Total Payments:

SELECT V.VehicleID, V.Make, V.Model, V.Year, V.DailyRate, SUM(P.Amount) AS TotalPayments
FROM Vehicle V
JOIN Lease L ON V.VehicleID = L.VehicleID
JOIN Payment P ON L.LeaseID = P.LeaseID
GROUP BY V.VehicleID, V.Make, V.Model, V.Year, V.DailyRate


---14: Calculate Total Payments for Each Customer:

SELECT C.customerID, C.firstName, C.lastName, SUM(P.amount) AS TotalPayments
FROM Customer C
JOIN Lease L ON C.customerID = L.customerID
JOIN Payment P ON L.leaseID = P.leaseID
GROUP BY C.customerID, C.firstName, C.lastName


---15: List Car Details for Each Lease:

SELECT L.*, V.Make, V.Model, V.Year
FROM Lease L
JOIN Vehicle V ON L.VehicleID = V.VehicleID


---16: Retrieve Details of Active Leases with Customer and Car Information:

SELECT L.LeaseID, C.FirstName, C.LastName, V.Make, V.Model, V.Year, L.StartDate, L.EndDate
FROM Lease L
JOIN Customer C ON L.CustomerID = C.CustomerID
JOIN Vehicle V ON L.VehicleID = V.VehicleID
WHERE L.EndDate >= GETDATE()


---17: Find the Customer Who Has Spent the Most on Leases:

SELECT TOP 1 C.CustomerID, C.FirstName, C.LastName, SUM(P.amount) AS TotalSpent
FROM Customer C
JOIN Lease L ON C.CustomerID = L.CustomerID
JOIN Payment P ON L.LeaseID = P.LeaseID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY TotalSpent DESC


---18:  List All Cars with Their Current Lease Information:


SELECT V.*, L.LeaseID, C.FirstName, C.LastName, L.StartDate, L.EndDate
FROM Vehicle V
INNER JOIN Lease L ON V.vehicleID = L.vehicleID
INNER JOIN Customer C ON L.customerID = C.customerID
WHERE L.endDate >= GETDATE()

