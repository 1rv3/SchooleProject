-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.28-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for laptopstore
CREATE DATABASE IF NOT EXISTS `laptopstore` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `laptopstore`;

-- Dumping structure for table laptopstore.carts
CREATE TABLE IF NOT EXISTS `carts` (
  `CartId` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerId` int(11) NOT NULL,
  `CreatedAt` datetime DEFAULT current_timestamp(),
  `UpdatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`CartId`),
  KEY `CustomerId` (`CustomerId`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `customers` (`CustomerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table laptopstore.carts: ~0 rows (approximately)

-- Dumping structure for table laptopstore.cart_items
CREATE TABLE IF NOT EXISTS `cart_items` (
  `CartItemId` int(11) NOT NULL AUTO_INCREMENT,
  `CartId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL DEFAULT 1,
  `AddedAt` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`CartItemId`),
  KEY `CartId` (`CartId`),
  KEY `ProductId` (`ProductId`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`CartId`) REFERENCES `carts` (`CartId`),
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `products` (`ProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table laptopstore.cart_items: ~0 rows (approximately)

-- Dumping structure for table laptopstore.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `CategoryId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`CategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table laptopstore.categories: ~6 rows (approximately)
INSERT INTO `categories` (`CategoryId`, `Name`, `Description`) VALUES
	(1, 'Smartphones', 'Latest smartphones and mobile devices'),
	(2, 'Laptops', 'High-performance laptops for all needs'),
	(3, 'Tablets', 'Portable tablets for work and entertainment'),
	(4, 'Headphones', 'Wireless and wired headphones'),
	(5, 'Smartwatches', 'Wearable smart devices'),
	(6, 'Cameras', 'Professional and amateur cameras');

-- Dumping structure for table laptopstore.customers
CREATE TABLE IF NOT EXISTS `customers` (
  `CustomerId` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` text DEFAULT NULL,
  `RegistrationDate` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`CustomerId`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table laptopstore.customers: ~3 rows (approximately)
INSERT INTO `customers` (`CustomerId`, `FirstName`, `LastName`, `Email`, `Phone`, `Address`, `RegistrationDate`) VALUES
	(1, 'John', 'Doe', 'john.doe@example.com', '555-0101', '123 Main St, Anytown, USA', '2025-05-03 23:35:12'),
	(2, 'Jane', 'Smith', 'jane.smith@example.com', '555-0102', '456 Oak Ave, Somewhere, USA', '2025-05-03 23:35:12'),
	(3, 'Robert', 'Johnson', 'robert.johnson@example.com', '555-0103', '789 Pine Rd, Nowhere, USA', '2025-05-03 23:35:12'),
	(4, 'Ahmad', 'Kabha', 'ahmdkpha.souchal@gmail.com', '0527988448', 'Brtaa blal bn rbah - Home 71', '2025-05-04 00:40:31');

-- Dumping structure for table laptopstore.orderdetails
CREATE TABLE IF NOT EXISTS `orderdetails` (
  `OrderDetailId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderDetailId`),
  KEY `OrderId` (`OrderId`),
  KEY `ProductId` (`ProductId`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`OrderId`) REFERENCES `orders` (`OrderId`),
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `products` (`ProductId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table laptopstore.orderdetails: ~10 rows (approximately)
INSERT INTO `orderdetails` (`OrderDetailId`, `OrderId`, `ProductId`, `Quantity`, `UnitPrice`) VALUES
	(1, 1, 4, 1, 6999.00),
	(2, 1, 3, 2, 999.00),
	(3, 2, 2, 1, 3499.00),
	(4, 2, 5, 1, 4299.00),
	(5, 3, 6, 1, 7499.00),
	(6, 3, 1, 1, 1299.00),
	(7, 4, 3, 1, 999.00),
	(8, 4, 5, 1, 4299.00),
	(9, 5, 4, 1, 6999.00),
	(10, 5, 6, 1, 7499.00);

-- Dumping structure for table laptopstore.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderId` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerId` int(11) NOT NULL,
  `OrderDate` datetime DEFAULT current_timestamp(),
  `TotalAmount` decimal(10,2) NOT NULL,
  `Status` varchar(20) DEFAULT 'Pending',
  `ShippingAddress` text DEFAULT NULL,
  `PaymentMethod` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`OrderId`),
  KEY `CustomerId` (`CustomerId`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `customers` (`CustomerId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table laptopstore.orders: ~10 rows (approximately)
INSERT INTO `orders` (`OrderId`, `CustomerId`, `OrderDate`, `TotalAmount`, `Status`, `ShippingAddress`, `PaymentMethod`) VALUES
	(1, 4, '2023-05-01 14:30:00', 4200.00, 'Completed', 'الرياض، حي العليا، شارع الملك فهد', 'Credit Card'),
	(2, 2, '2023-05-02 10:15:00', 3150.00, 'Processing', 'جدة، حي الصفا، شارع الأمير سلطان', 'Mada'),
	(3, 3, '2023-05-03 16:45:00', 5600.00, 'Shipped', 'الدمام، حي الخليج، شارع الملك عبدالله', 'Apple Pay'),
	(4, 1, '2023-05-04 09:20:00', 1899.99, 'Pending', 'الرياض، حي النخيل، شارع العروبة', 'Credit Card'),
	(5, 2, '2023-05-05 13:10:00', 2750.50, 'Processing', 'جدة، حي الروضة، شارع التحلية', 'Mada'),
	(6, 3, '2023-05-06 11:30:00', 4300.00, 'Completed', 'الدمام، حي البحيرة، شارع الملك سعود', 'Bank Transfer'),
	(7, 1, '2023-05-07 15:45:00', 3200.75, 'Cancelled', 'الرياض، حي الورود، شارع الثلاثين', 'Credit Card'),
	(8, 2, '2023-05-08 17:20:00', 1500.00, 'Shipped', 'جدة، حي الزهراء، شارع فلسطين', 'Mada'),
	(9, 3, '2023-05-09 12:00:00', 6200.25, 'Processing', 'الدمام، حي الجوهرة، شارع الأمير نايف', 'Apple Pay'),
	(10, 1, '2023-05-10 10:30:00', 2800.00, 'Completed', 'الرياض، حي الصحافة، شارع العليا العام', 'Credit Card');

-- Dumping structure for table laptopstore.products
CREATE TABLE IF NOT EXISTS `products` (
  `ProductId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  `CategoryId` int(11) DEFAULT NULL,
  `SupplierId` int(11) DEFAULT NULL,
  `Price` decimal(10,2) NOT NULL,
  `StockQuantity` int(11) NOT NULL DEFAULT 0,
  `ImageUrl` varchar(255) DEFAULT NULL,
  `Specifications` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`Specifications`)),
  `CreatedAt` datetime DEFAULT current_timestamp(),
  `UpdatedAt` datetime DEFAULT current_timestamp(),
  `Rating` decimal(3,2) DEFAULT 0.00,
  `ReviewCount` int(11) DEFAULT 0,
  `IsOnSale` tinyint(1) DEFAULT 0,
  `SalePrice` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ProductId`),
  KEY `CategoryId` (`CategoryId`),
  KEY `SupplierId` (`SupplierId`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`CategoryId`) REFERENCES `categories` (`CategoryId`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`SupplierId`) REFERENCES `suppliers` (`SupplierId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table laptopstore.products: ~5 rows (approximately)
INSERT INTO `products` (`ProductId`, `Name`, `Description`, `CategoryId`, `SupplierId`, `Price`, `StockQuantity`, `ImageUrl`, `Specifications`, `CreatedAt`, `UpdatedAt`, `Rating`, `ReviewCount`, `IsOnSale`, `SalePrice`) VALUES
	(1, 'Apple Watch Series 8', 'Smart watch with advanced features', 5, 4, 1299.00, 50, 'https://images.unsplash.com/photo-1546868871-7041f2a55e12', '{"Display":"Retina", "WaterResistant":"Yes", "BatteryLife":"18h"}', '2025-05-07 04:35:27', '2025-05-18 19:05:01', 1.00, 48, 0, 1039.00),
	(2, 'Samsung Galaxy S23', 'Flagship smartphone with premium features', 1, 5, 3499.00, 30, 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb', '{"Screen": "6.1 AMOLED", "Camera": "50MP", "Storage": "128GB"}', '2025-05-07 04:37:46', '2025-05-18 19:05:01', 5.00, 124, 0, NULL),
	(3, 'AirPods Pro', 'Wireless earbuds with active noise cancellation', 4, 4, 999.00, 40, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df', '{"NoiseCancellation": "Active", "BatteryLife": "5h", "WirelessCharging": "Yes"}', '2025-05-01 04:37:46', '2025-05-18 19:05:01', 5.00, 89, 0, 849.00),
	(4, 'MacBook Pro M2', 'Professional laptop with M2 chip', 2, 4, 6999.00, 20, 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9', '{"Processor": "M2 Chip", "RAM": "16GB", "Storage": "512GB SSD"}', '2025-05-07 04:37:46', '2025-05-18 19:05:01', 2.00, 56, 0, NULL),
	(5, 'iPad Pro 12.9"', 'Premium tablet with M1 chip', 3, 4, 4299.00, 25, 'https://images.unsplash.com/photo-1585771724684-38269d6639fd', '{"Screen": "12.9 Liquid Retina", "Processor": "M1", "Storage": "128GB"}', '2025-05-07 04:37:46', '2025-05-18 19:05:01', 3.00, 72, 0, 3899.00),
	(6, 'Sony Alpha A7 III', 'Professional mirrorless camera', 6, 5, 7499.00, 15, 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32', '{"Sensor": "24.2MP", "Video": "4K", "Stabilization": "5-axis"}', '2025-05-07 04:37:46', '2025-05-18 19:05:01', 1.00, 93, 0, NULL);

-- Dumping structure for table laptopstore.suppliers
CREATE TABLE IF NOT EXISTS `suppliers` (
  `SupplierId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `ContactPerson` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` text DEFAULT NULL,
  `CreatedAt` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`SupplierId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table laptopstore.suppliers: ~4 rows (approximately)
INSERT INTO `suppliers` (`SupplierId`, `Name`, `ContactPerson`, `Email`, `Phone`, `Address`, `CreatedAt`) VALUES
	(1, 'Dell Technologies', 'John Smith', 'john@dell.com', '1234567890', '1 Dell Way, Round Rock, TX', '2025-05-03 09:54:58'),
	(2, 'HP Inc.', 'Sarah Johnson', 'sarah@hp.com', '2345678901', '1501 Page Mill Rd, Palo Alto, CA', '2025-05-03 09:54:58'),
	(3, 'Lenovo Group', 'Michael Chen', 'michael@lenovo.com', '3456789012', '1009 Think Pl, Morrisville, NC', '2025-05-03 09:54:58'),
	(4, 'Apple Inc.', 'Emily Davis', 'emily@apple.com', '4567890123', '1 Apple Park Way, Cupertino, CA', '2025-05-03 09:54:58'),
	(5, 'Samsung ', 'Samsung ', 'email@samsung.com', '5678901234', 'Samsung Way', '2025-05-09 17:16:43');

-- Dumping structure for table laptopstore.users
CREATE TABLE IF NOT EXISTS `users` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) NOT NULL,
  `PasswordHash` longtext NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Role` varchar(20) NOT NULL DEFAULT 'user',
  `CreatedDate` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Username` (`Username`),
  UNIQUE KEY `Email` (`Email`),
  CONSTRAINT `CK_Users_Role` CHECK (`Role` in ('user','admin'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table laptopstore.users: ~0 rows (approximately)
INSERT INTO `users` (`Id`, `Username`, `PasswordHash`, `Email`, `Role`, `CreatedDate`) VALUES
	(1, 'admin', 'hashed_admin_password', 'admin@example.com', 'admin', '2025-05-14 23:54:00');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
