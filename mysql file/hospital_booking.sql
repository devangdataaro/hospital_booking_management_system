-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 09, 2026 at 07:32 AM
-- Server version: 8.0.45-0ubuntu0.24.04.1
-- PHP Version: 8.4.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital_booking`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint UNSIGNED NOT NULL,
  `treatment_id` bigint UNSIGNED DEFAULT NULL,
  `doctor_id` bigint UNSIGNED NOT NULL,
  `treatment_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `snapshot_duration` int NOT NULL,
  `snapshot_price` decimal(10,2) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `patient_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `patient_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `patient_phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_cancelled` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `treatment_id`, `doctor_id`, `treatment_title`, `snapshot_duration`, `snapshot_price`, `start_datetime`, `end_datetime`, `patient_name`, `patient_email`, `patient_phone`, `is_cancelled`, `created_at`, `updated_at`) VALUES
(1, 6, 2, 'Blood Test', 10, 40.00, '2026-05-10 09:00:00', '2026-05-10 09:10:00', 'John Patient', 'john.patient@email.com', '+1234567890', 0, '2026-05-09 01:36:22', '2026-05-09 01:36:22'),
(2, 6, 2, 'Blood Test', 10, 40.00, '2026-05-10 10:00:00', '2026-05-10 10:10:00', 'devang shah', 'devang@gmail.com', '+1234567880', 1, '2026-05-09 01:37:19', '2026-05-09 01:40:09');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-available_slots:v0:t2:20260510:20260512:6', 'a:0:{}', 1778310357),
('laravel-cache-available_slots:v0:t2:20260510:20260512:all', 'a:0:{}', 1778310339),
('laravel-cache-available_slots:v0:t6:20260510:20260512:2', 'a:3:{s:10:\"2026-05-10\";a:2:{i:0;s:5:\"09:10\";i:1;s:5:\"16:50\";}s:10:\"2026-05-11\";a:2:{i:0;s:5:\"09:00\";i:1;s:5:\"16:50\";}s:10:\"2026-05-12\";a:2:{i:0;s:5:\"09:00\";i:1;s:5:\"16:50\";}}', 1778311688),
('laravel-cache-available_slots:v0:t6:20260510:20260512:all', 'a:3:{s:10:\"2026-05-10\";a:36:{i:0;s:5:\"09:00\";i:1;s:5:\"09:10\";i:2;s:5:\"09:20\";i:3;s:5:\"09:30\";i:4;s:5:\"09:40\";i:5;s:5:\"09:50\";i:6;s:5:\"10:00\";i:7;s:5:\"10:10\";i:8;s:5:\"10:20\";i:9;s:5:\"10:30\";i:10;s:5:\"10:40\";i:11;s:5:\"10:50\";i:12;s:5:\"11:00\";i:13;s:5:\"11:10\";i:14;s:5:\"11:20\";i:15;s:5:\"11:30\";i:16;s:5:\"11:40\";i:17;s:5:\"11:50\";i:18;s:5:\"14:00\";i:19;s:5:\"14:10\";i:20;s:5:\"14:20\";i:21;s:5:\"14:30\";i:22;s:5:\"14:40\";i:23;s:5:\"14:50\";i:24;s:5:\"15:00\";i:25;s:5:\"15:10\";i:26;s:5:\"15:20\";i:27;s:5:\"15:30\";i:28;s:5:\"15:40\";i:29;s:5:\"15:50\";i:30;s:5:\"16:00\";i:31;s:5:\"16:10\";i:32;s:5:\"16:20\";i:33;s:5:\"16:30\";i:34;s:5:\"16:40\";i:35;s:5:\"16:50\";}s:10:\"2026-05-11\";a:36:{i:0;s:5:\"09:00\";i:1;s:5:\"09:10\";i:2;s:5:\"09:20\";i:3;s:5:\"09:30\";i:4;s:5:\"09:40\";i:5;s:5:\"09:50\";i:6;s:5:\"10:00\";i:7;s:5:\"10:10\";i:8;s:5:\"10:20\";i:9;s:5:\"10:30\";i:10;s:5:\"10:40\";i:11;s:5:\"10:50\";i:12;s:5:\"11:00\";i:13;s:5:\"11:10\";i:14;s:5:\"11:20\";i:15;s:5:\"11:30\";i:16;s:5:\"11:40\";i:17;s:5:\"11:50\";i:18;s:5:\"14:00\";i:19;s:5:\"14:10\";i:20;s:5:\"14:20\";i:21;s:5:\"14:30\";i:22;s:5:\"14:40\";i:23;s:5:\"14:50\";i:24;s:5:\"15:00\";i:25;s:5:\"15:10\";i:26;s:5:\"15:20\";i:27;s:5:\"15:30\";i:28;s:5:\"15:40\";i:29;s:5:\"15:50\";i:30;s:5:\"16:00\";i:31;s:5:\"16:10\";i:32;s:5:\"16:20\";i:33;s:5:\"16:30\";i:34;s:5:\"16:40\";i:35;s:5:\"16:50\";}s:10:\"2026-05-12\";a:36:{i:0;s:5:\"09:00\";i:1;s:5:\"09:10\";i:2;s:5:\"09:20\";i:3;s:5:\"09:30\";i:4;s:5:\"09:40\";i:5;s:5:\"09:50\";i:6;s:5:\"10:00\";i:7;s:5:\"10:10\";i:8;s:5:\"10:20\";i:9;s:5:\"10:30\";i:10;s:5:\"10:40\";i:11;s:5:\"10:50\";i:12;s:5:\"11:00\";i:13;s:5:\"11:10\";i:14;s:5:\"11:20\";i:15;s:5:\"11:30\";i:16;s:5:\"11:40\";i:17;s:5:\"11:50\";i:18;s:5:\"14:00\";i:19;s:5:\"14:10\";i:20;s:5:\"14:20\";i:21;s:5:\"14:30\";i:22;s:5:\"14:40\";i:23;s:5:\"14:50\";i:24;s:5:\"15:00\";i:25;s:5:\"15:10\";i:26;s:5:\"15:20\";i:27;s:5:\"15:30\";i:28;s:5:\"15:40\";i:29;s:5:\"15:50\";i:30;s:5:\"16:00\";i:31;s:5:\"16:10\";i:32;s:5:\"16:20\";i:33;s:5:\"16:30\";i:34;s:5:\"16:40\";i:35;s:5:\"16:50\";}}', 1778310324);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `doctor_treatment`
--

