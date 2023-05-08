-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:4306
-- Generation Time: May 08, 2023 at 09:07 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pizzeria_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_table`
--

CREATE TABLE `admin_table` (
  `admin_id` int(11) NOT NULL,
  `admin_name` varchar(50) NOT NULL,
  `admin_email` varchar(50) NOT NULL,
  `admin_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_table`
--

INSERT INTO `admin_table` (`admin_id`, `admin_name`, `admin_email`, `admin_password`) VALUES
(1, 'Viraj', 'vjdesailab@gmail.com', '12345678');

-- --------------------------------------------------------

--
-- Table structure for table `backup_table`
--

CREATE TABLE `backup_table` (
  `bitem_id` int(11) NOT NULL,
  `bname` text NOT NULL,
  `brating` double NOT NULL,
  `btags` varchar(100) NOT NULL,
  `bprice` double NOT NULL,
  `bpizza_size` varchar(100) NOT NULL,
  `bbase` varchar(100) NOT NULL,
  `bdescription` text NOT NULL,
  `bimage` text NOT NULL,
  `badmin_email` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='for_deleted items';

--
-- Dumping data for table `backup_table`
--

INSERT INTO `backup_table` (`bitem_id`, `bname`, `brating`, `btags`, `bprice`, `bpizza_size`, `bbase`, `bdescription`, `bimage`, `badmin_email`) VALUES
(18, 'Veg Pizza', 5, '[tomato, onion, capsicum]', 250, '[S, M, L]', '[Pan, Cheese]', 'Great Pizza Good Pizza', 'https://firebasestorage.googleapis.com/v0/b/imghoster-28853.appspot.com/o/images%2F2023-04-25%2010%3A21%3A53.983549?alt=media&token=affce18b-b97d-4852-b32e-85eba4a10e89', 'vjdesailab@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `cart_table`
--

CREATE TABLE `cart_table` (
  `cart_id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `style` varchar(100) NOT NULL,
  `size` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_table`
--

INSERT INTO `cart_table` (`cart_id`, `user_id`, `item_id`, `quantity`, `style`, `size`) VALUES
(5, 'snbhat@gmail.com', 1, 1, 'Pan', 'S'),
(6, 'snbhat@gmail.com', 2, 2, 'Cheese', 'S'),
(7, 'snbhat@gmail.com', 1, 1, 'Pan', 'S'),
(18, 'snbhat@gmail.com', 19, 3, 'Pan', 'S');

-- --------------------------------------------------------

--
-- Table structure for table `items_table`
--

CREATE TABLE `items_table` (
  `item_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `rating` int(11) DEFAULT NULL,
  `tags` varchar(100) NOT NULL,
  `price` double NOT NULL,
  `pizza_size` varchar(100) NOT NULL,
  `base` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `image` text NOT NULL,
  `admin_email` text NOT NULL
) ;

--
-- Dumping data for table `items_table`
--

INSERT INTO `items_table` (`item_id`, `name`, `rating`, `tags`, `price`, `pizza_size`, `base`, `description`, `image`, `admin_email`) VALUES
(19, 'Good Pizza', 3, '[tomato,  onion]', 450, '[S,  M]', '[Pan,  Cheese,  Deep]', 'Make Pizza Great Again', 'https://firebasestorage.googleapis.com/v0/b/imghoster-28853.appspot.com/o/images%2F2023-04-25%2010%3A21%3A53.983549?alt=media&token=affce18b-b97d-4852-b32e-85eba4a10e89', 'vjdesailab@gmail.com');

--
-- Triggers `items_table`
--
DELIMITER $$
CREATE TRIGGER `backup` AFTER DELETE ON `items_table` FOR EACH ROW insert into backup_table values (old.item_id, old.name,old.rating,old.tags,old.price,old.pizza_size,
old.base, old.description,old.image,old.admin_email)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_table`
--

CREATE TABLE `user_table` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_table`
--

INSERT INTO `user_table` (`user_id`, `user_name`, `user_email`, `user_password`) VALUES
(11, 'avc123', 'abc123', 'e99a18c428cb38d5f260853678922e03'),
(12, 'viraj', 'viraj', '25d55ad283aa400af464c76d713c07ad'),
(13, 'viraj', 'virajdesai1227@gmail.com', 'fe5a9e378bef0d73f56f5219fdc6eb6c'),
(14, 'Sanjay Bhatt', 'snbhat@gmail.com', '25d55ad283aa400af464c76d713c07ad');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_table`
--
ALTER TABLE `admin_table`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `cart_table`
--
ALTER TABLE `cart_table`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `items_table`
--
ALTER TABLE `items_table`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `user_table`
--
ALTER TABLE `user_table`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_table`
--
ALTER TABLE `admin_table`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cart_table`
--
ALTER TABLE `cart_table`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `items_table`
--
ALTER TABLE `items_table`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_table`
--
ALTER TABLE `user_table`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
