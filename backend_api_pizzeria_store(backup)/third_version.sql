-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:4306
-- Generation Time: May 08, 2023 at 08:34 AM
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `items_table`
--
ALTER TABLE `items_table`
  ADD PRIMARY KEY (`item_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `items_table`
--
ALTER TABLE `items_table`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