CREATE TABLE `doctor_treatment` (
  `id` bigint UNSIGNED NOT NULL,
  `doctor_id` bigint UNSIGNED NOT NULL,
  `treatment_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `doctor_treatment`
--

INSERT INTO `doctor_treatment` (`id`, `doctor_id`, `treatment_id`, `created_at`, `updated_at`) VALUES
(5, 3, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(6, 5, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(7, 6, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(8, 8, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(9, 9, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(10, 4, 3, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(11, 5, 3, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(12, 8, 3, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(13, 10, 3, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(14, 8, 4, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(15, 9, 4, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(16, 11, 4, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(17, 5, 5, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(18, 6, 5, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(19, 9, 5, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(20, 11, 5, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(21, 2, 6, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(22, 3, 6, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(23, 6, 6, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(24, 8, 6, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(25, 11, 6, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(26, 3, 7, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(27, 4, 7, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(28, 5, 7, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(29, 9, 7, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(30, 11, 7, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(31, 7, 8, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(32, 8, 8, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(33, 2, 9, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(34, 3, 9, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(35, 4, 9, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(36, 4, 10, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(37, 5, 10, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(38, 6, 10, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(39, 9, 10, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(40, 10, 10, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(41, 2, 11, '2026-05-09 01:11:35', '2026-05-09 01:11:35'),
(42, 3, 11, '2026-05-09 01:11:35', '2026-05-09 01:11:35'),
(43, 4, 11, '2026-05-09 01:11:35', '2026-05-09 01:11:35'),
(44, 2, 12, '2026-05-09 01:11:48', '2026-05-09 01:11:48'),
(45, 3, 12, '2026-05-09 01:11:48', '2026-05-09 01:11:48'),
(46, 4, 12, '2026-05-09 01:11:48', '2026-05-09 01:11:48'),
(47, 2, 13, '2026-05-09 01:13:57', '2026-05-09 01:13:57'),
(48, 3, 13, '2026-05-09 01:13:57', '2026-05-09 01:13:57'),
(49, 4, 13, '2026-05-09 01:13:57', '2026-05-09 01:13:57'),
(50, 2, 1, '2026-05-09 01:14:28', '2026-05-09 01:14:28'),
(51, 3, 1, '2026-05-09 01:14:28', '2026-05-09 01:14:28'),
(52, 4, 1, '2026-05-09 01:14:28', '2026-05-09 01:14:28'),
(53, 5, 1, '2026-05-09 01:14:28', '2026-05-09 01:14:28');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_05_09_041552_create_treatments_table', 1),
(5, '2026_05_09_041600_create_bookings_table', 1),
(6, '2026_05_09_041600_create_doctor_treatment_table', 1),
(7, '2026_05_09_041600_create_slots_table', 1),
(8, '2026_05_09_042006_create_personal_access_tokens_table', 1),
(9, '2026_05_09_050000_create_roles_table', 1),
(10, '2026_05_09_050001_create_permissions_table', 1),
(11, '2026_05_09_050002_create_role_permission_table', 1),
(12, '2026_05_09_050003_create_user_role_table', 1),
(13, '2026_05_09_053734_create_oauth_auth_codes_table', 2),
(14, '2026_05_09_053735_create_oauth_access_tokens_table', 2),
(15, '2026_05_09_053736_create_oauth_refresh_tokens_table', 2),
(16, '2026_05_09_053737_create_oauth_clients_table', 2),
(17, '2026_05_09_053738_create_oauth_device_codes_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` char(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `client_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `oauth_access_tokens`
--

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('00372ce26439cbdc5c10275ee2814ee8b066a3113a0fe97b329d90e27cedaec4e7f4fa4195e986a3', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:42:57', '2026-05-09 00:42:57', '2026-11-09 06:12:57'),
('0c42e2d5c46883c0843ffe4971a7e580929d9bb913825fbd20cc91412fb80f3030afb16b2207b37f', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:44:33', '2026-05-09 00:44:33', '2026-11-09 06:14:33'),
('1631a2d616e2c30a71f7cbfcbf8c21e71be988f635e7bc6d3598b305c97055131f42cbe47af5c40b', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 01:59:24', '2026-05-09 01:59:24', '2026-11-09 07:29:24'),
('191e4c16a2d8b9307fe70d1542880eba9ffb0bca9dfc7310d9122d81298fe627b08b1e1a9cd7b618', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:20:00', '2026-05-09 00:20:00', '2026-11-09 05:50:00'),
('1f07da8aabc282d1f5625948130f1180793bc6dfbb2991aa4a975707149684f61962803525d7f5d3', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:46:33', '2026-05-09 00:46:33', '2026-11-09 06:16:33'),
('22e6c987df34801377e69ed8321fd453d9077adfff2b6da4bc510b54c4e84db14a3a079889d5bad8', 2, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 01:15:42', '2026-05-09 01:15:42', '2026-11-09 06:45:42'),
('33a75ddccd490f22be43e19482fd74d0e3a41fd20dcd7f58179975572dcf46941e853443152f0d48', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 01:08:10', '2026-05-09 01:08:10', '2026-11-09 06:38:10'),
('3ffcabdc0d324b91addf36cfcfa477aaf5d198527dc20f78dd8f37fa8d0473bf1071090bf48b6ff7', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:34:32', '2026-05-09 00:34:32', '2026-11-09 06:04:32'),
('5ba69399bcfbd7f36f8fc0e65a4bc5523596f96c9f444d5971138ddeb10bebe0f89a7001ddb0fb9a', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:36:05', '2026-05-09 00:36:05', '2026-11-09 06:06:05'),
('a928f9241d3549664442c37e5fdf77c0be577aa0d524d8853136e02570386e0b4c206da4dbaac552', 2, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:45:13', '2026-05-09 00:45:13', '2026-11-09 06:15:13'),
('c4f31e9050cd61de50239733f6f9807ea1b93aea1f3f43b0c6af7b900c8a8a56481a763fc7bdaa21', 2, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 01:59:30', '2026-05-09 01:59:30', '2026-11-09 07:29:30'),
('c8fa4a95d817da00c67c9daa8f47f479cadbd074162b927c8f4185a1fee8966948b04c52779e0bd5', 1, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:19:48', '2026-05-09 00:19:48', '2026-11-09 05:49:48'),
('f3224063a7a99a346079286e4dd932db8174dd3a2f420b969f9c6426134c4f42726b028a56a251d0', 2, '019e0b46-9c96-73f7-9cf3-76983763f0e0', 'Hospital Booking API Token', '[]', 0, '2026-05-09 00:46:28', '2026-05-09 00:46:28', '2026-11-09 06:16:28');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` char(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `client_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `redirect_uris` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `grant_types` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `owner_type`, `owner_id`, `name`, `secret`, `provider`, `redirect_uris`, `grant_types`, `revoked`, `created_at`, `updated_at`) VALUES
('019e0b3f-2c1b-7224-8023-62cfd5d0c410', NULL, NULL, 'Hospital Booking API', '$2y$12$QDivMG.62eWIiaBxmPtsJuexd0dJp2eg42v7gZyATEIOJ6xfrUeUK', 'users', '[]', '[\"password\",\"refresh_token\"]', 0, '2026-05-09 00:09:09', '2026-05-09 00:09:09'),
('019e0b46-9c96-73f7-9cf3-76983763f0e0', NULL, NULL, 'Hospital Booking Personal Access Client', '$2y$12$aeeZBuIUhuA7ygzEN7o7UerNy9Y.d2QE1zJwxjmDz.lhV4IdMn0OK', 'users', '[]', '[\"personal_access\"]', 0, '2026-05-09 00:17:17', '2026-05-09 00:17:17');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_device_codes`
--

CREATE TABLE `oauth_device_codes` (
  `id` char(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `client_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_code` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `user_approved_at` datetime DEFAULT NULL,
  `last_polled_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` char(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` char(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `group` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `slug`, `description`, `group`, `created_at`, `updated_at`) VALUES
(1, 'Create User', 'user.create', 'Create new users/doctors', 'User Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(2, 'Edit User', 'user.edit', 'Edit user profile', 'User Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(3, 'View Users', 'user.view', 'View list of users/doctors', 'User Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(4, 'Delete User', 'user.delete', 'Delete users', 'User Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(5, 'Create Treatment', 'treatment.create', 'Create new treatments', 'Treatment Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(6, 'Edit Treatment', 'treatment.edit', 'Edit existing treatments', 'Treatment Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(7, 'Delete Treatment', 'treatment.delete', 'Delete treatments', 'Treatment Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(8, 'View Treatments', 'treatment.view', 'View list of treatments', 'Treatment Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(9, 'Create Slot', 'slot.create', 'Create availability slots', 'Slot Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(10, 'Edit Slot', 'slot.edit', 'Edit availability slots', 'Slot Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(11, 'Delete Slot', 'slot.delete', 'Delete availability slots', 'Slot Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(12, 'View Slots', 'slot.view', 'View own availability slots', 'Slot Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(13, 'View All Slots', 'slot.view-all', 'View all doctors slots', 'Slot Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(14, 'Create Booking', 'booking.create', 'Create new bookings', 'Booking Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(15, 'Cancel Booking', 'booking.cancel', 'Cancel bookings', 'Booking Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(16, 'View Bookings', 'booking.view', 'View own bookings', 'Booking Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(17, 'View All Bookings', 'booking.view-all', 'View all bookings', 'Booking Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(18, 'Edit Booking', 'booking.edit', 'Edit bookings', 'Booking Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(19, 'Manage Roles', 'role.manage', 'Create and manage roles', 'Role Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(20, 'Manage Permissions', 'permission.manage', 'Assign permissions to roles', 'Permission Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(21, 'Assign Roles', 'role.assign', 'Assign roles to users', 'Role Management', '2026-05-08 23:52:49', '2026-05-08 23:52:49');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '9ce47172fe4fd1fc928d979fc2708fb486ebb8507e3c2ffae2e5b69bcbc26042', '[\"*\"]', NULL, NULL, '2026-05-09 00:05:20', '2026-05-09 00:05:20');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'admin', 'Full system access with all permissions', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(2, 'Doctor', 'doctor', 'Medical professional with slot and booking management', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(3, 'Patient', 'patient', 'Patient with booking capabilities', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(4, 'Receptionist', 'receptionist', 'Front desk staff managing bookings', '2026-05-08 23:52:49', '2026-05-08 23:52:49');

-- --------------------------------------------------------

--
-- Table structure for table `role_permission`
--

CREATE TABLE `role_permission` (
  `id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`id`, `role_id`, `permission_id`, `created_at`, `updated_at`) VALUES
(1, 1, 15, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(2, 1, 18, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(3, 1, 17, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(4, 1, 20, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(5, 1, 21, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(6, 1, 19, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(7, 1, 13, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(8, 1, 5, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(9, 1, 7, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(10, 1, 6, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(11, 1, 8, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(12, 1, 1, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(13, 1, 4, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(14, 1, 2, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(15, 1, 3, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(16, 2, 15, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(17, 2, 16, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(18, 2, 9, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(19, 2, 11, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(20, 2, 10, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(21, 2, 12, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(22, 2, 8, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(23, 2, 2, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(24, 3, 14, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(25, 3, 16, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(26, 3, 8, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(27, 3, 2, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(28, 3, 3, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(29, 4, 15, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(30, 4, 14, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(31, 4, 18, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(32, 4, 17, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(33, 4, 8, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(34, 4, 3, '2026-05-08 23:52:49', '2026-05-08 23:52:49');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('pUpeXALJV4hxTqZP8U3BYhhT36fxMPjSSMr72srU', NULL, '127.0.0.1', 'PostmanRuntime/7.49.1', 'eyJfdG9rZW4iOiJFb1RMVFYxU2NyOTliRFVXenRRbmFvckxIN1pIRlRMTTZkMkkzenE2IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL2xvY2FsaG9zdDo4MDAwIiwicm91dGUiOm51bGx9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19', 1778308379);

-- --------------------------------------------------------

--
-- Table structure for table `slots`
--

CREATE TABLE `slots` (
  `id` bigint UNSIGNED NOT NULL,
  `doctor_id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `slots`
--

INSERT INTO `slots` (`id`, `doctor_id`, `date`, `start_time`, `end_time`, `created_at`, `updated_at`) VALUES
(1, 2, '2026-05-10', '09:00:00', '12:00:00', '2026-05-09 01:16:20', '2026-05-09 01:16:20'),
(2, 2, '2026-05-10', '14:00:00', '17:00:00', '2026-05-09 01:16:20', '2026-05-09 01:16:20'),
(3, 2, '2026-05-11', '09:00:00', '12:00:00', '2026-05-09 01:16:20', '2026-05-09 01:16:20'),
(4, 2, '2026-05-11', '14:00:00', '17:00:00', '2026-05-09 01:16:20', '2026-05-09 01:16:20'),
(5, 2, '2026-05-12', '09:00:00', '12:00:00', '2026-05-09 01:16:20', '2026-05-09 01:16:20'),
(6, 2, '2026-05-12', '14:00:00', '17:00:00', '2026-05-09 01:16:20', '2026-05-09 01:16:20');

-- --------------------------------------------------------

--
-- Table structure for table `treatments`
--

CREATE TABLE `treatments` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `treatments`
--

INSERT INTO `treatments` (`id`, `title`, `duration`, `price`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Updated MRI Scan', 90, 300.00, '2026-05-09 01:15:04', '2026-05-08 23:52:51', '2026-05-09 01:15:04'),
(2, 'ENT Consultation', 20, 80.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(3, 'Orthopedic Consultation', 30, 120.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(4, 'General Check-up', 15, 50.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(5, 'X-Ray', 10, 60.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(6, 'Blood Test', 10, 40.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(7, 'Physical Therapy', 45, 90.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(8, 'Cardiology Consultation', 40, 150.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(9, 'Dermatology Consultation', 25, 85.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(10, 'Eye Examination', 30, 70.00, NULL, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(11, 'MRI Scan', 60, 250.00, NULL, '2026-05-09 01:11:35', '2026-05-09 01:11:35'),
(12, 'MRI Scan', 60, 250.00, NULL, '2026-05-09 01:11:48', '2026-05-09 01:11:48'),
(13, 'MRI Scan', 60, 250.00, NULL, '2026-05-09 01:13:57', '2026-05-09 01:13:57');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Dr. Doctor 10', 'admin@hospital.com', '2026-05-08 23:52:49', '$2y$12$H8U8bv.RHW9wmvz6kjRcgeegGwDyYsy0HxK8dXPkK/f3hDqBWK8fm', 'La5xAVGQWL', '2026-05-08 23:52:49', '2026-05-09 00:50:44'),
(2, 'Dr. Doctor 1', 'doctor1@hospital.com', '2026-05-08 23:52:49', '$2y$12$DxTJBN7OwtE.4Ni01cbgSeWsHe4MfSXt81a132epHEOqHgYRZ0beW', 'aPh9U6mKTs', '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(3, 'Dr. Doctor 2', 'doctor2@hospital.com', '2026-05-08 23:52:49', '$2y$12$WeOHBcj6xkojC25d7I/BXereUc2k2v/vqj8NOzUjoyEUUDpoe7LPy', 'IDtqhteegY', '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(4, 'Dr. Doctor 3', 'doctor3@hospital.com', '2026-05-08 23:52:50', '$2y$12$kcZZr/ajqF3mfacu6a11kO0S..3oCRbSvAx3StC6HarAvvi3GaLQu', 'XAHlmS7Rq2', '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(5, 'Dr. Doctor 4', 'doctor4@hospital.com', '2026-05-08 23:52:50', '$2y$12$aC1kE5okqrl3BtuOOWdY2eq/9naGuD7TWptba6ATNFLUq2LaUoNPm', 'T6unIz84Nb', '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(6, 'Dr. Doctor 5', 'doctor5@hospital.com', '2026-05-08 23:52:50', '$2y$12$.PbuUo76siEWbbM9ezOVPOfapNyv48iyFW3wZzpQbGElM6ITtb3IK', 'O5wZifVRsA', '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(7, 'Dr. Doctor 6', 'doctor6@hospital.com', '2026-05-08 23:52:50', '$2y$12$6giHJzZ/p6zUlATpOUCt.usepOQmgvxTlp7XgsU.G41RjTkWMPuCe', 'WysCSTkUKE', '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(8, 'Dr. Doctor 7', 'doctor7@hospital.com', '2026-05-08 23:52:51', '$2y$12$t9HsSQXmiNOwh7C4pILAa.OXpmnjtmAA.7lpWU/JsGZ9Q5OtRTSDS', 'HMo1YiTEdG', '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(9, 'Dr. Doctor 8', 'doctor8@hospital.com', '2026-05-08 23:52:51', '$2y$12$bnJaphORIFquZUrpyXwOgOObRYOPx0cmUJsU3f2DZIV2DoPdgDHJa', '60aDACbRWV', '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(10, 'Dr. Doctor 9', 'doctor9@hospital.com', '2026-05-08 23:52:51', '$2y$12$IyXVE9/j4/.YVrbUI9XqHOXgAcLVhq7lBGUwyRnOLPbKMcnM2wPJu', 'yQdacHpk3b', '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(11, 'Dr. Doctor 10', 'doctor10@hospital.com', '2026-05-08 23:52:51', '$2y$12$JbapIqp5I/dko7gyfHTkceoQX3OiPf2z5RAlWZMZ9XEfz9nKozvAm', 'kVcjPWviMc', '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(12, 'Test New Doctor', 'testnewdoctor@example.com', NULL, '$2y$12$Jq6.gtRg.VEMKCnQHm9chuBxKAdEBh5i5G3x608GHj7vc.t3VX0UC', NULL, '2026-05-09 01:08:26', '2026-05-09 01:08:26'),
(13, 'Dr. Jane Smith', 'jane.smith@hospital.com', NULL, '$2y$12$GcI.lk8GllOc9Gyd7v./leHIpjfiYIL.cG1Q.N3qexERAjOcdztGy', NULL, '2026-05-09 01:08:47', '2026-05-09 01:08:47'),
(14, 'Test New Doctor', 'testnewdoctor123@example.com', NULL, '$2y$12$GwhItctFSIatKg/jqsvM7eeaNsnfemKZs5zgv/okjE56woyp3VcpG', NULL, '2026-05-09 01:18:33', '2026-05-09 01:18:33');

-- --------------------------------------------------------

--
-- Table structure for table `user_role`
--

CREATE TABLE `user_role` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_role`
--

INSERT INTO `user_role` (`id`, `user_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(2, 2, 2, '2026-05-08 23:52:49', '2026-05-08 23:52:49'),
(3, 3, 2, '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(4, 4, 2, '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(5, 5, 2, '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(6, 6, 2, '2026-05-08 23:52:50', '2026-05-08 23:52:50'),
(7, 7, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(8, 8, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(9, 9, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(10, 10, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(11, 11, 2, '2026-05-08 23:52:51', '2026-05-08 23:52:51'),
(12, 12, 2, '2026-05-09 01:08:26', '2026-05-09 01:08:26'),
(13, 13, 2, '2026-05-09 01:08:47', '2026-05-09 01:08:47'),
(14, 14, 2, '2026-05-09 01:18:33', '2026-05-09 01:18:33');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookings_treatment_id_index` (`treatment_id`),
  ADD KEY `bookings_doctor_id_index` (`doctor_id`),
  ADD KEY `bookings_start_datetime_index` (`start_datetime`),
  ADD KEY `bookings_end_datetime_index` (`end_datetime`),
  ADD KEY `bookings_is_cancelled_index` (`is_cancelled`),
  ADD KEY `bookings_doctor_id_start_datetime_end_datetime_index` (`doctor_id`,`start_datetime`,`end_datetime`),
  ADD KEY `bookings_patient_email_patient_phone_index` (`patient_email`,`patient_phone`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `doctor_treatment`
--
ALTER TABLE `doctor_treatment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `doctor_treatment_doctor_id_treatment_id_unique` (`doctor_id`,`treatment_id`),
  ADD KEY `doctor_treatment_doctor_id_index` (`doctor_id`),
  ADD KEY `doctor_treatment_treatment_id_index` (`treatment_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_owner_type_owner_id_index` (`owner_type`,`owner_id`);

--
-- Indexes for table `oauth_device_codes`
--
ALTER TABLE `oauth_device_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `oauth_device_codes_user_code_unique` (`user_code`),
  ADD KEY `oauth_device_codes_user_id_index` (`user_id`),
  ADD KEY `oauth_device_codes_client_id_index` (`client_id`);

--
-- Indexes for table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`),
  ADD UNIQUE KEY `permissions_slug_unique` (`slug`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`),
  ADD UNIQUE KEY `roles_slug_unique` (`slug`);

--
-- Indexes for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_permission_role_id_permission_id_unique` (`role_id`,`permission_id`),
  ADD KEY `role_permission_permission_id_foreign` (`permission_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `slots`
--
ALTER TABLE `slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `slots_doctor_id_index` (`doctor_id`),
  ADD KEY `slots_date_index` (`date`),
  ADD KEY `slots_doctor_id_date_index` (`doctor_id`,`date`),
  ADD KEY `slots_date_start_time_end_time_index` (`date`,`start_time`,`end_time`);

--
-- Indexes for table `treatments`
--
ALTER TABLE `treatments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `treatments_title_index` (`title`),
  ADD KEY `treatments_duration_price_index` (`duration`,`price`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_email_password_index` (`email`,`password`),
  ADD KEY `users_id_index` (`id`);

--
-- Indexes for table `user_role`
--
ALTER TABLE `user_role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_role_user_id_role_id_unique` (`user_id`,`role_id`),
  ADD KEY `user_role_role_id_foreign` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `doctor_treatment`
--
ALTER TABLE `doctor_treatment`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `slots`
--
ALTER TABLE `slots`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `treatments`
--
ALTER TABLE `treatments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `user_role`
--
ALTER TABLE `user_role`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_treatment_id_foreign` FOREIGN KEY (`treatment_id`) REFERENCES `treatments` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `doctor_treatment`
--
ALTER TABLE `doctor_treatment`
  ADD CONSTRAINT `doctor_treatment_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `doctor_treatment_treatment_id_foreign` FOREIGN KEY (`treatment_id`) REFERENCES `treatments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `role_permission_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permission_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `slots`
--
ALTER TABLE `slots`
  ADD CONSTRAINT `slots_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_role`
--
ALTER TABLE `user_role`
  ADD CONSTRAINT `user_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_role_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
