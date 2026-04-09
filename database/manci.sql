-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3307
-- Généré le : mer. 16 avr. 2025 à 16:57
-- Version du serveur : 10.6.5-MariaDB
-- Version de PHP : 8.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `manci`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `devis`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `devis` (`v_devis_id` INT, `v_sumrem` INT, `v_sumtva` INT)  BEGIN

    -- Declaration variable
    DECLARE v_ht float;
    DECLARE v_rem float;
    DECLARE v_tva float;
    DECLARE v_ttc float;
    DECLARE v_euro float;
    DECLARE v_value float;
    DECLARE v_total float;

    -- Euro
    SELECT value INTO v_value FROM euros WHERE status = '1';

    -- Total Proforma
    SELECT SUM(total) INTO v_total FROM devis_ttr, proforma WHERE devis_ttr.id=proforma.devttr_id AND devis_id=v_devis_id;

    -- Remise
    SET v_rem = 0;
    SET v_ht = v_total;
    IF v_sumrem != 0 THEN
        SET v_rem = (v_ht * v_sumrem) / 100;
        SET v_total = v_ht - v_rem;
    END IF;

    -- TVA
    SET v_tva = 0;
    SET v_ttc = v_total;
    IF v_sumtva != 0 THEN
        SET v_tva = (v_ttc * v_sumtva) / 100;
        SET v_ttc = v_ttc + v_tva;
    END IF;

    -- Euro
    SET v_euro = v_ttc / v_value;

    -- Update Devis
    UPDATE devis SET mt_rem = v_rem, mt_tva = v_tva, mt_ht = v_ht, mt_ttc = v_ttc, mt_euro = v_euro WHERE id = v_devis_id;

  END$$

DROP PROCEDURE IF EXISTS `statistic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `statistic` ()  BEGIN

    -- Declaration variable
    DECLARE v_draft int;
    DECLARE v_pending int;
    DECLARE v_approved int;
    DECLARE v_rejected int;
    DECLARE v_validated int;
    DECLARE v_canceled int;
    
    -- Brouillon
    SELECT COUNT(*) INTO v_draft FROM devis WHERE status = '0';

    -- Transmis
    SELECT COUNT(*) INTO v_pending FROM devis WHERE status = '1';

    -- Approuvé
    SELECT COUNT(*) INTO v_approved FROM devis WHERE status = '2';

    -- Rejeté
    SELECT COUNT(*) INTO v_rejected FROM devis WHERE status = '3';

    -- Validé
    SELECT COUNT(*) INTO v_validated FROM devis WHERE status = '4';

    -- Annulé
    SELECT COUNT(*) INTO v_canceled FROM devis WHERE status = '5';

    -- Insertion des données
    INSERT INTO statistic
    (draft, pending, approved, rejected, validated, canceled, status, created_at)
    VALUES
    (v_draft, v_pending, v_approved, v_rejected, v_validated, v_canceled, '1', NOW())
    ON DUPLICATE KEY UPDATE
    status = '1',
    draft = v_draft,
    pending = v_pending,
    rejected = v_rejected,
    canceled = v_canceled,
    approved = v_approved,
    validated = v_validated;

  END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `bill_addr`
--

DROP TABLE IF EXISTS `bill_addr`;
CREATE TABLE IF NOT EXISTS `bill_addr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `client_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `bill_addr`
--

INSERT INTO `bill_addr` (`id`, `libelle`, `content`, `status`, `created_at`, `updated_at`, `client_id`, `user_id`) VALUES
(1, 'ALBACORA, S.A. (RAZON SOCIAL)', 'RECINTO INTERIOR ZONA FRANCA\nEdificio MELKART - Planta 1\' - oficinas 1 y 2\nAvenida Consejo de Europa\n11011 CADIZ\nCF: A 11902269', '1', '2023-10-02 10:56:04', '2023-10-28 11:06:50', 1, 1),
(2, 'COTE D\'IVOIRE', 'Abidjan Vridi - Boulevard de Petit–Bassam – au sein de la raffinerie SIR - 12 BP 622 Abidjan 12', '1', '2023-10-04 19:42:10', '2023-10-04 19:42:27', 2, 2),
(3, 'OUGANDA', 'Kampala, Cote d\'ivoire\r\n Tél: (225) 27 21 21 20 20 / 30\r\n (225) 27 21 35 20 92', '1', '2023-10-04 20:01:47', '2023-10-04 20:01:56', 3, 2),
(4, 'FRANCE', 'Place de l\'Hôtel de Ville B.P. 161 – 83 992 Saint-Tropez cedex', '1', '2023-10-04 20:06:47', '2023-10-04 20:06:57', 4, 2),
(5, 'INTERTUNA, N.V.', 'GREBBELINWEG 88-A\r\nP.O. BOX 6061\r\nWILLEMSTAD, CURAÇAO, NETHERLANDS ANTILLES\r\nEXENTO DE IVA\r\nCHAMBER OF COMMERCE. WILLEMSTAD NO 75751', '1', '2023-10-02 10:56:04', '2023-10-28 11:06:50', 1, 1),
(6, 'INTEGRAL FISHING SERVICES, INC.', 'Avenda Samuel Lewis, Edif. Mage\', Piso 2 Obarrio Panamé\r\nApo. 0816-03257\r\nPANAMA, REPÙBUCA DE PANAMA\r\nEXENTO DE IVA\r\nNO REGISTRO: Ficha 371916 - Documento 56083', '1', '2023-10-02 10:56:04', '2023-10-28 11:06:50', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

DROP TABLE IF EXISTS `clients`;
CREATE TABLE IF NOT EXISTS `clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `clients`
--

INSERT INTO `clients` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'GRUPO ALBACORA', '1', '2023-10-02 10:40:21', '2024-03-20 15:49:48', 1),
(2, 'CLIENT TEST 2', '1', '2023-10-04 19:21:36', '2023-10-04 19:40:31', 2),
(3, 'CLIENT TEST 3', '1', '2023-10-04 19:43:26', '2023-10-04 19:43:50', 2);

-- --------------------------------------------------------

--
-- Structure de la table `commandes`
--

DROP TABLE IF EXISTS `commandes`;
CREATE TABLE IF NOT EXISTS `commandes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` float NOT NULL,
  `quantity` float NOT NULL,
  `valeur` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `unit` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `item_id` int(11) NOT NULL,
  `devttr_id` int(11) NOT NULL,
  `devtyp_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=356 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `commandes`
--

INSERT INTO `commandes` (`id`, `amount`, `quantity`, `valeur`, `unit`, `created_at`, `updated_at`, `item_id`, `devttr_id`, `devtyp_id`) VALUES
(35, 35000, 2, '2', 'jrs', '2024-04-16 07:49:36', '2024-08-24 16:14:40', 1, 5, 4),
(36, 35000, 5, '5', 'jrs', '2024-04-16 07:49:36', '2024-04-16 07:49:36', 2, 1, 3),
(47, 35000, 2, '2', 'jrs', '2024-04-16 08:19:44', '2024-04-16 08:19:44', 1, 2, 3),
(48, 35000, 5, '5', 'jrs', '2024-04-16 08:19:44', '2024-04-16 08:19:44', 2, 2, 3),
(49, 1500, 13, '13', 'm', '2024-04-16 08:25:24', '2024-04-16 08:25:24', 30, 3, 2),
(50, 2500, 15, '15', 'kg', '2024-04-16 08:25:24', '2024-04-16 08:25:24', 31, 3, 2),
(51, 3000, 8, '8', 'kg', '2024-04-16 08:25:24', '2024-04-16 08:25:24', 39, 3, 2),
(52, 20000, 5, '5', 'kg', '2024-04-16 08:25:24', '2024-04-16 08:25:24', 35, 3, 2),
(53, 19500, 3, '3', 'kg', '2024-04-16 08:25:24', '2024-04-16 08:25:24', 17, 3, 2),
(54, 2000, 5, '5', 'paq', '2024-04-16 08:31:55', '2024-04-16 08:31:55', 36, 2, 2),
(55, 1500, 7, '7', 'paq', '2024-04-16 08:31:55', '2024-04-16 08:31:55', 37, 2, 2),
(56, 5000, 3, '3', 'm', '2024-04-16 08:31:55', '2024-04-16 08:31:55', 38, 2, 2),
(57, 3500, 5, '5', 'm', '2024-04-16 08:31:55', '2024-04-16 08:31:55', 40, 2, 2),
(58, 4500, 8, '8', 'kg', '2024-04-16 08:31:55', '2024-04-16 08:31:55', 41, 2, 2),
(68, 35000, 8, '8', 'jrs', '2024-04-16 08:48:03', '2024-04-16 08:48:03', 1, 3, 3),
(69, 35000, 15, '15', 'jrs', '2024-04-16 08:48:03', '2024-04-16 08:48:03', 2, 3, 3),
(70, 2000, 15, '15', 'paq', '2024-04-16 08:52:58', '2024-04-16 08:52:58', 36, 4, 2),
(71, 1500, 5, '5', 'paq', '2024-04-16 08:52:58', '2024-04-16 08:52:58', 37, 4, 2),
(72, 20000, 2, '2', 'kg', '2024-04-16 08:52:58', '2024-04-16 08:52:58', 35, 4, 2),
(73, 2500, 3, '3', 'm', '2024-04-16 08:52:58', '2024-04-16 08:52:58', 42, 4, 2),
(74, 3500, 5, '5', 'm', '2024-04-16 08:52:58', '2024-04-16 08:52:58', 43, 4, 2),
(75, 35000, 2, '2', 'jrs', '2024-04-16 09:00:23', '2024-04-16 09:00:23', 1, 4, 3),
(76, 35000, 5, '5', 'jrs', '2024-04-16 09:00:23', '2024-04-16 09:00:23', 2, 4, 3),
(88, 2000, 5, '5', 'paq', '2024-04-16 10:06:09', '2024-04-16 10:06:09', 36, 11, 2),
(89, 5000, 3, '3', 'm', '2024-04-16 10:06:09', '2024-04-16 10:06:09', 38, 11, 2),
(90, 2500, 4, '4', 'm', '2024-04-16 10:06:09', '2024-04-16 10:06:09', 44, 11, 2),
(98, 9000, 5, '5', 'h', '2024-04-17 07:42:23', '2024-04-17 07:42:23', 8, 5, 1),
(99, 1300, 15, '15', 'h', '2024-04-17 07:42:23', '2024-04-17 07:42:23', 6, 5, 1),
(100, 8000, 10, '10', 'h', '2024-04-17 07:42:23', '2024-04-17 07:42:23', 3, 5, 1),
(101, 8000, 15, '15', 'h', '2024-04-17 07:42:23', '2024-04-17 07:42:23', 9, 5, 1),
(102, 35000, 2, '2', 'jrs', '2024-04-17 08:21:52', '2024-04-17 08:21:52', 1, 12, 3),
(103, 35000, 5, '5', 'jrs', '2024-04-17 08:21:52', '2024-04-17 08:21:52', 2, 12, 3),
(108, 1300, 5, '5', 'h', '2024-04-28 23:43:17', '2024-04-28 23:43:17', 6, 11, 1),
(109, 8000, 15, '15', 'h', '2024-04-28 23:43:17', '2024-04-28 23:43:17', 9, 11, 1),
(110, 8000, 10, '10', 'h', '2024-04-28 23:43:17', '2024-04-28 23:43:17', 3, 11, 1),
(114, 19500, 5, '5', 'kg', '2024-07-11 20:25:34', '2024-07-11 20:25:34', 17, 14, 2),
(115, 15000, 3, '3', 'kg', '2024-07-11 20:25:34', '2024-07-11 20:25:34', 21, 14, 2),
(116, 8000, 10, '10', 'hrs', '2024-07-11 20:31:48', '2024-07-11 20:31:48', 3, 15, 1),
(117, 8000, 5, '5', 'hrs', '2024-07-11 20:31:48', '2024-07-11 20:31:48', 9, 15, 1),
(118, 4500, 15, '15', 'hrs', '2024-07-11 20:31:48', '2024-07-11 20:31:48', 2, 15, 1),
(125, 15000, 10, '10', 'kg', '2024-07-17 15:45:31', '2024-07-17 15:45:31', 21, 17, 2),
(126, 5000, 15, '15', 'kg', '2024-07-17 15:45:31', '2024-07-17 15:45:31', 27, 17, 2),
(138, 5000, 10, '10', 'kg', '2024-07-17 17:09:49', '2024-07-17 17:09:49', 47, 18, 2),
(139, 10000, 5, '5', 'kg', '2024-07-17 17:09:49', '2024-07-17 17:09:49', 48, 18, 2),
(143, 8000, 10, '10', 'hrs', '2024-07-17 17:14:15', '2024-07-17 17:14:15', 3, 18, 1),
(144, 8000, 5, '5', 'hrs', '2024-07-17 17:14:15', '2024-07-17 17:14:15', 9, 18, 1),
(145, 4500, 20, '20', 'hrs', '2024-07-17 17:14:15', '2024-07-17 17:14:15', 2, 18, 1),
(146, 18000, 8, '8', 'hrs', '2024-07-17 17:14:15', '2024-07-17 17:14:15', 5, 18, 1),
(147, 9000, 5, '5', 'hrs', '2024-07-17 18:08:41', '2024-07-17 18:08:41', 8, 17, 1),
(148, 1300, 25, '25', 'hrs', '2024-07-17 18:08:41', '2024-07-17 18:08:41', 6, 17, 1),
(149, 8000, 4, '4', 'hrs', '2024-07-17 18:08:41', '2024-07-17 18:08:41', 3, 17, 1),
(150, 9000, 5, '5', 'hrs', '2024-07-17 18:15:03', '2024-07-17 18:15:03', 8, 16, 1),
(151, 1300, 20, '20', 'hrs', '2024-07-17 18:15:03', '2024-07-17 18:15:03', 6, 16, 1),
(152, 8000, 10, '10', 'hrs', '2024-07-17 18:15:03', '2024-07-17 18:15:03', 3, 16, 1),
(153, 4500, 15, '15', 'hrs', '2024-07-17 18:17:08', '2024-07-17 18:17:08', 2, 19, 1),
(154, 1100, 20, '20', 'hrs', '2024-07-17 18:17:08', '2024-07-17 18:17:08', 4, 19, 1),
(155, 18000, 5, '5', 'hrs', '2024-07-17 18:17:08', '2024-07-17 18:17:08', 5, 19, 1),
(156, 7500, 10, '10', 'paq', '2024-07-17 18:20:05', '2024-07-17 18:20:05', 46, 19, 2),
(157, 4500, 15, '15', 'paq', '2024-07-17 18:20:05', '2024-07-17 18:20:05', 45, 19, 2),
(165, 9000, 2, '2', 'hrs', '2024-07-18 19:05:31', '2024-07-18 19:05:31', 8, 14, 1),
(166, 1300, 10, '10', 'hrs', '2024-07-18 19:05:31', '2024-07-18 19:05:31', 6, 14, 1),
(167, 8000, 3, '3', 'hrs', '2024-07-18 19:05:31', '2024-07-18 19:05:31', 3, 14, 1),
(168, 8000, 5, '5', 'hrs', '2024-07-18 19:05:31', '2024-07-18 19:05:31', 9, 14, 1),
(169, 8000, 5, '5', 'h', '2024-07-18 19:10:16', '2024-07-18 19:10:16', 9, 3, 1),
(170, 4500, 12, '12', 'h', '2024-07-18 19:10:16', '2024-07-18 19:10:16', 2, 3, 1),
(171, 18000, 2, '2', 'h', '2024-07-18 19:10:16', '2024-07-18 19:10:16', 5, 3, 1),
(172, 1100, 6, '6', 'h', '2024-07-18 19:10:16', '2024-07-18 19:10:16', 4, 3, 1),
(173, 8000, 10, '10', 'h', '2024-07-18 19:10:16', '2024-07-18 19:10:16', 3, 3, 1),
(178, 18000, 3, '3', 'h', '2024-07-18 19:18:29', '2024-07-18 19:18:29', 5, 4, 1),
(179, 8000, 12, '12', 'h', '2024-07-18 19:18:29', '2024-07-18 19:18:29', 3, 4, 1),
(180, 4500, 15, '15', 'h', '2024-07-18 19:18:29', '2024-07-18 19:18:29', 2, 4, 1),
(181, 13000, 5, '5', 'h', '2024-07-18 19:18:30', '2024-07-18 19:18:30', 7, 4, 1),
(187, 35000, 5, '5', 'jrs', '2024-07-18 19:26:19', '2024-07-18 19:26:19', 1, 13, 3),
(188, 35000, 10, '10', 'jrs', '2024-07-18 19:26:19', '2024-07-18 19:26:19', 2, 13, 3),
(202, 5000, 50, '50', 'm', '2024-07-18 21:24:42', '2024-07-18 21:24:42', 38, 20, 2),
(203, 10000, 20, '20', 'm', '2024-07-18 21:24:42', '2024-07-18 21:24:42', 49, 20, 2),
(204, 5000, 50, '50', 'kg', '2024-07-18 21:24:42', '2024-07-18 21:24:42', 10, 20, 2),
(205, 1000, 100, '100', 'kg', '2024-07-18 21:24:42', '2024-07-18 21:24:42', 51, 20, 2),
(215, 15000, 10, '10', 'kg', '2024-07-18 21:38:12', '2024-07-18 21:38:12', 21, 21, 2),
(216, 19500, 20, '20', 'kg', '2024-07-18 21:38:12', '2024-07-18 21:38:12', 17, 21, 2),
(217, 2000, 15, '15', 'paq', '2024-07-18 21:38:12', '2024-07-18 21:38:12', 36, 21, 2),
(218, 1500, 50, '50', 'paq', '2024-07-18 21:38:12', '2024-07-18 21:38:12', 37, 21, 2),
(219, 5000, 20, '20', 'm', '2024-07-18 21:38:12', '2024-07-18 21:38:12', 38, 21, 2),
(220, 10000, 15, '15', 'm', '2024-07-18 21:38:12', '2024-07-18 21:38:12', 49, 21, 2),
(237, 9000, 5, '5', 'h', '2024-07-18 22:39:17', '2024-07-18 22:39:17', 8, 23, 1),
(238, 18000, 3, '3', 'h', '2024-07-18 22:39:17', '2024-07-18 22:39:17', 5, 23, 1),
(239, 8000, 15, '15', 'h', '2024-07-18 22:39:17', '2024-07-18 22:39:17', 3, 23, 1),
(242, 9000, 10, '10', 'h', '2024-07-18 22:42:12', '2024-07-18 22:42:12', 8, 24, 1),
(243, 1300, 50, '50', 'h', '2024-07-18 22:42:12', '2024-07-18 22:42:12', 6, 24, 1),
(244, 8000, 20, '20', 'h', '2024-07-18 22:42:12', '2024-07-18 22:42:12', 3, 24, 1),
(251, 1100, 50, '50', 'h', '2024-07-18 22:46:30', '2024-07-18 22:46:30', 4, 22, 1),
(252, 13000, 10, '10', 'h', '2024-07-18 22:46:30', '2024-07-18 22:46:30', 7, 22, 1),
(253, 18000, 5, '5', 'h', '2024-07-18 22:46:30', '2024-07-18 22:46:30', 5, 22, 1),
(254, 8000, 25, '25', 'h', '2024-07-18 22:46:30', '2024-07-18 22:46:30', 3, 22, 1),
(255, 10000, 5, '5', 'm', '2024-07-18 22:49:33', '2024-07-18 22:49:33', 49, 23, 2),
(256, 5000, 15, '15', 'kg', '2024-07-18 22:49:33', '2024-07-18 22:49:33', 47, 23, 2),
(257, 7500, 8, '8', 'kg', '2024-07-18 22:49:33', '2024-07-18 22:49:33', 56, 23, 2),
(258, 5000, 15, '15', 'm', '2024-07-18 22:52:40', '2024-07-18 22:52:40', 38, 24, 2),
(259, 5000, 10, '10', 'm', '2024-07-18 22:52:40', '2024-07-18 22:52:40', 10, 24, 2),
(260, 8550, 5, '5', 'm', '2024-07-18 22:52:40', '2024-07-18 22:52:40', 57, 24, 2),
(261, 7500, 10, '10', 'm', '2024-07-18 22:52:40', '2024-07-18 22:52:40', 58, 24, 2),
(262, 4500, 5, '5', 'paq', '2024-07-20 01:53:47', '2024-07-20 01:53:47', 45, 5, 2),
(263, 7500, 6, '6', 'paq', '2024-07-20 01:53:47', '2024-07-20 01:53:47', 46, 5, 2),
(264, 2500, 7, '7', 'm', '2024-07-20 01:53:47', '2024-07-20 01:53:47', 44, 5, 2),
(265, 2000, 25, '25', 'paq', '2024-07-20 01:53:47', '2024-07-20 01:53:47', 36, 5, 2),
(266, 1500, 10, '10', 'paq', '2024-07-20 01:53:47', '2024-07-20 01:53:47', 37, 5, 2),
(277, 9000, 5, '5', 'm', '2024-07-20 02:20:27', '2024-07-20 02:20:27', 8, 25, 1),
(278, 1300, 20, '20', 'm', '2024-07-20 02:20:27', '2024-07-20 02:20:27', 6, 25, 1),
(283, 19500, 2, '2', 'kg', '2024-07-25 01:31:39', '2024-07-25 01:31:39', 17, 16, 2),
(284, 2500, 10, '10', 'm', '2024-07-25 01:31:39', '2024-07-25 01:31:39', 44, 16, 2),
(285, 7500, 5, '5', 'kg', '2024-07-25 01:31:39', '2024-07-25 01:31:39', 53, 16, 2),
(286, 5000, 10, '10', 'm', '2024-07-25 01:34:21', '2024-07-25 01:34:21', 38, 15, 2),
(287, 10000, 15, '15', 'm', '2024-07-25 01:34:21', '2024-07-25 01:34:21', 49, 15, 2),
(288, 9000, 10, '10', 'jrs', '2024-07-25 01:47:01', '2024-07-25 01:47:01', 8, 26, 1),
(289, 1300, 50, '50', 'jrs', '2024-07-25 01:47:01', '2024-07-25 01:47:01', 6, 26, 1),
(290, 8000, 12, '12', 'jrs', '2024-07-25 01:47:01', '2024-07-25 01:47:01', 3, 26, 1),
(291, 5000, 2, '2', 'paq', '2024-07-25 01:57:08', '2024-07-25 01:57:08', 59, 26, 2),
(292, 2000, 5, '5', 'paq', '2024-07-25 01:57:08', '2024-07-25 01:57:08', 36, 26, 2),
(296, 8000, 5, '5', 'h', '2024-07-25 02:17:33', '2024-07-25 02:17:33', 9, 27, 1),
(297, 4500, 7, '7', 'h', '2024-07-25 02:17:33', '2024-07-25 02:17:33', 2, 27, 1),
(298, 1100, 15, '15', 'h', '2024-07-25 02:17:33', '2024-07-25 02:17:33', 4, 27, 1),
(299, 18000, 3, '3', 'h', '2024-07-25 02:17:33', '2024-07-25 02:17:33', 5, 27, 1),
(305, 18000, 5, '5', 'h', '2024-07-25 02:36:26', '2024-07-25 02:36:26', 5, 21, 1),
(306, 8000, 20, '20', 'h', '2024-07-25 02:36:26', '2024-07-25 02:36:26', 3, 21, 1),
(307, 1100, 30, '30', 'h', '2024-07-25 02:36:26', '2024-07-25 02:36:26', 4, 21, 1),
(308, 4500, 10, '10', 'h', '2024-07-25 02:36:26', '2024-07-25 02:36:26', 2, 21, 1),
(309, 9000, 2, '2', 'kg', '2024-07-25 02:41:26', '2024-07-25 02:41:26', 8, 20, 1),
(310, 1300, 25, '25', 'kg', '2024-07-25 02:41:26', '2024-07-25 02:41:26', 6, 20, 1),
(311, 8000, 5, '5', 'kg', '2024-07-25 02:41:26', '2024-07-25 02:41:26', 3, 20, 1),
(312, 1500, 10, '10', 'paq', '2024-07-25 02:42:34', '2024-07-25 02:42:34', 37, 27, 2),
(313, 2000, 15, '15', 'paq', '2024-07-25 02:42:34', '2024-07-25 02:42:34', 36, 27, 2),
(314, 5000, 5, '5', 'm', '2024-07-25 02:42:34', '2024-07-25 02:42:34', 38, 27, 2),
(315, 10000, 3, '3', 'm', '2024-07-25 02:42:34', '2024-07-25 02:42:34', 49, 27, 2),
(321, 2500, 15, '15', 'kg', '2024-07-25 02:49:54', '2024-07-25 02:49:54', 52, 22, 2),
(322, 7500, 20, '20', 'kg', '2024-07-25 02:49:54', '2024-07-25 02:49:54', 53, 22, 2),
(323, 8500, 10, '10', 'kg', '2024-07-25 02:49:54', '2024-07-25 02:49:54', 54, 22, 2),
(324, 10000, 5, '5', 'kg', '2024-07-25 02:49:54', '2024-07-25 02:49:54', 55, 22, 2),
(325, 8500, 8, '8', 'kg', '2024-07-25 02:49:54', '2024-07-25 02:49:54', 60, 22, 2),
(326, 7500, 12, '12', 'kg', '2024-07-25 02:49:54', '2024-07-25 02:49:54', 61, 22, 2),
(327, 2500, 10, '10', 'kg', '2024-07-25 02:52:08', '2024-07-25 02:52:08', 52, 25, 2),
(328, 7500, 5, '5', 'kg', '2024-07-25 02:52:08', '2024-07-25 02:52:08', 53, 25, 2),
(329, 2500, 15, '15', 'm', '2024-07-25 02:52:08', '2024-07-25 02:52:08', 44, 25, 2),
(336, 9000, 2, '2', 'h', '2024-07-25 02:55:53', '2024-07-25 02:55:53', 8, 1, 1),
(337, 1300, 15, '15', 'h', '2024-07-25 02:55:53', '2024-07-25 02:55:53', 6, 1, 1),
(338, 8000, 3, '3', 'h', '2024-07-25 02:55:53', '2024-07-25 02:55:53', 3, 1, 1),
(339, 4500, 5, '5', 'h', '2024-07-25 02:55:53', '2024-07-25 02:55:53', 2, 1, 1),
(340, 18000, 10, '10', 'h', '2024-07-25 02:55:53', '2024-07-25 02:55:53', 5, 1, 1),
(341, 13000, 8, '8', 'h', '2024-07-25 02:55:53', '2024-07-25 02:55:53', 7, 1, 1),
(342, 8000, 4, '4', 'h', '2024-07-25 02:55:53', '2024-07-25 02:55:53', 9, 1, 1),
(343, 8000, 3, '3', 'h', '2024-07-25 03:06:59', '2024-07-25 03:06:59', 3, 2, 1),
(344, 8000, 4, '4', 'h', '2024-07-25 03:06:59', '2024-07-25 03:06:59', 9, 2, 1),
(345, 4500, 5, '5', 'h', '2024-07-25 03:06:59', '2024-07-25 03:06:59', 2, 2, 1),
(346, 1100, 20, '20', 'h', '2024-07-25 03:06:59', '2024-07-25 03:06:59', 4, 2, 1),
(347, 13000, 5, '5', 'h', '2024-07-25 03:06:59', '2024-07-25 03:06:59', 7, 2, 1),
(348, 1300, 50, '50', 'h', '2024-07-25 03:06:59', '2024-07-25 03:06:59', 6, 2, 1),
(349, 20000, 4, '4', 'kg', '2024-07-25 03:17:13', '2024-07-25 03:17:13', 35, 1, 2),
(350, 15000, 3, '3', 'kg', '2024-07-25 03:17:13', '2024-07-25 03:17:13', 21, 1, 2),
(351, 5000, 4, '4', 'kit', '2024-07-25 03:17:13', '2024-07-25 03:17:13', 33, 1, 2),
(352, 2000, 5, '5', 'paq', '2024-07-25 03:17:13', '2024-07-25 03:17:13', 36, 1, 2),
(353, 1500, 7, '7', 'paq', '2024-07-25 03:17:13', '2024-07-25 03:17:13', 37, 1, 2),
(354, 10000, 5, '5', 'm', '2024-07-25 03:17:13', '2024-07-25 03:17:13', 49, 1, 2),
(355, 5000, 10, '10', 'm', '2024-07-25 03:17:13', '2024-07-25 03:17:13', 38, 1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `devis`
--

DROP TABLE IF EXISTS `devis`;
CREATE TABLE IF NOT EXISTS `devis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `date_at` date NOT NULL,
  `mt_ht` float DEFAULT NULL,
  `mt_rem` float DEFAULT NULL,
  `mt_tva` float DEFAULT NULL,
  `mt_ttc` float DEFAULT NULL,
  `mt_euro` float DEFAULT NULL,
  `sum_rem` tinyint(4) NOT NULL,
  `sum_tva` tinyint(4) NOT NULL,
  `see_tva` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `see_rem` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `see_euro` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `filename` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `motif` text COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `validated_at` datetime DEFAULT NULL,
  `transmitted_at` datetime DEFAULT NULL,
  `status` enum('0','1','2','3','4','5') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  `ship_id` int(11) NOT NULL DEFAULT 0,
  `header_id` int(11) NOT NULL,
  `billaddr_id` int(11) NOT NULL,
  `approved_id` int(11) DEFAULT NULL,
  `validated_id` int(11) DEFAULT NULL,
  `transmitted_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `devis`
--

INSERT INTO `devis` (`id`, `reference`, `date_at`, `mt_ht`, `mt_rem`, `mt_tva`, `mt_ttc`, `mt_euro`, `sum_rem`, `sum_tva`, `see_tva`, `see_rem`, `see_euro`, `filename`, `motif`, `approved_at`, `validated_at`, `transmitted_at`, `status`, `created_at`, `updated_at`, `user_id`, `ship_id`, `header_id`, `billaddr_id`, `approved_id`, `validated_id`, `transmitted_id`) VALUES
(1, '0001/24', '2024-04-15', 4188100, 628215, 355988, 3915870, 5960.6, 15, 10, '1', '1', '1', '20240415190718193310.pdf', NULL, '2024-04-28 18:37:41', '2024-04-28 18:37:47', '2024-04-28 18:37:34', '0', '2024-04-15 19:07:18', '2024-07-20 02:29:14', 1, 0, 1, 1, 1, 1, 1),
(7, '0002/24', '2024-04-16', 406500, 0, 0, 406500, 618.759, 0, 0, '0', '0', '0', '20240416100609837856.pdf', NULL, '2024-07-25 09:01:47', '2024-07-25 09:01:55', '2024-04-28 23:44:59', '4', '2024-04-16 10:06:09', '2024-07-25 09:01:55', 1, 0, 1, 1, 1, 1, 1),
(8, '0003/24', '2024-07-10', 625000, 62500, 101250, 663750, 1010.34, 10, 18, '1', '1', '1', '20240710182412108732.pdf', NULL, NULL, NULL, NULL, '0', '2024-07-10 18:24:12', '2024-07-25 01:34:21', 1, 1, 3, 1, NULL, NULL, NULL),
(9, '0004/24', '2024-07-17', 537000, 107400, 91247, 598175, 910.52, 20, 18, '1', '1', '1', '20240717131520404959.pdf', NULL, NULL, NULL, NULL, '0', '2024-07-17 13:15:20', '2024-07-25 01:27:00', 1, 1, 2, 1, NULL, NULL, NULL),
(10, '0005/24', '2024-07-17', 599500, 119900, 0, 479600, 730.029, 20, 0, '0', '1', '0', '20240717154214710783.pdf', NULL, NULL, NULL, NULL, '0', '2024-07-17 15:42:14', '2024-07-25 01:19:06', 1, 1, 1, 1, NULL, NULL, NULL),
(11, '0006/24', '2024-07-17', 1161500, 232300, 167256, 1096460, 1668.98, 20, 18, '1', '1', '1', '20240717183220449576.pdf', NULL, NULL, NULL, NULL, '0', '2024-07-17 18:32:20', '2024-07-25 01:57:08', 1, 2, 1, 5, NULL, NULL, NULL),
(12, '0007/24', '2024-07-18', 3169250, 950775, 399326, 2617800, 3984.72, 30, 18, '1', '1', '1', '20240718211910697557.pdf', NULL, NULL, NULL, NULL, '0', '2024-07-18 21:19:10', '2024-07-25 02:20:25', 1, 0, 2, 6, NULL, NULL, NULL);

--
-- Déclencheurs `devis`
--
DROP TRIGGER IF EXISTS `insert_stat`;
DELIMITER $$
CREATE TRIGGER `insert_stat` AFTER INSERT ON `devis` FOR EACH ROW BEGIN
    CALL statistic();
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_dev`;
DELIMITER $$
CREATE TRIGGER `update_dev` AFTER UPDATE ON `devis` FOR EACH ROW BEGIN
    CALL statistic();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `devis_ttr`
--

DROP TABLE IF EXISTS `devis_ttr`;
CREATE TABLE IF NOT EXISTS `devis_ttr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `devis_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `devis_ttr`
--

INSERT INTO `devis_ttr` (`id`, `libelle`, `created_at`, `updated_at`, `devis_id`) VALUES
(1, 'LUNDI', '2024-04-15 19:07:18', '2024-04-16 05:38:39', 1),
(2, 'MARDI', '2024-04-15 19:27:12', '2024-04-16 05:56:16', 1),
(3, 'MERCREDI', '2024-04-16 05:57:39', '2024-04-16 05:57:39', 1),
(4, 'JEUDI', '2024-04-16 08:12:31', '2024-04-16 08:12:31', 1),
(5, 'VENDREDI', '2024-04-16 09:04:25', '2024-04-16 09:04:25', 1),
(11, 'AZERTY', '2024-04-16 10:06:09', '2024-04-16 10:06:09', 7),
(12, 'TRANSPORT', '2024-04-17 08:21:52', '2024-04-17 08:21:52', 7),
(13, 'TRANSPORT', '2024-04-17 08:24:40', '2024-04-17 08:24:40', 1),
(14, 'AZERTY', '2024-07-10 18:24:12', '2024-07-10 18:24:12', 8),
(15, 'QWERTY', '2024-07-11 20:31:48', '2024-07-11 20:31:48', 8),
(16, 'AZERTY', '2024-07-17 13:15:20', '2024-07-17 13:15:20', 9),
(17, 'AZERTY', '2024-07-17 15:42:14', '2024-07-17 15:42:14', 10),
(18, 'QWERTY', '2024-07-17 15:47:09', '2024-07-17 15:47:09', 10),
(19, 'QWERTY', '2024-07-17 16:17:36', '2024-07-17 16:17:36', 9),
(20, 'OGOU', '2024-07-17 18:32:20', '2024-07-17 18:32:20', 11),
(21, 'LUNDI', '2024-07-18 21:19:10', '2024-07-18 21:19:10', 12),
(22, 'MARDI', '2024-07-18 21:37:08', '2024-07-18 21:37:08', 12),
(23, 'MERCREDI', '2024-07-18 22:35:46', '2024-07-18 22:35:46', 12),
(24, 'JEUDI', '2024-07-18 22:41:11', '2024-07-18 22:41:11', 12),
(25, 'SAMEDI', '2024-07-20 02:20:27', '2024-07-20 02:20:27', 1),
(26, 'MONNEY', '2024-07-25 01:15:42', '2024-07-25 01:15:42', 11),
(27, 'VENDREDI', '2024-07-25 02:15:43', '2024-07-25 02:15:43', 12);

-- --------------------------------------------------------

--
-- Structure de la table `devis_txt`
--

DROP TABLE IF EXISTS `devis_txt`;
CREATE TABLE IF NOT EXISTS `devis_txt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `devttr_id` int(11) NOT NULL,
  `devtyp_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `devis_txt`
--

INSERT INTO `devis_txt` (`id`, `content`, `created_at`, `updated_at`, `devttr_id`, `devtyp_id`) VALUES
(1, 'Les entreprises sont confrontées à de multiples difficultés dans la gestion de leur business, à savoir : d’importants risques d’erreurs dans la manipulation des données, la lenteur et les aller-retours interminables dans la transmission des informations, des déficits de trésorerie liés au mauvais suivi des délais de recouvrements, les pertes de temps dans la recherche de documents du fait de la volumétrie de la paperasse et bien d’autres.\r\nOk', '2024-04-15 19:07:18', '2024-07-25 02:55:53', 1, 1),
(2, 'Cette étape permettra de présenter le design et le parcours utilisateur.\r\nLe design ou la stylique en français est constitué de l\'ensemble des éléments contribuant à l\'apparence visuelle et physique d\'un produit.\r\nLe design doit répondre principalement à deux objectifs marketing :', '2024-04-15 19:27:12', '2024-07-25 03:06:59', 2, 1),
(3, 'Les entreprises sont confrontées à de multiples difficultés dans la gestion de leur business, à savoir : d’importants risques d’erreurs dans la manipulation des données, la lenteur et les aller-retours interminables dans la transmission des informations, des déficits de trésorerie liés au mauvais suivi des délais de recouvrements, les pertes de temps dans la recherche de documents du fait de la volumétrie de la paperasse et bien d’autres.\r\nConséquence, elles passent plus de temps dans la gestion administrative plutôt qu’à se concentrer sur leur cœur de métier pour développer leur business.\r\nAujourd’hui, avec le digital et les nombreuses opportunités qu’il offre, il est possible de dématérialiser tous les processus de gestion d’une entreprise grâce à des logiciels appelés ERP qui permettent de gérer et suivre au quotidien, l’ensemble des informations et des services opérationnels d’une entreprise.', '2024-04-16 05:57:39', '2024-04-16 08:48:03', 3, 3),
(4, 'Les entreprises sont confrontées à de multiples difficultés dans la gestion de leur business, à savoir : d’importants risques d’erreurs dans la manipulation des données, la lenteur et les aller-retours interminables dans la transmission des informations, des déficits de trésorerie liés au mauvais suivi des délais de recouvrements, les pertes de temps dans la recherche de documents du fait de la volumétrie de la paperasse et bien d’autres.\r\nConséquence, elles passent plus de temps dans la gestion administrative plutôt qu’à se concentrer sur leur cœur de métier pour développer leur business.\r\nAujourd’hui, avec le digital et les nombreuses opportunités qu’il offre, il est possible de dématérialiser tous les processus de gestion d’une entreprise grâce à des logiciels appelés ERP qui permettent de gérer et suivre au quotidien, l’ensemble des informations et des services opérationnels d’une entreprise.', '2024-04-16 07:31:10', '2024-07-18 19:10:16', 3, 1),
(5, 'L’objectif principal est de mettre en place un ERP adapté à nos réalités, qui permettra de centraliser et gérer tous des processus des entreprises sur une seule plateforme en intégrant l\'ensemble de leurs fonctions (la vente (DC), la finance (DFC), le Contrôle de Gestion (CG), les Ressources Humaines etc.) dans l’optique d’augmenter leur performance globale.', '2024-04-16 07:36:48', '2024-04-16 07:49:36', 1, 3),
(6, 'Les entreprises sont confrontées à de multiples difficultés dans la gestion de leur business, à savoir : d’importants risques d’erreurs dans la manipulation des données, la lenteur et les aller-retours interminables dans la transmission des informations, des déficits de trésorerie liés au mauvais suivi des délais de recouvrements, les pertes de temps dans la recherche de documents du fait de la volumétrie de la paperasse et bien d’autres.\r\nConséquence, elles passent plus de temps dans la gestion administrative plutôt qu’à se concentrer sur leur cœur de métier pour développer leur business.\r\nAujourd’hui, avec le digital et les nombreuses opportunités qu’il offre, il est possible de dématérialiser tous les processus de gestion d’une entreprise grâce à des logiciels appelés ERP qui permettent de gérer et suivre au quotidien, l’ensemble des informations et des services opérationnels d’une entreprise.', '2024-04-16 08:12:31', '2024-04-16 08:12:31', 4, 1),
(7, 'Les entreprises sont confrontées à de multiples difficultés dans la gestion de leur business, à savoir : d’importants risques d’erreurs dans la manipulation des données, la lenteur et les aller-retours interminables dans la transmission des informations, des déficits de trésorerie liés au mauvais suivi des délais de recouvrements, les pertes de temps dans la recherche de documents du fait de la volumétrie de la paperasse et bien d’autres.\r\nConséquence, elles passent plus de temps dans la gestion administrative plutôt qu’à se concentrer sur leur cœur de métier pour développer leur business.\r\nAujourd’hui, avec le digital et les nombreuses opportunités qu’il offre, il est possible de dématérialiser tous les processus de gestion d’une entreprise grâce à des logiciels appelés ERP qui permettent de gérer et suivre au quotidien, l’ensemble des informations et des services opérationnels d’une entreprise.', '2024-04-16 08:19:44', '2024-04-16 08:19:44', 2, 3),
(8, 'Les entreprises sont confrontées à de multiples difficultés dans la gestion de leur business, à savoir : d’importants risques d’erreurs dans la manipulation des données, la lenteur et les aller-retours interminables dans la transmission des informations, des déficits de trésorerie liés au mauvais suivi des délais de recouvrements, les pertes de temps dans la recherche de documents du fait de la volumétrie de la paperasse et bien d’autres.\r\nConséquence, elles passent plus de temps dans la gestion administrative plutôt qu’à se concentrer sur leur cœur de métier pour développer leur business.\r\nAujourd’hui, avec le digital et les nombreuses opportunités qu’il offre, il est possible de dématérialiser tous les processus de gestion d’une entreprise grâce à des logiciels appelés ERP qui permettent de gérer et suivre au quotidien, l’ensemble des informations et des services opérationnels d’une entreprise.', '2024-04-16 09:00:23', '2024-04-16 09:00:23', 4, 3),
(9, 'Les entreprises sont confrontées à de multiples difficultés dans la gestion de leur business, à savoir : d’importants risques d’erreurs dans la manipulation des données, la lenteur et les aller-retours interminables dans la transmission des informations, des déficits de trésorerie liés au mauvais suivi des délais de recouvrements, les pertes de temps dans la recherche de documents du fait de la volumétrie de la paperasse et bien d’autres.\r\nConséquence, elles passent plus de temps dans la gestion administrative plutôt qu’à se concentrer sur leur cœur de métier pour développer leur business.\r\nAujourd’hui, avec le digital et les nombreuses opportunités qu’il offre, il est possible de dématérialiser tous les processus de gestion d’une entreprise grâce à des logiciels appelés ERP qui permettent de gérer et suivre au quotidien, l’ensemble des informations et des services opérationnels d’une entreprise.', '2024-04-16 09:04:25', '2024-04-16 09:04:25', 5, 1),
(13, '- Azerty 1\r\n- Azerty 2\r\n- Azerty 3', '2024-04-16 18:33:29', '2024-04-28 23:43:17', 11, 1),
(14, '- Transport 1\r\n- Transport 2', '2024-04-17 08:21:52', '2024-04-17 08:21:52', 12, 3),
(15, '- Transport 1\r\n- Transport 2\r\n- Transport 3\r\n- Transport 4', '2024-04-17 08:24:40', '2024-07-18 19:26:19', 13, 3),
(16, '- Azerty 1\r\n- Azerty 2', '2024-07-10 18:24:12', '2024-07-18 19:05:31', 14, 1),
(17, '- Qwerty 1\r\n- Qwerty 2', '2024-07-11 20:31:48', '2024-07-11 20:31:48', 15, 1),
(18, '- Azerty 1\r\n- Azerty 2', '2024-07-17 13:15:20', '2024-07-17 18:15:03', 16, 1),
(19, '- Azerty 1\r\n- Azerty 2', '2024-07-17 15:42:14', '2024-07-17 18:08:41', 17, 1),
(20, '- Qwerty 1\r\n- Qwerty 2', '2024-07-17 15:47:09', '2024-07-17 17:14:15', 18, 1),
(21, '- Qwerty 1\r\n- Qwerty 2', '2024-07-17 16:17:36', '2024-07-17 18:17:08', 19, 1),
(22, '- OGOU JB\r\n- OGOU Fabrice\r\n- OGOU Franck\r\n- OGOU Dez', '2024-07-17 18:32:20', '2024-07-25 02:41:26', 20, 1),
(23, 'A la demande de NGSER, le prestataire fournira les prestations soit dans les locaux de NGSER soit hors de la société conformément à la fiche de mission qui lui a été confiée.\r\nJuste un test.', '2024-07-18 21:19:10', '2024-07-25 02:36:25', 21, 1),
(24, 'Dès réception de la fiche de mission par le prestataire, celui-ci est tenu de prendre toutes les dispositions nécessaires afin d’exécuter les prestations de services dans les délais convenus.', '2024-07-18 21:37:08', '2024-07-18 22:46:30', 22, 1),
(25, 'Les parties conviennent qu’en l’absence de prestations fournies au cours d’une période donnée, le prestataire ne pourra prétendre à aucune rémunération au cours de ladite période.', '2024-07-18 22:35:46', '2024-07-18 22:39:17', 23, 1),
(26, 'Le prestataire informera NGSER sans délai de toutes les difficultés auxquelles il sera confronté au cours de l’exécution de ses prestations. A la demande de NGSER, le Consultant devra fournir des rapports résumant les actions réalisées dans l’exécution de ses prestations contractuelles. NGSER fournira au consultant toute information relative aux prestations qu’il pourra lui demander.', '2024-07-18 22:41:11', '2024-07-18 22:42:12', 24, 1),
(27, 'Le digital est un facteur de croissance et de survie pour les entreprises quelles que soient leur taille et domaine. Il est donc important de maximiser leurs ventes à travers la digitalisation.', '2024-07-20 02:20:27', '2024-07-20 02:20:27', 25, 1),
(28, '- Monney Brice\r\n- Monney Solange\r\n- Monney Ange\r\n- Monney Sam', '2024-07-25 01:15:42', '2024-07-25 01:47:01', 26, 1),
(29, '- Tache planifiée\r\n- Réunion hebdo', '2024-07-25 02:15:43', '2024-07-25 02:17:33', 27, 1);

-- --------------------------------------------------------

--
-- Structure de la table `devis_typ`
--

DROP TABLE IF EXISTS `devis_typ`;
CREATE TABLE IF NOT EXISTS `devis_typ` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) NOT NULL,
  `status` enum('0','1') NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `devis_typ`
--

INSERT INTO `devis_typ` (`id`, `libelle`, `status`, `created_at`, `updated_at`) VALUES
(1, 'TRAVAUX', '1', '2023-09-30 14:07:06', '2023-09-30 14:08:47'),
(2, 'FOURNITURES', '1', '2023-09-30 14:09:19', '2023-09-30 14:09:19'),
(3, 'TRANSPORT', '1', '2023-09-30 14:09:34', '2023-09-30 14:09:34');

-- --------------------------------------------------------

--
-- Structure de la table `diameters`
--

DROP TABLE IF EXISTS `diameters`;
CREATE TABLE IF NOT EXISTS `diameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `diameters`
--

INSERT INTO `diameters` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'Ø⅛\" x1m', '1', '2023-11-21 21:55:57', '2023-12-11 19:45:08', 1),
(2, 'Ø¼\" x1m', '1', '2023-11-21 22:04:47', '2023-12-11 19:45:13', 1),
(3, 'Ø⅜\" x1m', '1', '2023-11-21 22:05:35', '2023-12-11 19:44:16', 1),
(4, 'Ø½\" x1m', '1', '2023-11-21 22:06:07', '2023-12-11 19:44:25', 1),
(5, 'Ø¾\" x1m', '1', '2023-11-21 22:06:28', '2023-12-11 19:44:33', 1),
(6, 'Ø⅛\"', '1', '2023-11-21 22:06:46', '2023-12-11 19:44:37', 1),
(7, 'Ø¼\"', '1', '2023-11-21 22:07:04', '2023-12-11 19:44:42', 1);

-- --------------------------------------------------------

--
-- Structure de la table `euros`
--

DROP TABLE IF EXISTS `euros`;
CREATE TABLE IF NOT EXISTS `euros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `euros`
--

INSERT INTO `euros` (`id`, `value`, `status`, `created_at`, `updated_at`) VALUES
(1, 656.96, '1', '2023-12-07 12:16:15', '2023-12-07 12:16:41');

-- --------------------------------------------------------

--
-- Structure de la table `habilitations`
--

DROP TABLE IF EXISTS `habilitations`;
CREATE TABLE IF NOT EXISTS `habilitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profil_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `right_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2129 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `habilitations`
--

INSERT INTO `habilitations` (`id`, `profil_id`, `page_id`, `right_id`, `created_at`, `updated_at`) VALUES
(1113, 3, 6, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1114, 3, 18, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1115, 3, 18, 2, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1116, 3, 18, 3, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1117, 3, 18, 5, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1118, 3, 7, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1119, 3, 8, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1120, 3, 9, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1121, 3, 10, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1122, 3, 1, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1123, 3, 2, 1, '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(1610, 2, 6, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1611, 2, 19, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1612, 2, 18, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1613, 2, 18, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1614, 2, 18, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1615, 2, 18, 5, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1616, 2, 18, 6, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1617, 2, 18, 7, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1618, 2, 18, 8, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1619, 2, 7, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1620, 2, 7, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1621, 2, 7, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1622, 2, 7, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1623, 2, 8, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1624, 2, 8, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1625, 2, 8, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1626, 2, 8, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1627, 2, 9, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1628, 2, 9, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1629, 2, 9, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1630, 2, 9, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1631, 2, 10, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1632, 2, 10, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1633, 2, 10, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1634, 2, 10, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1635, 2, 11, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1636, 2, 11, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1637, 2, 13, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1638, 2, 13, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1639, 2, 13, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1640, 2, 13, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1641, 2, 12, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1642, 2, 12, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1643, 2, 12, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1644, 2, 12, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1645, 2, 14, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1646, 2, 14, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1647, 2, 14, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1648, 2, 14, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1649, 2, 20, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1650, 2, 20, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1651, 2, 20, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1652, 2, 20, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1653, 2, 21, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1654, 2, 21, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1655, 2, 21, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1656, 2, 21, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1657, 2, 22, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1658, 2, 22, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1659, 2, 22, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1660, 2, 15, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1661, 2, 15, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1662, 2, 15, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1663, 2, 15, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1664, 2, 16, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1665, 2, 16, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1666, 2, 16, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1667, 2, 16, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1668, 2, 17, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1669, 2, 17, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1670, 2, 17, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1671, 2, 17, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1672, 2, 1, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1673, 2, 2, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1674, 2, 3, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1675, 2, 3, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1676, 2, 3, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1677, 2, 3, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1678, 2, 4, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1679, 2, 4, 2, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1680, 2, 4, 3, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1681, 2, 4, 4, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(1682, 2, 5, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(2046, 1, 6, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2047, 1, 19, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2048, 1, 18, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2049, 1, 18, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2050, 1, 18, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2051, 1, 18, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2052, 1, 18, 5, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2053, 1, 18, 6, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2054, 1, 18, 7, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2055, 1, 18, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2056, 1, 7, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2057, 1, 7, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2058, 1, 7, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2059, 1, 7, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2060, 1, 7, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2061, 1, 8, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2062, 1, 8, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2063, 1, 8, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2064, 1, 8, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2065, 1, 8, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2066, 1, 10, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2067, 1, 10, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2068, 1, 10, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2069, 1, 10, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2070, 1, 10, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2071, 1, 11, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2072, 1, 11, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2073, 1, 13, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2074, 1, 13, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2075, 1, 13, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2076, 1, 13, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2077, 1, 13, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2078, 1, 12, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2079, 1, 12, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2080, 1, 12, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2081, 1, 12, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2082, 1, 12, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2083, 1, 14, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2084, 1, 14, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2085, 1, 14, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2086, 1, 14, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2087, 1, 14, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2088, 1, 20, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2089, 1, 20, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2090, 1, 20, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2091, 1, 20, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2092, 1, 20, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2093, 1, 21, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2094, 1, 21, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2095, 1, 21, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2096, 1, 21, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2097, 1, 21, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2098, 1, 22, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2099, 1, 22, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2100, 1, 22, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2101, 1, 22, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2102, 1, 22, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2103, 1, 15, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2104, 1, 15, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2105, 1, 15, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2106, 1, 15, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2107, 1, 15, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2108, 1, 16, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2109, 1, 16, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2110, 1, 16, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2111, 1, 16, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2112, 1, 16, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2113, 1, 17, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2114, 1, 17, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2115, 1, 17, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2116, 1, 1, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2117, 1, 2, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2118, 1, 3, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2119, 1, 3, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2120, 1, 3, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2121, 1, 3, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2122, 1, 3, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2123, 1, 4, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2124, 1, 4, 2, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2125, 1, 4, 3, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2126, 1, 4, 4, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2127, 1, 4, 8, '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(2128, 1, 5, 1, '2024-07-24 00:29:49', '2024-07-24 00:29:49');

-- --------------------------------------------------------

--
-- Structure de la table `headers`
--

DROP TABLE IF EXISTS `headers`;
CREATE TABLE IF NOT EXISTS `headers` (
  `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `header` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `footer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `headers`
--

INSERT INTO `headers` (`id`, `libelle`, `header`, `footer`, `status`, `created_at`, `updated_at`) VALUES
(1, 'MANCI', 'manci.jpg', 'Maintenance Navire Cote d’Ivoire - 18 BP 3422 ABIDJAN 18\r\nTEL : 27 24 32 64 60 / CEL: 07 07 70 55 38 -Email: maintenancenavireci@yahoo.fr\r\nRC n° CI-ABJ-2011-B-1003-N° CC-1103672C\r\nC/Régime d’imposition : Réel normal CDI CME ABIDJAN SUD', '1', '2024-07-25 02:13:33', '2024-07-25 02:13:33'),
(2, 'IMNS', 'imns.jpg', 'IVOIRIENNE DE MAINTENANCE NAVALE & SERVICE - SARL AU CAPITAL DE 2 500 000 FCFA\r\n10 BP 1377 ABIDJAN 10 Tel: 09 70 07 30 / 47 61 91 60 FAX: + 225 21 25 08 14, NO RC: CI-ABJ-2015-B-27827, CCNO: 1556006 S14\r\nCOMPTE NUMERO : Cli12 01001 013309830003 47 VERSUS BANK', '1', '2024-07-25 02:13:33', '2024-07-25 02:13:33'),
(3, 'SORENA', 'sorena.jpg', 'SOCIETE DE REPARATION NAVALE - TREICHVILLE PORT DE PECHE 18 BP 765 ABIDJAN 18\r\nTEL/FAX : 21 24 66 37, CEL : 08 93 19 10 EMAIL : secretariat@sorena-ci.ci\r\nRCCM : CI-ABJ-2016-B-15561-CC : 1630438D / RÉGIME D\\\'IMPOSITION : RÉEL SIMPLIFIÉ CDI TRECHVILLE II', '1', '2024-07-25 02:13:33', '2024-07-25 02:13:33');

-- --------------------------------------------------------

--
-- Structure de la table `inspectors`
--

DROP TABLE IF EXISTS `inspectors`;
CREATE TABLE IF NOT EXISTS `inspectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `firstname` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `inspectors`
--

INSERT INTO `inspectors` (`id`, `lastname`, `firstname`, `number`, `email`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'SANTI', 'Sanchez', '07 07 09 19 90 / +34 620 84 99 10', 'santi.sanchez@albacora.es', '1', '2023-10-02 11:15:27', '2023-10-02 11:15:27', 1),
(2, 'INSPECTEUR', 'Test 2', '0100000001', 'inspecteurtest2@manci.ci', '1', '2023-10-04 19:35:52', '2023-10-04 19:39:32', 2),
(3, 'INSPECTEUR', 'Test 3', '0100000002', 'inspecteurtest3@manci.ci', '1', '2023-10-04 19:37:00', '2023-10-04 19:39:38', 2),
(4, 'INSPECTEUR QUALIFIE', 'Test 5', '+ 225 0100000004/010000005', 'inspecteurqualifie@manci.ci', '1', '2023-10-04 19:38:49', '2023-10-04 19:39:43', 2),
(5, 'INSPECTEUR QUALIFIE', 'Test 4', '+225 27202121221/ 0708090909', 'inspecteurqualifie2@manci.ci', '1', '2023-10-04 19:45:51', '2023-10-04 19:46:44', 2);

-- --------------------------------------------------------

--
-- Structure de la table `logs`
--

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `profil` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `action` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `color` varchar(10) COLLATE utf8mb3_unicode_ci NOT NULL,
  `avatar` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=869 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `logs`
--

INSERT INTO `logs` (`id`, `username`, `profil`, `libelle`, `action`, `color`, `avatar`, `created_at`, `updated_at`) VALUES
(1, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-09-30 13:23:14', '2023-09-30 13:23:14'),
(2, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', 'homme.jpg', '2023-09-30 13:58:27', '2023-09-30 13:58:27'),
(3, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', 'homme.jpg', '2023-09-30 13:58:41', '2023-09-30 13:58:41'),
(4, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', 'homme.jpg', '2023-09-30 14:06:28', '2023-09-30 14:06:28'),
(5, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-09-30 14:06:33', '2023-09-30 14:06:33'),
(6, 'Fabrice OGOU', 'Super Admin', 'Type paramètre: TRAVAUX', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 14:07:06', '2023-09-30 14:07:06'),
(7, 'Fabrice OGOU', 'Super Admin', 'Type paramètre: TRAVAUX', 'Désactiver', 'danger', 'homme.jpg', '2023-09-30 14:07:36', '2023-09-30 14:07:36'),
(8, 'Fabrice OGOU', 'Super Admin', 'Type paramètre: TRAVAUX', 'Activer', 'success', 'homme.jpg', '2023-09-30 14:07:40', '2023-09-30 14:07:40'),
(9, 'Fabrice OGOU', 'Super Admin', 'Type paramètre: TRAVAUX', 'Désactiver', 'danger', 'homme.jpg', '2023-09-30 14:08:39', '2023-09-30 14:08:39'),
(10, 'Fabrice OGOU', 'Super Admin', 'Type paramètre: TRAVAUX', 'Activer', 'success', 'homme.jpg', '2023-09-30 14:08:47', '2023-09-30 14:08:47'),
(11, 'Fabrice OGOU', 'Super Admin', 'Type paramètre: FOURNITURES', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 14:09:19', '2023-09-30 14:09:19'),
(12, 'Fabrice OGOU', 'Super Admin', 'Type paramètre: TRANSPORT', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 14:09:34', '2023-09-30 14:09:34'),
(13, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', 'homme.jpg', '2023-09-30 14:13:20', '2023-09-30 14:13:20'),
(14, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', 'homme.jpg', '2023-09-30 15:02:16', '2023-09-30 15:02:16'),
(15, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-09-30 15:02:20', '2023-09-30 15:02:20'),
(16, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', 'homme.jpg', '2023-09-30 15:28:07', '2023-09-30 15:28:07'),
(17, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', 'homme.jpg', '2023-09-30 15:28:17', '2023-09-30 15:28:17'),
(18, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-09-30 15:28:22', '2023-09-30 15:28:22'),
(19, 'Fabrice OGOU', 'Super Admin', 'Horaire: Chauffeur / Conductor', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 16:30:46', '2023-09-30 16:30:46'),
(20, 'Fabrice OGOU', 'Super Admin', 'Horaire: Ouvrier spécialisé mains nues / Trabajador calificado manos desnudas', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 16:36:19', '2023-09-30 16:36:19'),
(21, 'Fabrice OGOU', 'Super Admin', 'Horaire: Chauffeur / Conductor', 'Désactiver', 'danger', 'homme.jpg', '2023-09-30 16:40:46', '2023-09-30 16:40:46'),
(22, 'Fabrice OGOU', 'Super Admin', 'Horaire: Chauffeur / Conductor', 'Activer', 'success', 'homme.jpg', '2023-09-30 16:40:54', '2023-09-30 16:40:54'),
(23, 'Fabrice OGOU', 'Super Admin', 'Horaire: Chauffeur / Conductor', 'Désactiver', 'danger', 'homme.jpg', '2023-09-30 16:46:35', '2023-09-30 16:46:35'),
(24, 'Fabrice OGOU', 'Super Admin', 'Horaire: Chauffeur / Conductor', 'Activer', 'success', 'homme.jpg', '2023-09-30 16:46:41', '2023-09-30 16:46:41'),
(25, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', 'homme.jpg', '2023-09-30 18:09:35', '2023-09-30 18:09:35'),
(26, 'Fabrice OGOU', 'Super Admin', 'Type fourniture: Tuyaux', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 18:12:14', '2023-09-30 18:12:14'),
(27, 'Fabrice OGOU', 'Super Admin', 'Type fourniture: Brides', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 18:12:39', '2023-09-30 18:12:39'),
(28, 'Fabrice OGOU', 'Super Admin', 'Type fourniture: Brides', 'Désactiver', 'danger', 'homme.jpg', '2023-09-30 18:17:04', '2023-09-30 18:17:04'),
(29, 'Fabrice OGOU', 'Super Admin', 'Type fourniture: Brides', 'Activer', 'success', 'homme.jpg', '2023-09-30 18:17:12', '2023-09-30 18:17:12'),
(30, 'Fabrice OGOU', 'Super Admin', 'Type fourniture: Disque', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 18:23:31', '2023-09-30 18:23:31'),
(31, 'Fabrice OGOU', 'Super Admin', 'Horaire: Soudeur à l\'arc (MMA) homologue / Soldador por arco eléctrico (MMA) hom', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 18:27:22', '2023-09-30 18:27:22'),
(32, 'Fabrice OGOU', 'Super Admin', 'Horaires', 'Deconnecter', 'primary', 'homme.jpg', '2023-09-30 18:27:41', '2023-09-30 18:27:41'),
(33, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-09-30 18:27:48', '2023-09-30 18:27:48'),
(34, 'Fabrice OGOU', 'Super Admin', 'Fourniture: Tuyau API SCH40 Ø⅛ʺ', 'Ajouter', 'success', 'homme.jpg', '2023-09-30 19:59:28', '2023-09-30 19:59:28'),
(35, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-01 10:00:16', '2023-10-01 10:00:16'),
(36, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-01 10:00:17', '2023-10-01 10:00:17'),
(37, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-01 10:00:30', '2023-10-01 10:00:30'),
(38, 'Fabrice OGOU', 'Super Admin', 'Fourniture: Bride à souder acier Ø⅛ʺ', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 10:06:33', '2023-10-01 10:06:33'),
(39, 'Fabrice OGOU', 'Super Admin', 'Fourniture: Bride à souder acier Ø¼ʺ', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 10:07:02', '2023-10-01 10:07:02'),
(40, 'Fabrice OGOU', 'Super Admin', 'Fourniture: Bride à souder acier Ø⅛ʺ', 'Désactiver', 'danger', 'homme.jpg', '2023-10-01 10:13:06', '2023-10-01 10:13:06'),
(41, 'Fabrice OGOU', 'Super Admin', 'Fourniture: Bride à souder acier Ø⅛ʺ', 'Activer', 'success', 'homme.jpg', '2023-10-01 10:26:16', '2023-10-01 10:26:16'),
(42, 'Fabrice OGOU', 'Super Admin', 'Transport: Transport  de nuit A/R', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 11:04:17', '2023-10-01 11:04:17'),
(43, 'Fabrice OGOU', 'Super Admin', 'Transport: Transport de jour A/R', 'Modifier', 'warning', 'homme.jpg', '2023-10-01 11:04:58', '2023-10-01 11:04:58'),
(44, 'Fabrice OGOU', 'Super Admin', 'Transport: Transport  de nuit A/R', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 11:05:20', '2023-10-01 11:05:20'),
(45, 'Fabrice OGOU', 'Super Admin', 'Transport: Transport de jour A/R', 'Désactiver', 'danger', 'homme.jpg', '2023-10-01 11:05:30', '2023-10-01 11:05:30'),
(46, 'Fabrice OGOU', 'Super Admin', 'Transport: Transport de jour A/R', 'Activer', 'success', 'homme.jpg', '2023-10-01 11:05:39', '2023-10-01 11:05:39'),
(47, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', 'homme.jpg', '2023-10-01 13:11:06', '2023-10-01 13:11:06'),
(48, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', 'homme.jpg', '2023-10-01 13:11:15', '2023-10-01 13:11:15'),
(49, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-01 13:11:23', '2023-10-01 13:11:23'),
(50, 'Fabrice OGOU', 'Super Admin', 'Unité: Mètre', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 13:12:32', '2023-10-01 13:12:32'),
(51, 'Fabrice OGOU', 'Super Admin', 'Unité: Paquet', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 13:14:00', '2023-10-01 13:14:00'),
(52, 'Fabrice OGOU', 'Super Admin', 'Unité: Mètre', 'Désactiver', 'danger', 'homme.jpg', '2023-10-01 13:14:11', '2023-10-01 13:14:11'),
(53, 'Fabrice OGOU', 'Super Admin', 'Unité: Mètre', 'Activer', 'success', 'homme.jpg', '2023-10-01 13:14:21', '2023-10-01 13:14:21'),
(54, 'Fabrice OGOU', 'Super Admin', 'Unité: Kilogramme', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 14:01:13', '2023-10-01 14:01:13'),
(55, 'Fabrice OGOU', 'Super Admin', 'Unité: Heure', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 14:02:18', '2023-10-01 14:02:18'),
(56, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', 'homme.jpg', '2023-10-01 15:28:28', '2023-10-01 15:28:28'),
(57, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', 'homme.jpg', '2023-10-01 15:28:40', '2023-10-01 15:28:40'),
(58, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-01 15:28:46', '2023-10-01 15:28:46'),
(59, 'Fabrice OGOU', 'Super Admin', 'Quantité: ¼', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 15:30:35', '2023-10-01 15:30:35'),
(60, 'Fabrice OGOU', 'Super Admin', 'Quantité: ¾', 'Ajouter', 'success', 'homme.jpg', '2023-10-01 15:44:12', '2023-10-01 15:44:12'),
(61, 'Fabrice OGOU', 'Super Admin', 'Utilisateur: Fabrice OGOU', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-01 15:44:44', '2023-10-01 15:44:44'),
(62, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-02 09:59:21', '2023-10-02 09:59:21'),
(63, 'Fabrice OGOU', 'Super Admin', 'Client: GRUPO ALBACORA', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 10:40:21', '2023-10-02 10:40:21'),
(64, 'Fabrice OGOU', 'Super Admin', 'Adresse Facturaction: ALBACORA, S.A. (RAZON SOCIAL)', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 10:56:04', '2023-10-02 10:56:04'),
(65, 'Fabrice OGOU', 'Super Admin', 'Inspecteur: Sanchez SANTI', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:15:27', '2023-10-02 11:15:27'),
(66, 'Fabrice OGOU', 'Super Admin', 'Navire: ALBACORA QUINCE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:17:57', '2023-10-02 11:17:57'),
(67, 'Fabrice OGOU', 'Super Admin', 'Type fourniture: Tuyaux', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:23:19', '2023-10-02 11:23:19'),
(68, 'Fabrice OGOU', 'Super Admin', 'Horaire: Ouvrier spécialisé mains nues / Trabajador calificado manos desnudas', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:24:10', '2023-10-02 11:24:10'),
(69, 'Fabrice OGOU', 'Super Admin', 'Fourniture: Tuyau API SCH40 Ø⅛ʺ x1m', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:25:11', '2023-10-02 11:25:11'),
(70, 'Fabrice OGOU', 'Super Admin', 'Transport: Transport  de jour A/R', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:25:44', '2023-10-02 11:25:44'),
(71, 'Fabrice OGOU', 'Super Admin', 'Unité: Heures', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:26:17', '2023-10-02 11:26:17'),
(72, 'Fabrice OGOU', 'Super Admin', 'Quantité: ¼', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-02 11:29:03', '2023-10-02 11:29:03'),
(73, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-04 16:04:25', '2023-10-04 16:04:25'),
(74, 'Paul N\'CHO', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-05 11:55:58', '2023-10-05 11:55:58'),
(75, 'Paul N\'CHO', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-05 12:38:11', '2023-10-05 12:38:11'),
(76, 'Paul N\'CHO', 'Administrateur', 'Navires', 'Deconnecter', 'primary', 'homme.jpg', '2023-10-05 12:40:54', '2023-10-05 12:40:54'),
(77, 'Paul N\'CHO', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-05 12:40:59', '2023-10-05 12:40:59'),
(78, 'Paul N\'CHO', 'Administrateur', 'Profil: COMMERCIAL', 'Ajouter', 'success', 'homme.jpg', '2023-10-05 12:41:58', '2023-10-05 12:41:58'),
(79, 'Paul N\'CHO', 'Administrateur', 'Profil: COMMERCIAL', 'Activer', 'success', 'homme.jpg', '2023-10-05 12:42:09', '2023-10-05 12:42:09'),
(80, 'Paul N\'CHO', 'Administrateur', 'Utilisateur: Paul N\'CHO', 'Désactiver', 'danger', 'homme.jpg', '2023-10-05 12:42:51', '2023-10-05 12:42:51'),
(81, 'Paul N\'CHO', 'Administrateur', 'Utilisateur: Paul N\'CHO', 'Modifier', 'warning', 'homme.jpg', '2023-10-05 12:43:05', '2023-10-05 12:43:05'),
(82, 'Paul N\'CHO', 'Administrateur', 'Utilisateur', 'Deconnecter', 'primary', 'homme.jpg', '2023-10-05 12:43:10', '2023-10-05 12:43:10'),
(83, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-05 12:43:29', '2023-10-05 12:43:29'),
(84, 'Fabrice OGOU', 'Super Admin', 'Utilisateur: Paul N\'CHO', 'Activer', 'success', '20231001154444.jpg', '2023-10-05 12:43:39', '2023-10-05 12:43:39'),
(85, 'Fabrice OGOU', 'Super Admin', 'Utilisateur', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-10-05 12:43:43', '2023-10-05 12:43:43'),
(86, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-10-05 12:43:53', '2023-10-05 12:43:53'),
(87, 'Paul N\'CHO', 'COMMERCIAL', 'Clients', 'Deconnecter', 'primary', 'homme.jpg', '2023-10-05 12:44:09', '2023-10-05 12:44:09'),
(88, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-05 12:44:19', '2023-10-05 12:44:19'),
(89, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-05 15:36:30', '2023-10-05 15:36:30'),
(90, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-05 16:11:04', '2023-10-05 16:11:04'),
(91, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-10-05 16:11:12', '2023-10-05 16:11:12'),
(92, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-05 16:11:16', '2023-10-05 16:11:16'),
(93, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-06 13:02:58', '2023-10-06 13:02:58'),
(94, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-07 15:05:14', '2023-10-07 15:05:14'),
(95, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-09 10:18:57', '2023-10-09 10:18:57'),
(96, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-09 15:58:09', '2023-10-09 15:58:09'),
(97, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-09 15:58:16', '2023-10-09 15:58:16'),
(98, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-09 15:59:17', '2023-10-09 15:59:17'),
(99, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-10-09 15:59:26', '2023-10-09 15:59:26'),
(100, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-09 15:59:32', '2023-10-09 15:59:32'),
(101, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-10 10:04:16', '2023-10-10 10:04:16'),
(102, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-10 19:58:18', '2023-10-10 19:58:18'),
(103, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-11 10:50:40', '2023-10-11 10:50:40'),
(104, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-11 10:50:47', '2023-10-11 10:50:47'),
(105, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-11 18:52:34', '2023-10-11 18:52:34'),
(106, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-12 05:31:41', '2023-10-12 05:31:41'),
(107, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-12 19:47:56', '2023-10-12 19:47:56'),
(108, 'Fabrice OGOU', 'Super Admin', 'Utilisateur', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-10-12 19:59:09', '2023-10-12 19:59:09'),
(109, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-12 19:59:18', '2023-10-12 19:59:18'),
(110, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-13 08:35:27', '2023-10-13 08:35:27'),
(111, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-13 19:31:26', '2023-10-13 19:31:26'),
(112, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-14 08:21:27', '2023-10-14 08:21:27'),
(113, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-14 16:04:10', '2023-10-14 16:04:10'),
(114, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-15 05:28:35', '2023-10-15 05:28:35'),
(115, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-15 10:42:21', '2023-10-15 10:42:21'),
(116, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-15 18:46:58', '2023-10-15 18:46:58'),
(117, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-16 09:55:19', '2023-10-16 09:55:19'),
(118, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 10:16:57', '2023-10-16 10:16:57'),
(119, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 11:26:39', '2023-10-16 11:26:39'),
(120, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-16 15:18:43', '2023-10-16 15:18:43'),
(121, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 15:21:03', '2023-10-16 15:21:03'),
(122, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 15:46:20', '2023-10-16 15:46:20'),
(123, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: TAQUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 15:58:32', '2023-10-16 15:58:32'),
(124, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 16:07:37', '2023-10-16 16:07:37'),
(125, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 16:13:45', '2023-10-16 16:13:45'),
(126, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 16:32:43', '2023-10-16 16:32:43'),
(127, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 16:34:32', '2023-10-16 16:34:32'),
(128, 'Fabrice OGOU', 'Super Admin', 'TRANSPORT: TRANSPORT LAGUNARIO', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 16:38:39', '2023-10-16 16:38:39'),
(129, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 18:49:37', '2023-10-16 18:49:37'),
(130, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 21:16:52', '2023-10-16 21:16:52'),
(131, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 21:19:23', '2023-10-16 21:19:23'),
(132, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 21:21:58', '2023-10-16 21:21:58'),
(133, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 21:30:00', '2023-10-16 21:30:00'),
(134, 'Fabrice OGOU', 'Super Admin', 'TRANSPORT: TRANSPORT LAGUNARIO', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-16 21:37:44', '2023-10-16 21:37:44'),
(135, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-17 12:55:05', '2023-10-17 12:55:05'),
(136, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-17 17:14:28', '2023-10-17 17:14:28'),
(137, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-17 17:19:23', '2023-10-17 17:19:23'),
(138, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-18 10:50:29', '2023-10-18 10:50:29'),
(139, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 11:05:18', '2023-10-18 11:05:18'),
(140, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 11:08:31', '2023-10-18 11:08:31'),
(141, 'Fabrice OGOU', 'Super Admin', 'TRANSPORT: QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 11:09:45', '2023-10-18 11:09:45'),
(142, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 11:14:54', '2023-10-18 11:14:54'),
(143, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 12:06:30', '2023-10-18 12:06:30'),
(144, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: SHIPPING ADDRESS', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 12:39:27', '2023-10-18 12:39:27'),
(145, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: SHIPPING ADDRESS', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 12:51:46', '2023-10-18 12:51:46'),
(146, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-18 17:26:53', '2023-10-18 17:26:53'),
(147, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-18 22:22:25', '2023-10-18 22:22:25'),
(148, 'Fabrice OGOU', 'Super Admin', 'Unité: Litre', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-18 22:34:50', '2023-10-18 22:34:50'),
(149, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-19 12:00:36', '2023-10-19 12:00:36'),
(150, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-19 19:07:52', '2023-10-19 19:07:52'),
(151, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-20 10:13:49', '2023-10-20 10:13:49'),
(152, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-20 19:00:52', '2023-10-20 19:00:52'),
(153, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-20 19:56:55', '2023-10-20 19:56:55'),
(154, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-21 08:50:21', '2023-10-21 08:50:21'),
(155, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: CHIEF TECHNICAL OFFICER', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 09:09:25', '2023-10-21 09:09:25'),
(156, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 14:07:53', '2023-10-21 14:07:53'),
(157, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 14:26:24', '2023-10-21 14:26:24'),
(158, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 14:33:37', '2023-10-21 14:33:37'),
(159, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: VARIANCE-GRH', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:01:49', '2023-10-21 15:01:49'),
(160, 'Fabrice OGOU', 'Super Admin', 'TRANSPORT: VARIANCE-GRH 2', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:10:18', '2023-10-21 15:10:18'),
(161, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:19:38', '2023-10-21 15:19:38'),
(162, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: VARIANCE-GRH', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:21:12', '2023-10-21 15:21:12'),
(163, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:27:09', '2023-10-21 15:27:09'),
(164, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:30:10', '2023-10-21 15:30:10'),
(165, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: VARIANCE-GRH', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:31:39', '2023-10-21 15:31:39'),
(166, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:38:35', '2023-10-21 15:38:35'),
(167, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: VARIANCE-GRH', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:53:01', '2023-10-21 15:53:01'),
(168, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: CHIEF TECHNICAL OFFICER', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 15:54:41', '2023-10-21 15:54:41'),
(169, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: CHIEF TECHNICAL OFFICER', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 16:15:19', '2023-10-21 16:15:19'),
(170, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 16:32:02', '2023-10-21 16:32:02'),
(171, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: V A R I A N C E-G R H 1', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 16:34:50', '2023-10-21 16:34:50'),
(172, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H 2', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 16:37:50', '2023-10-21 16:37:50'),
(173, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-21 19:35:57', '2023-10-21 19:35:57'),
(174, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 20:02:27', '2023-10-21 20:02:27'),
(175, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 20:11:21', '2023-10-21 20:11:21'),
(176, 'Fabrice OGOU', 'Super Admin', 'TRANSPORT: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 20:12:42', '2023-10-21 20:12:42'),
(177, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-21 20:36:02', '2023-10-21 20:36:02'),
(178, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-22 15:23:15', '2023-10-22 15:23:15'),
(179, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-22 16:10:13', '2023-10-22 16:10:13'),
(180, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-22 16:13:06', '2023-10-22 16:13:06'),
(181, 'Fabrice OGOU', 'Super Admin', 'TRANSPORT: TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-22 16:15:24', '2023-10-22 16:15:24'),
(182, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-22 16:17:36', '2023-10-22 16:17:36'),
(183, 'Fabrice OGOU', 'Super Admin', 'FOURNITURES: PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-22 16:23:34', '2023-10-22 16:23:34'),
(184, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: V A R I A N C E-G R H', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-22 16:58:00', '2023-10-22 16:58:00'),
(185, 'Fabrice OGOU', 'Super Admin', 'TRAVAUX: AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-22 17:15:11', '2023-10-22 17:15:11'),
(186, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-23 18:55:46', '2023-10-23 18:55:46'),
(187, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-24 11:31:32', '2023-10-24 11:31:32'),
(188, 'Fabrice OGOU', 'Super Admin', ': QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-24 13:31:12', '2023-10-24 13:31:12'),
(189, 'Fabrice OGOU', 'Super Admin', ': QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-24 13:34:17', '2023-10-24 13:34:17'),
(190, 'Fabrice OGOU', 'Super Admin', ': QWERTY 2', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-24 13:37:33', '2023-10-24 13:37:33'),
(191, 'Fabrice OGOU', 'Super Admin', ': QWERTY 2', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-24 13:43:58', '2023-10-24 13:43:58'),
(192, 'Fabrice OGOU', 'Super Admin', ': QWERTY 1', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-24 15:17:08', '2023-10-24 15:17:08'),
(193, 'Fabrice OGOU', 'Super Admin', ': QWERTY 3', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-24 15:18:56', '2023-10-24 15:18:56'),
(194, 'Fabrice OGOU', 'Super Admin', ': QWERTY 4', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-24 15:52:31', '2023-10-24 15:52:31'),
(195, 'Fabrice OGOU', 'Super Admin', ': QWERTY 4', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-24 15:53:36', '2023-10-24 15:53:36'),
(196, 'Fabrice OGOU', 'Super Admin', ': QWERTY 5', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-24 15:54:32', '2023-10-24 15:54:32'),
(197, 'Fabrice OGOU', 'Super Admin', ': QWERTY 1', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-24 18:19:46', '2023-10-24 18:19:46'),
(198, 'Fabrice OGOU', 'Super Admin', ': QWERTY 1', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-24 18:21:29', '2023-10-24 18:21:29'),
(199, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-25 21:11:58', '2023-10-25 21:11:58'),
(200, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-26 10:25:39', '2023-10-26 10:25:39'),
(201, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-26 13:49:27', '2023-10-26 13:49:27'),
(202, 'Fabrice OGOU', 'Super Admin', 'Type de devis', 'Supprimer', 'danger', '20231001154444.jpg', '2023-10-26 13:50:00', '2023-10-26 13:50:00'),
(203, 'Fabrice OGOU', 'Super Admin', ': TRANSPORT LAGUNARIO', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-26 14:41:44', '2023-10-26 14:41:44'),
(204, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-26 14:42:57', '2023-10-26 14:42:57'),
(205, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-26 14:43:42', '2023-10-26 14:43:42'),
(206, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-26 18:05:07', '2023-10-26 18:05:07'),
(207, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-26 22:11:54', '2023-10-26 22:11:54'),
(208, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-27 08:48:07', '2023-10-27 08:48:07'),
(209, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-27 09:05:33', '2023-10-27 09:05:33'),
(210, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-27 09:10:18', '2023-10-27 09:10:18'),
(211, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-10-27 09:14:09', '2023-10-27 09:14:09'),
(212, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-27 15:42:08', '2023-10-27 15:42:08'),
(213, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-28 02:49:00', '2023-10-28 02:49:00'),
(214, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-28 08:38:09', '2023-10-28 08:38:09'),
(215, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-28 15:09:21', '2023-10-28 15:09:21'),
(216, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-28 19:13:44', '2023-10-28 19:13:44'),
(217, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-28 19:16:01', '2023-10-28 19:16:01'),
(218, 'Fabrice OGOU', 'Super Admin', ': TRANSPORT LAGUNARIO', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-28 19:18:10', '2023-10-28 19:18:10'),
(219, 'Fabrice OGOU', 'Super Admin', ': VARIANCE-GRH', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-28 19:31:11', '2023-10-28 19:31:11'),
(220, 'Fabrice OGOU', 'Super Admin', ': VARIANCE-GRH', 'Modifier', 'warning', '20231001154444.jpg', '2023-10-28 19:35:36', '2023-10-28 19:35:36'),
(221, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-29 02:05:50', '2023-10-29 02:05:50'),
(222, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-29 09:16:40', '2023-10-29 09:16:40'),
(223, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-29 12:13:26', '2023-10-29 12:13:26'),
(224, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-29 18:31:40', '2023-10-29 18:31:40'),
(225, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-10-31 14:42:48', '2023-10-31 14:42:48'),
(226, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-11 07:18:52', '2023-11-11 07:18:52'),
(227, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-11 07:28:40', '2023-11-11 07:28:40'),
(228, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-11 07:29:05', '2023-11-11 07:29:05'),
(229, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-11 07:29:18', '2023-11-11 07:29:18'),
(230, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-11 07:29:23', '2023-11-11 07:29:23'),
(231, 'Fabrice OGOU', 'Super Admin', 'Profil: COMMERCIAL', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-11 07:39:24', '2023-11-11 07:39:24'),
(232, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-11 07:39:40', '2023-11-11 07:39:40'),
(233, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-11-11 07:40:43', '2023-11-11 07:40:43'),
(234, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-11-11 18:38:41', '2023-11-11 18:38:41'),
(235, 'Paul N\'CHO', 'COMMERCIAL', 'Devis', 'Deconnecter', 'primary', 'homme.jpg', '2023-11-11 18:46:27', '2023-11-11 18:46:27'),
(236, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-11 18:46:37', '2023-11-11 18:46:37'),
(237, 'Fabrice OGOU', 'Super Admin', 'Navires', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-11 18:50:26', '2023-11-11 18:50:26'),
(238, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-11-11 18:50:37', '2023-11-11 18:50:37'),
(239, 'Paul N\'CHO', 'COMMERCIAL', 'Devis', 'Transmettre', 'success', 'homme.jpg', '2023-11-11 18:57:03', '2023-11-11 18:57:03'),
(240, 'Paul N\'CHO', 'COMMERCIAL', 'Devis', 'Deconnecter', 'primary', 'homme.jpg', '2023-11-11 18:59:01', '2023-11-11 18:59:01'),
(241, 'James AKRAN', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-11-11 18:59:28', '2023-11-11 18:59:28'),
(242, 'James AKRAN', 'Administrateur', 'Tableau de bord', 'Deconnecter', 'primary', 'homme.jpg', '2023-11-11 18:59:40', '2023-11-11 18:59:40'),
(243, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-11 18:59:49', '2023-11-11 18:59:49'),
(244, 'Fabrice OGOU', 'Super Admin', 'Profil: Administrateur', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-11 19:01:11', '2023-11-11 19:01:11'),
(245, 'Fabrice OGOU', 'Super Admin', 'Profil: Administrateur', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-11 19:01:23', '2023-11-11 19:01:23'),
(246, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2023-11-11 21:22:34', '2023-11-11 21:22:34'),
(247, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Rejeter', 'danger', '20231001154444.jpg', '2023-11-11 21:24:21', '2023-11-11 21:24:21'),
(248, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-12 08:52:50', '2023-11-12 08:52:50'),
(249, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-12 08:53:08', '2023-11-12 08:53:08'),
(250, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2023-11-12 08:53:26', '2023-11-12 08:53:26'),
(251, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-12 08:57:13', '2023-11-12 08:57:13'),
(252, 'Fabrice OGOU', 'Super Admin', ': VARIANCE-GRH', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-12 09:49:14', '2023-11-12 09:49:14'),
(253, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-12 15:30:25', '2023-11-12 15:30:25'),
(254, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2023-11-12 15:30:48', '2023-11-12 15:30:48'),
(255, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 15:31:10', '2023-11-12 15:31:10'),
(256, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 15:35:01', '2023-11-12 15:35:01'),
(257, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 15:35:43', '2023-11-12 15:35:43'),
(258, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 15:37:06', '2023-11-12 15:37:06'),
(259, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-12 15:38:26', '2023-11-12 15:38:26'),
(260, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-12 15:38:57', '2023-11-12 15:38:57'),
(261, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 15:39:35', '2023-11-12 15:39:35'),
(262, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 15:44:05', '2023-11-12 15:44:05'),
(263, 'Fabrice OGOU', 'Super Admin', 'Quantité: ⅜', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-12 16:23:16', '2023-11-12 16:23:16'),
(264, 'Fabrice OGOU', 'Super Admin', 'Quantité', 'Activer', 'success', '20231001154444.jpg', '2023-11-12 16:23:27', '2023-11-12 16:23:27'),
(265, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Refuser', 'danger', '20231001154444.jpg', '2023-11-12 16:24:04', '2023-11-12 16:24:04'),
(266, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 16:24:39', '2023-11-12 16:24:39'),
(267, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-12 16:27:32', '2023-11-12 16:27:32'),
(268, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-12 19:07:26', '2023-11-12 19:07:26'),
(269, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-13 15:28:38', '2023-11-13 15:28:38'),
(270, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-13 16:52:37', '2023-11-13 16:52:37'),
(271, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-13 16:54:06', '2023-11-13 16:54:06'),
(272, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-14 10:46:09', '2023-11-14 10:46:09'),
(273, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-14 14:45:23', '2023-11-14 14:45:23'),
(274, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-14 15:38:49', '2023-11-14 15:38:49'),
(275, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-11-14 15:41:23', '2023-11-14 15:41:23'),
(276, 'Paul N\'CHO', 'COMMERCIAL', 'Devis', 'Deconnecter', 'primary', 'homme.jpg', '2023-11-14 16:22:52', '2023-11-14 16:22:52'),
(277, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-11-14 16:22:58', '2023-11-14 16:22:58'),
(278, 'Paul N\'CHO', 'COMMERCIAL', 'Tableau de bord', 'Deconnecter', 'primary', 'homme.jpg', '2023-11-14 16:23:03', '2023-11-14 16:23:03'),
(279, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-14 16:23:13', '2023-11-14 16:23:13'),
(280, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-14 17:14:14', '2023-11-14 17:14:14'),
(281, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-11-14 17:14:23', '2023-11-14 17:14:23'),
(282, 'Paul N\'CHO', 'COMMERCIAL', ': AZERTY', 'Ajouter', 'success', 'homme.jpg', '2023-11-14 17:15:50', '2023-11-14 17:15:50'),
(283, 'Paul N\'CHO', 'COMMERCIAL', 'Devis', 'Deconnecter', 'primary', 'homme.jpg', '2023-11-14 17:41:05', '2023-11-14 17:41:05'),
(284, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-14 17:44:47', '2023-11-14 17:44:47'),
(285, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-14 17:57:40', '2023-11-14 17:57:40'),
(286, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-14 17:57:45', '2023-11-14 17:57:45'),
(287, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-14 17:57:50', '2023-11-14 17:57:50'),
(288, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-20 10:27:02', '2023-11-20 10:27:02'),
(289, 'Fabrice OGOU', 'Super Admin', 'Type (Fourniture): Cartouche', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-20 10:31:19', '2023-11-20 10:31:19'),
(290, 'Fabrice OGOU', 'Super Admin', 'Type fourniture', 'Activer', 'success', '20231001154444.jpg', '2023-11-20 10:31:39', '2023-11-20 10:31:39'),
(291, 'Fabrice OGOU', 'Super Admin', 'Fourniture: Toner HP', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-20 11:25:28', '2023-11-20 11:25:28'),
(292, 'Fabrice OGOU', 'Super Admin', 'Fourniture', 'Activer', 'success', '20231001154444.jpg', '2023-11-20 11:25:40', '2023-11-20 11:25:40'),
(293, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-21 15:30:50', '2023-11-21 15:30:50'),
(294, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): API SCH40', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:02:19', '2023-11-21 16:02:19'),
(295, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): API SCH400', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-21 16:03:07', '2023-11-21 16:03:07'),
(296, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): API SCH40', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-21 16:03:16', '2023-11-21 16:03:16'),
(297, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): API SCH80', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:03:40', '2023-11-21 16:03:40'),
(298, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): API SCH100', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:04:07', '2023-11-21 16:04:07'),
(299, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Hydraulique', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:04:27', '2023-11-21 16:04:27'),
(300, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): inox', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:04:56', '2023-11-21 16:04:56'),
(301, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Inox', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-21 16:05:16', '2023-11-21 16:05:16'),
(302, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Galvanisé', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:05:42', '2023-11-21 16:05:42'),
(303, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Aluminium', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:06:04', '2023-11-21 16:06:04'),
(304, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Bride à souder', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:06:58', '2023-11-21 16:06:58'),
(305, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Bride pleine', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 16:07:20', '2023-11-21 16:07:20'),
(306, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-21 19:04:50', '2023-11-21 19:04:50'),
(307, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-21 19:05:35', '2023-11-21 19:05:35'),
(308, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-21 19:17:31', '2023-11-21 19:17:31'),
(309, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-21 19:17:36', '2023-11-21 19:17:36'),
(310, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-21 19:17:42', '2023-11-21 19:17:42'),
(311, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): pleine', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:31:01', '2023-11-21 21:31:01'),
(312, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): vide', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-21 21:31:50', '2023-11-21 21:31:50'),
(313, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): à souder', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-21 21:32:03', '2023-11-21 21:32:03'),
(314, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): acier', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:43:58', '2023-11-21 21:43:58'),
(315, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): inox', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:44:20', '2023-11-21 21:44:20'),
(316, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): API SCH40', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:44:39', '2023-11-21 21:44:39'),
(317, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): API SCH80', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:44:49', '2023-11-21 21:44:49'),
(318, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): API SCH100', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:45:06', '2023-11-21 21:45:06'),
(319, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): Hydraulique', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:45:21', '2023-11-21 21:45:21'),
(320, 'Fabrice OGOU', 'Super Admin', 'Diamètre (Fourniture): Ø⅛ʺ x1m', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 21:55:57', '2023-11-21 21:55:57'),
(321, 'Fabrice OGOU', 'Super Admin', 'Diamètre (Fourniture): Ø¼ʺ x1m', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 22:04:47', '2023-11-21 22:04:47'),
(322, 'Fabrice OGOU', 'Super Admin', 'Diamètre (Fourniture): Ø⅜ʺ x1m', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 22:05:35', '2023-11-21 22:05:35'),
(323, 'Fabrice OGOU', 'Super Admin', 'Diamètre (Fourniture): Ø½ʺ x1m', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 22:06:07', '2023-11-21 22:06:07'),
(324, 'Fabrice OGOU', 'Super Admin', 'Diamètre (Fourniture): Ø¾ʺ x1m', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 22:06:28', '2023-11-21 22:06:28'),
(325, 'Fabrice OGOU', 'Super Admin', 'Diamètre (Fourniture): Ø⅛ʺ', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 22:06:46', '2023-11-21 22:06:46'),
(326, 'Fabrice OGOU', 'Super Admin', 'Diamètre (Fourniture): Ø¼ʺ', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-21 22:07:04', '2023-11-21 22:07:04'),
(327, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:17:48', '2023-11-21 22:17:48'),
(328, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:18:01', '2023-11-21 22:18:01'),
(329, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:23:25', '2023-11-21 22:23:25'),
(330, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:23:57', '2023-11-21 22:23:57'),
(331, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:24:15', '2023-11-21 22:24:15'),
(332, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:24:28', '2023-11-21 22:24:28'),
(333, 'Fabrice OGOU', 'Super Admin', 'Diamètre (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:25:17', '2023-11-21 22:25:17'),
(334, 'Fabrice OGOU', 'Super Admin', 'Diamètre (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:25:27', '2023-11-21 22:25:27'),
(335, 'Fabrice OGOU', 'Super Admin', 'Diamètre (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-21 22:25:36', '2023-11-21 22:25:36'),
(336, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-22 10:12:32', '2023-11-22 10:12:32'),
(337, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-22 13:59:15', '2023-11-22 13:59:15'),
(338, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Désactiver', 'danger', '20231001154444.jpg', '2023-11-22 14:01:15', '2023-11-22 14:01:15'),
(339, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Bride pleine', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-22 14:01:36', '2023-11-22 14:01:36'),
(340, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-22 14:01:43', '2023-11-22 14:01:43'),
(341, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Désactiver', 'danger', '20231001154444.jpg', '2023-11-22 14:01:50', '2023-11-22 14:01:50'),
(342, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Bride à souder', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-22 14:02:02', '2023-11-22 14:02:02');
INSERT INTO `logs` (`id`, `username`, `profil`, `libelle`, `action`, `color`, `avatar`, `created_at`, `updated_at`) VALUES
(343, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-22 14:02:15', '2023-11-22 14:02:15'),
(344, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-22 14:14:32', '2023-11-22 14:14:32'),
(345, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-22 14:15:43', '2023-11-22 14:15:43'),
(346, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-22 14:27:26', '2023-11-22 14:27:26'),
(347, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-22 20:17:55', '2023-11-22 20:17:55'),
(348, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-23 09:55:57', '2023-11-23 09:55:57'),
(349, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 16:24:38', '2023-11-23 16:24:38'),
(350, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-23 18:34:53', '2023-11-23 18:34:53'),
(351, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 18:39:38', '2023-11-23 18:39:38'),
(352, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 18:59:38', '2023-11-23 18:59:38'),
(353, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Tuyau aluminium', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 19:12:49', '2023-11-23 19:12:49'),
(354, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Tuyau galvanisé', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 19:13:26', '2023-11-23 19:13:26'),
(355, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Tuyau inox', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 19:13:39', '2023-11-23 19:13:39'),
(356, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture): Tuyau hydraulique', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 19:13:52', '2023-11-23 19:13:52'),
(357, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:13:59', '2023-11-23 19:13:59'),
(358, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:14:08', '2023-11-23 19:14:08'),
(359, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:14:15', '2023-11-23 19:14:15'),
(360, 'Fabrice OGOU', 'Super Admin', 'Libellé (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:14:22', '2023-11-23 19:14:22'),
(361, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:15:28', '2023-11-23 19:15:28'),
(362, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:15:57', '2023-11-23 19:15:57'),
(363, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:16:03', '2023-11-23 19:16:03'),
(364, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(365, 'Fabrice OGOU', 'Super Admin', 'Profils', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-23 19:18:43', '2023-11-23 19:18:43'),
(366, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-23 19:18:50', '2023-11-23 19:18:50'),
(367, 'Fabrice OGOU', 'Super Admin', 'Diamètre (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:19:22', '2023-11-23 19:19:22'),
(368, 'Fabrice OGOU', 'Super Admin', 'Diamètre (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2023-11-23 19:19:32', '2023-11-23 19:19:32'),
(369, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 19:50:42', '2023-11-23 19:50:42'),
(370, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 20:04:06', '2023-11-23 20:04:06'),
(371, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 20:06:22', '2023-11-23 20:06:22'),
(372, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 20:10:42', '2023-11-23 20:10:42'),
(373, 'Fabrice OGOU', 'Super Admin', ': QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 20:12:30', '2023-11-23 20:12:30'),
(374, 'Fabrice OGOU', 'Super Admin', ': QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-23 20:14:53', '2023-11-23 20:14:53'),
(375, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 22:04:59', '2023-11-23 22:04:59'),
(376, 'Fabrice OGOU', 'Super Admin', ': QWERTY', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 22:15:01', '2023-11-23 22:15:01'),
(377, 'Fabrice OGOU', 'Super Admin', ': QWERTY', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-23 22:29:21', '2023-11-23 22:29:21'),
(378, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-24 08:48:02', '2023-11-24 08:48:02'),
(379, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-24 08:50:26', '2023-11-24 08:50:26'),
(380, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-24 08:53:45', '2023-11-24 08:53:45'),
(381, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-24 09:00:08', '2023-11-24 09:00:08'),
(382, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-24 09:02:02', '2023-11-24 09:02:02'),
(383, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-24 09:04:13', '2023-11-24 09:04:13'),
(384, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-24 09:09:47', '2023-11-24 09:09:47'),
(385, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-25 15:36:26', '2023-11-25 15:36:26'),
(386, 'Fabrice OGOU', 'Super Admin', ': TRANSPORT LAGUNARIO', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-25 17:07:02', '2023-11-25 17:07:02'),
(387, 'Fabrice OGOU', 'Super Admin', ': TRANSPORT LAGUNARIO', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-25 17:11:34', '2023-11-25 17:11:34'),
(388, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-25 17:19:24', '2023-11-25 17:19:24'),
(389, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-25 17:21:15', '2023-11-25 17:21:15'),
(390, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-25 19:41:15', '2023-11-25 19:41:15'),
(391, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-25 19:43:13', '2023-11-25 19:43:13'),
(392, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-25 19:54:33', '2023-11-25 19:54:33'),
(393, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-25 20:03:33', '2023-11-25 20:03:33'),
(394, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-25 20:36:34', '2023-11-25 20:36:34'),
(395, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-26 20:05:16', '2023-11-26 20:05:16'),
(396, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-11-26 20:38:52', '2023-11-26 20:38:52'),
(397, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-26 21:45:29', '2023-11-26 21:45:29'),
(398, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2023-11-26 21:46:50', '2023-11-26 21:46:50'),
(399, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-26 21:46:59', '2023-11-26 21:46:59'),
(400, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-26 21:49:12', '2023-11-26 21:49:12'),
(401, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-26 21:55:35', '2023-11-26 21:55:35'),
(402, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-27 06:58:32', '2023-11-27 06:58:32'),
(403, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-27 11:55:00', '2023-11-27 11:55:00'),
(404, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-27 11:56:40', '2023-11-27 11:56:40'),
(405, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-27 12:02:21', '2023-11-27 12:02:21'),
(406, 'Fabrice OGOU', 'Super Admin', ': TRANSPORT', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-27 12:04:02', '2023-11-27 12:04:02'),
(407, 'Fabrice OGOU', 'Super Admin', ': TRANSPORT', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-27 12:06:40', '2023-11-27 12:06:40'),
(408, 'Fabrice OGOU', 'Super Admin', ': TRANSPORT', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-27 12:07:44', '2023-11-27 12:07:44'),
(409, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-27 12:08:01', '2023-11-27 12:08:01'),
(410, 'Fabrice OGOU', 'Super Admin', ': QWERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-27 15:25:27', '2023-11-27 15:25:27'),
(411, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-27 15:26:39', '2023-11-27 15:26:39'),
(412, 'Fabrice OGOU', 'Super Admin', 'Tableau de bord', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-11-27 15:44:21', '2023-11-27 15:44:21'),
(413, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-27 15:44:32', '2023-11-27 15:44:32'),
(414, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-27 15:49:49', '2023-11-27 15:49:49'),
(415, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-27 15:58:02', '2023-11-27 15:58:02'),
(416, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-27 15:58:28', '2023-11-27 15:58:28'),
(417, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Rejeter', 'danger', '20231001154444.jpg', '2023-11-27 15:58:43', '2023-11-27 15:58:43'),
(418, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-27 15:59:07', '2023-11-27 15:59:07'),
(419, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2023-11-27 15:59:14', '2023-11-27 15:59:14'),
(420, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-11-27 15:59:26', '2023-11-27 15:59:26'),
(421, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2023-11-27 16:00:01', '2023-11-27 16:00:01'),
(422, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-27 16:00:11', '2023-11-27 16:00:11'),
(423, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-11-27 16:03:57', '2023-11-27 16:03:57'),
(424, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-27 17:15:05', '2023-11-27 17:15:05'),
(425, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-27 17:21:44', '2023-11-27 17:21:44'),
(426, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2023-11-27 19:38:09', '2023-11-27 19:38:09'),
(427, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-11-28 06:41:15', '2023-11-28 06:41:15'),
(428, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-03 19:10:17', '2023-12-03 19:10:17'),
(429, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-04 07:03:07', '2023-12-04 07:03:07'),
(430, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-04 07:20:07', '2023-12-04 07:20:07'),
(431, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-04 07:28:47', '2023-12-04 07:28:47'),
(432, 'Fabrice OGOU', 'Super Admin', ': AZERTY', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-04 07:37:45', '2023-12-04 07:37:45'),
(433, 'Fabrice OGOU', 'Super Admin', ': TAGUET D\'AMARRAGE', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-04 08:07:54', '2023-12-04 08:07:54'),
(434, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-04 08:32:30', '2023-12-04 08:32:30'),
(435, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-04 09:23:47', '2023-12-04 09:23:47'),
(436, 'Fabrice OGOU', 'Super Admin', ': MANCI', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-04 12:18:50', '2023-12-04 12:18:50'),
(437, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-04 12:27:29', '2023-12-04 12:27:29'),
(438, 'Fabrice OGOU', 'Super Admin', ': PANNEAUX AVANT', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-04 12:30:37', '2023-12-04 12:30:37'),
(439, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-04 23:34:14', '2023-12-04 23:34:14'),
(440, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-05 05:43:59', '2023-12-05 05:43:59'),
(441, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-05 10:00:12', '2023-12-05 10:00:12'),
(442, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-05 16:23:29', '2023-12-05 16:23:29'),
(443, 'Fabrice OGOU', 'Super Admin', 'Devis: 0009/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 16:41:05', '2023-12-05 16:41:05'),
(444, 'Fabrice OGOU', 'Super Admin', 'Devis: 0017/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 16:42:32', '2023-12-05 16:42:32'),
(445, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 16:58:56', '2023-12-05 16:58:56'),
(446, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:03:37', '2023-12-05 17:03:37'),
(447, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:04:05', '2023-12-05 17:04:05'),
(448, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:05:31', '2023-12-05 17:05:31'),
(449, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:07:31', '2023-12-05 17:07:31'),
(450, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:08:04', '2023-12-05 17:08:04'),
(451, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:08:44', '2023-12-05 17:08:44'),
(452, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:09:23', '2023-12-05 17:09:23'),
(453, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:10:19', '2023-12-05 17:10:19'),
(454, 'Fabrice OGOU', 'Super Admin', 'Devis: 0015/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 17:16:54', '2023-12-05 17:16:54'),
(455, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-05 20:12:43', '2023-12-05 20:12:43'),
(456, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-05 20:42:32', '2023-12-05 20:42:32'),
(457, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:42:57', '2023-12-05 20:42:57'),
(458, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:43:11', '2023-12-05 20:43:11'),
(459, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:43:25', '2023-12-05 20:43:25'),
(460, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:43:46', '2023-12-05 20:43:46'),
(461, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:44:26', '2023-12-05 20:44:26'),
(462, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:44:39', '2023-12-05 20:44:39'),
(463, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:46:11', '2023-12-05 20:46:11'),
(464, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:46:34', '2023-12-05 20:46:34'),
(465, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:46:44', '2023-12-05 20:46:44'),
(466, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:46:58', '2023-12-05 20:46:58'),
(467, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:47:29', '2023-12-05 20:47:29'),
(468, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-05 20:47:44', '2023-12-05 20:47:44'),
(469, 'Fabrice OGOU', 'Super Admin', 'Devis: 0019/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-05 21:27:15', '2023-12-05 21:27:15'),
(470, 'Fabrice OGOU', 'Super Admin', 'Devis: 0019/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-05 21:45:56', '2023-12-05 21:45:56'),
(471, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-06 09:48:44', '2023-12-06 09:48:44'),
(472, 'Fabrice OGOU', 'Super Admin', 'Devis: 0009/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-06 11:42:29', '2023-12-06 11:42:29'),
(473, 'Fabrice OGOU', 'Super Admin', 'Devis: 0009/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-06 11:51:00', '2023-12-06 11:51:00'),
(474, 'Fabrice OGOU', 'Super Admin', 'Devis: 0009/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-06 11:56:01', '2023-12-06 11:56:01'),
(475, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2023-12-06 12:06:44', '2023-12-06 12:06:44'),
(476, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2023-12-06 12:06:55', '2023-12-06 12:06:55'),
(477, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Refuser', 'danger', '20231001154444.jpg', '2023-12-06 12:07:12', '2023-12-06 12:07:12'),
(478, 'Fabrice OGOU', 'Super Admin', 'Devis: 0009/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-06 12:26:04', '2023-12-06 12:26:04'),
(479, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-06 17:14:53', '2023-12-06 17:14:53'),
(480, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-06 17:17:20', '2023-12-06 17:17:20'),
(481, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-06 17:18:53', '2023-12-06 17:18:53'),
(482, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-06 21:07:38', '2023-12-06 21:07:38'),
(483, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-07 09:55:59', '2023-12-07 09:55:59'),
(484, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 09:58:42', '2023-12-07 09:58:42'),
(485, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-07 12:37:04', '2023-12-07 12:37:04'),
(486, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-12-07 12:45:45', '2023-12-07 12:45:45'),
(487, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-07 13:57:57', '2023-12-07 13:57:57'),
(488, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 13:58:20', '2023-12-07 13:58:20'),
(489, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 13:58:42', '2023-12-07 13:58:42'),
(490, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:01:38', '2023-12-07 14:01:38'),
(491, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:05:11', '2023-12-07 14:05:11'),
(492, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:18:56', '2023-12-07 14:18:56'),
(493, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:20:27', '2023-12-07 14:20:27'),
(494, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:26:43', '2023-12-07 14:26:43'),
(495, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:32:01', '2023-12-07 14:32:01'),
(496, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:32:11', '2023-12-07 14:32:11'),
(497, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:35:08', '2023-12-07 14:35:08'),
(498, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:45:54', '2023-12-07 14:45:54'),
(499, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:48:09', '2023-12-07 14:48:09'),
(500, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:52:09', '2023-12-07 14:52:09'),
(501, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-07 14:53:56', '2023-12-07 14:53:56'),
(502, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-07 14:56:27', '2023-12-07 14:56:27'),
(503, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:57:56', '2023-12-07 14:57:56'),
(504, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:58:12', '2023-12-07 14:58:12'),
(505, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:58:24', '2023-12-07 14:58:24'),
(506, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:58:31', '2023-12-07 14:58:31'),
(507, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 14:58:42', '2023-12-07 14:58:42'),
(508, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 15:03:06', '2023-12-07 15:03:06'),
(509, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 15:15:47', '2023-12-07 15:15:47'),
(510, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 15:18:34', '2023-12-07 15:18:34'),
(511, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 15:22:00', '2023-12-07 15:22:00'),
(512, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 15:24:20', '2023-12-07 15:24:20'),
(513, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 15:56:41', '2023-12-07 15:56:41'),
(514, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:00:43', '2023-12-07 16:00:43'),
(515, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:02:24', '2023-12-07 16:02:24'),
(516, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:08:48', '2023-12-07 16:08:48'),
(517, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:25:43', '2023-12-07 16:25:43'),
(518, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:31:37', '2023-12-07 16:31:37'),
(519, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:32:51', '2023-12-07 16:32:51'),
(520, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:33:16', '2023-12-07 16:33:16'),
(521, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:34:03', '2023-12-07 16:34:03'),
(522, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:34:48', '2023-12-07 16:34:48'),
(523, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:35:18', '2023-12-07 16:35:18'),
(524, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:36:17', '2023-12-07 16:36:17'),
(525, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 16:36:43', '2023-12-07 16:36:43'),
(526, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:23:19', '2023-12-07 17:23:19'),
(527, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:28:15', '2023-12-07 17:28:15'),
(528, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:28:43', '2023-12-07 17:28:43'),
(529, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:29:08', '2023-12-07 17:29:08'),
(530, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:30:14', '2023-12-07 17:30:14'),
(531, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:31:42', '2023-12-07 17:31:42'),
(532, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:31:50', '2023-12-07 17:31:50'),
(533, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:31:56', '2023-12-07 17:31:56'),
(534, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:43:03', '2023-12-07 17:43:03'),
(535, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:43:48', '2023-12-07 17:43:48'),
(536, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-07 17:43:52', '2023-12-07 17:43:52'),
(537, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-08 10:41:50', '2023-12-08 10:41:50'),
(538, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-10 08:40:13', '2023-12-10 08:40:13'),
(539, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-11 09:43:09', '2023-12-11 09:43:09'),
(540, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-11 13:53:09', '2023-12-11 13:53:09'),
(541, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-11 14:25:34', '2023-12-11 14:25:34'),
(542, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-11 14:33:25', '2023-12-11 14:33:25'),
(543, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-11 14:39:18', '2023-12-11 14:39:18'),
(544, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 16:03:16', '2023-12-11 16:03:16'),
(545, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 16:10:18', '2023-12-11 16:10:18'),
(546, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 16:49:47', '2023-12-11 16:49:47'),
(547, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 17:34:06', '2023-12-11 17:34:06'),
(548, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 19:29:09', '2023-12-11 19:29:09'),
(549, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 19:38:49', '2023-12-11 19:38:49'),
(550, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 20:59:45', '2023-12-11 20:59:45'),
(551, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-11 21:08:26', '2023-12-11 21:08:26'),
(552, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-12 09:41:38', '2023-12-12 09:41:38'),
(553, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-12 09:42:57', '2023-12-12 09:42:57'),
(554, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 09:46:14', '2023-12-12 09:46:14'),
(555, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-12 10:00:41', '2023-12-12 10:00:41'),
(556, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:03:28', '2023-12-12 10:03:28'),
(557, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:11:38', '2023-12-12 10:11:38'),
(558, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:13:56', '2023-12-12 10:13:56'),
(559, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:15:03', '2023-12-12 10:15:03'),
(560, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:37:46', '2023-12-12 10:37:46'),
(561, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-12 10:42:02', '2023-12-12 10:42:02'),
(562, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:50:32', '2023-12-12 10:50:32'),
(563, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:52:25', '2023-12-12 10:52:25'),
(564, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 10:58:34', '2023-12-12 10:58:34'),
(565, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-12 11:14:21', '2023-12-12 11:14:21'),
(566, 'Fabrice OGOU', 'Super Admin', 'Tableau de bord', 'Deconnecter', 'primary', '20231001154444.jpg', '2023-12-12 11:56:28', '2023-12-12 11:56:28'),
(567, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-14 06:33:24', '2023-12-14 06:33:24'),
(568, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/23', 'Ajouter', 'success', '20231001154444.jpg', '2023-12-14 06:35:07', '2023-12-14 06:35:07'),
(569, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/23', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-14 06:36:37', '2023-12-14 06:36:37'),
(570, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2023-12-14 11:59:37', '2023-12-14 11:59:37'),
(571, 'Fabrice OGOU', 'Super Admin', 'Profil: Administrateur', 'Modifier', 'warning', '20231001154444.jpg', '2023-12-14 12:00:11', '2023-12-14 12:00:11'),
(572, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-02-20 22:10:31', '2024-02-20 22:10:31'),
(573, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-02-28 16:12:58', '2024-02-28 16:12:58'),
(574, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-08 21:00:28', '2024-03-08 21:00:28'),
(575, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-03-08 21:16:28', '2024-03-08 21:16:28'),
(576, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2024-03-08 21:33:35', '2024-03-08 21:33:35'),
(577, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-03-08 21:33:47', '2024-03-08 21:33:47'),
(578, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-11 13:55:18', '2024-03-11 13:55:18'),
(579, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-18 12:34:54', '2024-03-18 12:34:54'),
(580, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-19 20:30:09', '2024-03-19 20:30:09'),
(581, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-20 00:15:01', '2024-03-20 00:15:01'),
(582, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-20 10:10:07', '2024-03-20 10:10:07'),
(583, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Ajouter', 'success', '20231001154444.jpg', '2024-03-20 10:11:43', '2024-03-20 10:11:43'),
(584, 'Fabrice OGOU', 'Super Admin', 'Client', 'Désactiver', 'danger', '20231001154444.jpg', '2024-03-20 10:28:35', '2024-03-20 10:28:35'),
(585, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-03-20 10:45:55', '2024-03-20 10:45:55'),
(586, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2024-03-20 10:46:08', '2024-03-20 10:46:08'),
(587, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-03-20 10:46:16', '2024-03-20 10:46:16'),
(588, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-20 15:44:20', '2024-03-20 15:44:20'),
(589, 'Fabrice OGOU', 'Super Admin', 'Horaire: Professeur', 'Ajouter', 'success', '20231001154444.jpg', '2024-03-20 15:46:08', '2024-03-20 15:46:08'),
(590, 'Fabrice OGOU', 'Super Admin', 'Type (Fourniture): Bureau', 'Ajouter', 'success', '20231001154444.jpg', '2024-03-20 15:47:12', '2024-03-20 15:47:12'),
(591, 'Fabrice OGOU', 'Super Admin', 'Type (fourniture)', 'Activer', 'success', '20231001154444.jpg', '2024-03-20 15:47:24', '2024-03-20 15:47:24'),
(592, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture): Bloc de note', 'Ajouter', 'success', '20231001154444.jpg', '2024-03-20 15:47:54', '2024-03-20 15:47:54'),
(593, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2024-03-20 15:48:04', '2024-03-20 15:48:04'),
(594, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture): Papier', 'Ajouter', 'success', '20231001154444.jpg', '2024-03-20 15:48:23', '2024-03-20 15:48:23'),
(595, 'Fabrice OGOU', 'Super Admin', 'Client', 'Activer', 'success', '20231001154444.jpg', '2024-03-20 15:49:48', '2024-03-20 15:49:48'),
(596, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-03-20 15:56:59', '2024-03-20 15:56:59'),
(597, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-03-20 15:59:48', '2024-03-20 15:59:48'),
(598, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-03-20 16:05:45', '2024-03-20 16:05:45'),
(599, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-03-20 16:06:39', '2024-03-20 16:06:39'),
(600, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2024-03-20 16:07:06', '2024-03-20 16:07:06'),
(601, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-03-20 16:07:20', '2024-03-20 16:07:20'),
(602, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-03-20 16:10:16', '2024-03-20 16:10:16'),
(603, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-28 22:21:46', '2024-03-28 22:21:46'),
(604, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-03-30 01:53:13', '2024-03-30 01:53:13'),
(605, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-02 18:35:52', '2024-04-02 18:35:52'),
(606, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-04 00:43:27', '2024-04-04 00:43:27'),
(607, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-04 01:05:20', '2024-04-04 01:05:20'),
(608, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-04 01:39:28', '2024-04-04 01:39:28'),
(609, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-04 17:08:22', '2024-04-04 17:08:22'),
(610, 'Fabrice OGOU', 'Super Admin', 'Profil', 'Désactiver', 'danger', '20231001154444.jpg', '2024-04-04 18:11:39', '2024-04-04 18:11:39'),
(611, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-04 18:12:41', '2024-04-04 18:12:41'),
(612, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-04 18:45:58', '2024-04-04 18:45:58'),
(613, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Deconnecter', 'primary', '20231001154444.jpg', '2024-04-04 18:46:14', '2024-04-04 18:46:14'),
(614, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-04 18:46:19', '2024-04-04 18:46:19'),
(615, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-04 19:14:00', '2024-04-04 19:14:00'),
(616, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-04 19:23:13', '2024-04-04 19:23:13'),
(617, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-04 19:27:45', '2024-04-04 19:27:45'),
(618, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-05 00:29:08', '2024-04-05 00:29:08'),
(619, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-06 00:29:20', '2024-04-06 00:29:20'),
(620, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-06 06:17:25', '2024-04-06 06:17:25'),
(621, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-06 06:47:41', '2024-04-06 06:47:41'),
(622, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-06 06:48:14', '2024-04-06 06:48:14'),
(623, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-06 06:48:41', '2024-04-06 06:48:41'),
(624, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-10 09:39:12', '2024-04-10 09:39:12'),
(625, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-10 18:34:36', '2024-04-10 18:34:36'),
(626, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-11 18:46:27', '2024-04-11 18:46:27'),
(627, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-11 18:48:14', '2024-04-11 18:48:14'),
(628, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-12 08:56:34', '2024-04-12 08:56:34'),
(629, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-12 08:59:34', '2024-04-12 08:59:34'),
(630, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-13 17:44:59', '2024-04-13 17:44:59'),
(631, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-13 21:44:25', '2024-04-13 21:44:25'),
(632, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-14 06:35:12', '2024-04-14 06:35:12'),
(633, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): Stylo', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-14 06:40:54', '2024-04-14 06:40:54'),
(634, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): Chaise', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-14 07:01:33', '2024-04-14 07:01:33'),
(635, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-14 07:01:42', '2024-04-14 07:01:42'),
(636, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-14 07:02:05', '2024-04-14 07:02:05'),
(637, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): Stylo', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-14 08:27:02', '2024-04-14 08:27:02'),
(638, 'Fabrice OGOU', 'Super Admin', 'Fourniture', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-14 08:28:08', '2024-04-14 08:28:08'),
(639, 'Fabrice OGOU', 'Super Admin', 'Fourniture', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-14 08:28:58', '2024-04-14 08:28:58'),
(640, 'Fabrice OGOU', 'Super Admin', 'Matière (fourniture)', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-14 08:29:12', '2024-04-14 08:29:12'),
(641, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-14 08:41:12', '2024-04-14 08:41:12'),
(642, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Deconnecter', 'primary', '20231001154444.jpg', '2024-04-14 08:41:36', '2024-04-14 08:41:36'),
(643, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-14 08:41:41', '2024-04-14 08:41:41'),
(644, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-04-14 08:44:05', '2024-04-14 08:44:05'),
(645, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-15 07:45:40', '2024-04-15 07:45:40'),
(646, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-15 07:46:12', '2024-04-15 07:46:12'),
(647, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-15 08:14:58', '2024-04-15 08:14:58'),
(648, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-15 09:00:37', '2024-04-15 09:00:37'),
(649, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-15 09:10:24', '2024-04-15 09:10:24'),
(650, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 09:11:52', '2024-04-15 09:11:52'),
(651, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-15 09:12:48', '2024-04-15 09:12:48'),
(652, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-15 09:16:20', '2024-04-15 09:16:20'),
(653, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-15 09:20:02', '2024-04-15 09:20:02'),
(654, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 09:22:12', '2024-04-15 09:22:12'),
(655, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 09:23:44', '2024-04-15 09:23:44'),
(656, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 09:26:02', '2024-04-15 09:26:02'),
(657, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-15 19:05:17', '2024-04-15 19:05:17'),
(658, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-15 19:07:18', '2024-04-15 19:07:18'),
(659, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 19:08:40', '2024-04-15 19:08:40'),
(660, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 19:27:12', '2024-04-15 19:27:12'),
(661, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 19:28:08', '2024-04-15 19:28:08'),
(662, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 19:32:09', '2024-04-15 19:32:09'),
(663, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-15 19:58:53', '2024-04-15 19:58:53'),
(664, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-16 05:34:22', '2024-04-16 05:34:22'),
(665, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 05:38:39', '2024-04-16 05:38:39'),
(666, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 05:56:16', '2024-04-16 05:56:16'),
(667, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 05:57:39', '2024-04-16 05:57:39'),
(668, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 07:31:10', '2024-04-16 07:31:10'),
(669, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 07:34:38', '2024-04-16 07:34:38'),
(670, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 07:36:48', '2024-04-16 07:36:48'),
(671, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 07:40:52', '2024-04-16 07:40:52'),
(672, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 07:49:36', '2024-04-16 07:49:36'),
(673, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:00:02', '2024-04-16 08:00:02'),
(674, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:12:31', '2024-04-16 08:12:31'),
(675, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:17:53', '2024-04-16 08:17:53'),
(676, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:19:44', '2024-04-16 08:19:44'),
(677, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:25:24', '2024-04-16 08:25:24'),
(678, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:31:55', '2024-04-16 08:31:55'),
(679, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:36:16', '2024-04-16 08:36:16'),
(680, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:41:11', '2024-04-16 08:41:11'),
(681, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:48:03', '2024-04-16 08:48:03'),
(682, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 08:52:58', '2024-04-16 08:52:58'),
(683, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 09:00:23', '2024-04-16 09:00:23'),
(684, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 09:04:25', '2024-04-16 09:04:25'),
(685, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-04-16 09:13:55', '2024-04-16 09:13:55'),
(686, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2024-04-16 09:14:05', '2024-04-16 09:14:05'),
(687, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-16 09:14:13', '2024-04-16 09:14:13'),
(688, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-16 09:20:02', '2024-04-16 09:20:02');
INSERT INTO `logs` (`id`, `username`, `profil`, `libelle`, `action`, `color`, `avatar`, `created_at`, `updated_at`) VALUES
(689, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-16 09:25:39', '2024-04-16 09:25:39'),
(690, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-16 09:27:03', '2024-04-16 09:27:03'),
(691, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-16 09:30:03', '2024-04-16 09:30:03'),
(692, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-16 09:55:25', '2024-04-16 09:55:25'),
(693, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-16 09:56:23', '2024-04-16 09:56:23'),
(694, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-16 09:58:54', '2024-04-16 09:58:54'),
(695, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-16 10:02:43', '2024-04-16 10:02:43'),
(696, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-16 10:03:25', '2024-04-16 10:03:25'),
(697, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-16 10:03:52', '2024-04-16 10:03:52'),
(698, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Supprimer', 'danger', '20231001154444.jpg', '2024-04-16 10:04:06', '2024-04-16 10:04:06'),
(699, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-04-16 10:06:09', '2024-04-16 10:06:09'),
(700, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-16 18:30:22', '2024-04-16 18:30:22'),
(701, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 18:33:29', '2024-04-16 18:33:29'),
(702, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-16 18:34:34', '2024-04-16 18:34:34'),
(703, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-17 07:16:32', '2024-04-17 07:16:32'),
(704, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-17 07:41:30', '2024-04-17 07:41:30'),
(705, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-17 07:42:23', '2024-04-17 07:42:23'),
(706, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-17 08:21:52', '2024-04-17 08:21:52'),
(707, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-17 08:24:40', '2024-04-17 08:24:40'),
(708, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-28 16:31:05', '2024-04-28 16:31:05'),
(709, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-28 18:04:50', '2024-04-28 18:04:50'),
(710, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-04-28 18:37:34', '2024-04-28 18:37:34'),
(711, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2024-04-28 18:37:41', '2024-04-28 18:37:41'),
(712, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-28 18:37:47', '2024-04-28 18:37:47'),
(713, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-04-28 19:17:26', '2024-04-28 19:17:26'),
(714, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2024-04-28 19:17:35', '2024-04-28 19:17:35'),
(715, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-28 19:17:42', '2024-04-28 19:17:42'),
(716, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-04-28 23:26:30', '2024-04-28 23:26:30'),
(717, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-04-28 23:27:01', '2024-04-28 23:27:01'),
(718, 'Fabrice OGOU', 'Super Admin', 'Devis: 0002/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-04-28 23:43:17', '2024-04-28 23:43:17'),
(719, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Transmettre', 'success', '20231001154444.jpg', '2024-04-28 23:44:59', '2024-04-28 23:44:59'),
(720, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-18 13:10:56', '2024-05-18 13:10:56'),
(721, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-18 13:12:43', '2024-05-18 13:12:43'),
(722, 'Fabrice OGOU', 'Super Admin', 'Tableau de bord', 'Deconnecter', 'primary', '20231001154444.jpg', '2024-05-18 13:15:03', '2024-05-18 13:15:03'),
(723, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-18 13:15:24', '2024-05-18 13:15:24'),
(724, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-18 13:16:01', '2024-05-18 13:16:01'),
(725, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-19 10:48:55', '2024-05-19 10:48:55'),
(726, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-19 10:53:19', '2024-05-19 10:53:19'),
(727, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-19 10:54:06', '2024-05-19 10:54:06'),
(728, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-19 11:05:00', '2024-05-19 11:05:00'),
(729, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-21 02:10:23', '2024-05-21 02:10:23'),
(730, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-22 11:46:08', '2024-05-22 11:46:08'),
(731, 'Fabrice OGOU', 'Super Admin', 'Tableau de bord', 'Deconnecter', 'primary', '20231001154444.jpg', '2024-05-22 11:46:14', '2024-05-22 11:46:14'),
(732, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-05-22 12:19:48', '2024-05-22 12:19:48'),
(733, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-08 15:11:26', '2024-07-08 15:11:26'),
(734, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-08 15:16:46', '2024-07-08 15:16:46'),
(735, 'Fabrice OGOU', 'Super Admin', 'Matière (Fourniture): Fabrice', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-08 16:06:52', '2024-07-08 16:06:52'),
(736, 'Fabrice OGOU', 'Super Admin', 'Client: FABRICE', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-08 16:10:50', '2024-07-08 16:10:50'),
(737, 'Fabrice OGOU', 'Super Admin', 'Clients', 'Deconnecter', 'primary', '20231001154444.jpg', '2024-07-08 16:14:02', '2024-07-08 16:14:02'),
(738, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-08 16:14:09', '2024-07-08 16:14:09'),
(739, 'Fabrice OGOU', 'Super Admin', 'Client: FABRICE', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-08 16:20:12', '2024-07-08 16:20:12'),
(740, 'Fabrice OGOU', 'Super Admin', 'Client', 'Désactiver', 'danger', '20231001154444.jpg', '2024-07-08 16:20:20', '2024-07-08 16:20:20'),
(741, 'Fabrice OGOU', 'Super Admin', 'Client: FABRICE TEST', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-08 16:20:35', '2024-07-08 16:20:35'),
(742, 'Fabrice OGOU', 'Super Admin', 'Client', 'Activer', 'success', '20231001154444.jpg', '2024-07-08 16:20:41', '2024-07-08 16:20:41'),
(743, 'Fabrice OGOU', 'Super Admin', 'Client', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 16:20:48', '2024-07-08 16:20:48'),
(744, 'Fabrice OGOU', 'Super Admin', 'Adresse Facturaction', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 17:02:51', '2024-07-08 17:02:51'),
(745, 'Fabrice OGOU', 'Super Admin', 'Horaire', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 18:38:41', '2024-07-08 18:38:41'),
(746, 'Fabrice OGOU', 'Super Admin', 'Quantité', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 19:22:06', '2024-07-08 19:22:06'),
(747, 'Fabrice OGOU', 'Super Admin', 'Fourniture', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 19:32:26', '2024-07-08 19:32:26'),
(748, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture)', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 19:37:56', '2024-07-08 19:37:56'),
(749, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture)', 'Activer', 'success', '20231001154444.jpg', '2024-07-08 19:39:13', '2024-07-08 19:39:13'),
(750, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture): Ancre', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-08 19:39:31', '2024-07-08 19:39:31'),
(751, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture)', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 19:39:41', '2024-07-08 19:39:41'),
(752, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture): Ancre', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-08 19:40:06', '2024-07-08 19:40:06'),
(753, 'Fabrice OGOU', 'Super Admin', 'Nom (Fourniture)', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-08 19:40:13', '2024-07-08 19:40:13'),
(754, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-09 12:09:23', '2024-07-09 12:09:23'),
(755, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-09 17:52:34', '2024-07-09 17:52:34'),
(756, 'Fabrice OGOU', 'Super Admin', 'Transport: Transport Midi', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-09 17:55:33', '2024-07-09 17:55:33'),
(757, 'Fabrice OGOU', 'Super Admin', 'Transport', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-09 17:55:44', '2024-07-09 17:55:44'),
(758, 'Fabrice OGOU', 'Super Admin', 'Matière', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-09 17:56:34', '2024-07-09 17:56:34'),
(759, 'Fabrice OGOU', 'Super Admin', 'Qualification (Fourniture): Azerty45', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-09 17:58:12', '2024-07-09 17:58:12'),
(760, 'Fabrice OGOU', 'Super Admin', 'Qualification', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-09 17:58:21', '2024-07-09 17:58:21'),
(761, 'Fabrice OGOU', 'Super Admin', 'Type (Fourniture): Fabrice', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-09 18:02:58', '2024-07-09 18:02:58'),
(762, 'Fabrice OGOU', 'Super Admin', 'Type (fourniture)', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-09 18:03:27', '2024-07-09 18:03:27'),
(763, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-10 13:17:22', '2024-07-10 13:17:22'),
(764, 'Fabrice OGOU', 'Super Admin', 'Navire: ALBONICA', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-10 13:43:04', '2024-07-10 13:43:04'),
(765, 'Fabrice OGOU', 'Super Admin', 'Navire: ALBONICA SA', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-10 13:45:35', '2024-07-10 13:45:35'),
(766, 'Fabrice OGOU', 'Super Admin', 'Navire: ZEBEROA', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-10 13:46:01', '2024-07-10 13:46:01'),
(767, 'Fabrice OGOU', 'Super Admin', 'Navire: ALBONICA SA', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-10 13:46:29', '2024-07-10 13:46:29'),
(768, 'Fabrice OGOU', 'Super Admin', 'Navire', 'Supprimer', 'danger', '20231001154444.jpg', '2024-07-10 13:46:42', '2024-07-10 13:46:42'),
(769, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-10 18:24:12', '2024-07-10 18:24:12'),
(770, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-11 20:24:33', '2024-07-11 20:24:33'),
(771, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-11 20:25:34', '2024-07-11 20:25:34'),
(772, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-11 20:31:48', '2024-07-11 20:31:48'),
(773, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-16 03:06:27', '2024-07-16 03:06:27'),
(774, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-16 17:40:04', '2024-07-16 17:40:04'),
(775, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-17 02:19:28', '2024-07-17 02:19:28'),
(776, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-17 11:18:25', '2024-07-17 11:18:25'),
(777, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-17 13:15:20', '2024-07-17 13:15:20'),
(778, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 13:16:55', '2024-07-17 13:16:55'),
(779, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-17 15:42:14', '2024-07-17 15:42:14'),
(780, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 15:45:31', '2024-07-17 15:45:31'),
(781, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 15:47:09', '2024-07-17 15:47:09'),
(782, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 16:17:36', '2024-07-17 16:17:36'),
(783, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 16:21:03', '2024-07-17 16:21:03'),
(784, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 16:27:48', '2024-07-17 16:27:48'),
(785, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 17:09:49', '2024-07-17 17:09:49'),
(786, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 17:13:24', '2024-07-17 17:13:24'),
(787, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 17:14:15', '2024-07-17 17:14:15'),
(788, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 18:08:41', '2024-07-17 18:08:41'),
(789, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 18:15:03', '2024-07-17 18:15:03'),
(790, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 18:17:08', '2024-07-17 18:17:08'),
(791, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 18:20:05', '2024-07-17 18:20:05'),
(792, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-17 18:32:20', '2024-07-17 18:32:20'),
(793, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 18:37:10', '2024-07-17 18:37:10'),
(794, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-17 18:38:53', '2024-07-17 18:38:53'),
(795, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-18 17:11:27', '2024-07-18 17:11:27'),
(796, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-18 18:11:01', '2024-07-18 18:11:01'),
(797, 'Fabrice OGOU', 'Super Admin', 'Désignation (Fourniture)', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 18:11:15', '2024-07-18 18:11:15'),
(798, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:05:31', '2024-07-18 19:05:31'),
(799, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:10:16', '2024-07-18 19:10:16'),
(800, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:13:39', '2024-07-18 19:13:39'),
(801, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:18:30', '2024-07-18 19:18:30'),
(802, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:19:01', '2024-07-18 19:19:01'),
(803, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:26:19', '2024-07-18 19:26:19'),
(804, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:27:01', '2024-07-18 19:27:01'),
(805, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 19:30:29', '2024-07-18 19:30:29'),
(806, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Ajouter', 'success', '20231001154444.jpg', '2024-07-18 21:19:10', '2024-07-18 21:19:10'),
(807, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:24:42', '2024-07-18 21:24:42'),
(808, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:27:14', '2024-07-18 21:27:14'),
(809, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:35:05', '2024-07-18 21:35:05'),
(810, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:37:08', '2024-07-18 21:37:08'),
(811, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:38:12', '2024-07-18 21:38:12'),
(812, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:40:17', '2024-07-18 21:40:17'),
(813, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:52:43', '2024-07-18 21:52:43'),
(814, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 21:52:56', '2024-07-18 21:52:56'),
(815, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:26:04', '2024-07-18 22:26:04'),
(816, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:35:46', '2024-07-18 22:35:46'),
(817, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:38:00', '2024-07-18 22:38:00'),
(818, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:39:17', '2024-07-18 22:39:17'),
(819, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:41:11', '2024-07-18 22:41:11'),
(820, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:42:12', '2024-07-18 22:42:12'),
(821, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:43:44', '2024-07-18 22:43:44'),
(822, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:45:25', '2024-07-18 22:45:25'),
(823, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:46:30', '2024-07-18 22:46:30'),
(824, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:49:33', '2024-07-18 22:49:33'),
(825, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-18 22:52:40', '2024-07-18 22:52:40'),
(826, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-20 00:49:39', '2024-07-20 00:49:39'),
(827, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 01:53:47', '2024-07-20 01:53:47'),
(828, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 01:59:53', '2024-07-20 01:59:53'),
(829, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 02:04:25', '2024-07-20 02:04:25'),
(830, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 02:06:35', '2024-07-20 02:06:35'),
(831, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 02:12:22', '2024-07-20 02:12:22'),
(832, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 02:14:19', '2024-07-20 02:14:19'),
(833, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 02:20:27', '2024-07-20 02:20:27'),
(834, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-20 02:29:14', '2024-07-20 02:29:14'),
(835, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-22 17:29:57', '2024-07-22 17:29:57'),
(836, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-23 17:59:23', '2024-07-23 17:59:23'),
(837, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-24 00:28:58', '2024-07-24 00:28:58'),
(838, 'Fabrice OGOU', 'Super Admin', 'Profil: Super Admin', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-24 00:29:49', '2024-07-24 00:29:49'),
(839, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-24 22:53:25', '2024-07-24 22:53:25'),
(840, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-24 23:04:17', '2024-07-24 23:04:17'),
(841, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:15:42', '2024-07-25 01:15:42'),
(842, 'Fabrice OGOU', 'Super Admin', 'Devis: 0005/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:19:06', '2024-07-25 01:19:06'),
(843, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:27:00', '2024-07-25 01:27:00'),
(844, 'Fabrice OGOU', 'Super Admin', 'Devis: 0004/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:31:39', '2024-07-25 01:31:39'),
(845, 'Fabrice OGOU', 'Super Admin', 'Devis: 0003/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:34:21', '2024-07-25 01:34:21'),
(846, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:42:00', '2024-07-25 01:42:00'),
(847, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:43:34', '2024-07-25 01:43:34'),
(848, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:47:01', '2024-07-25 01:47:01'),
(849, 'Fabrice OGOU', 'Super Admin', 'Header: Pied de page de MANCI', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:55:46', '2024-07-25 01:55:46'),
(850, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 01:57:08', '2024-07-25 01:57:08'),
(851, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:15:43', '2024-07-25 02:15:43'),
(852, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:17:33', '2024-07-25 02:17:33'),
(853, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:20:25', '2024-07-25 02:20:25'),
(854, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:25:47', '2024-07-25 02:25:47'),
(855, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:36:26', '2024-07-25 02:36:26'),
(856, 'Fabrice OGOU', 'Super Admin', 'Devis: 0006/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:41:26', '2024-07-25 02:41:26'),
(857, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:42:34', '2024-07-25 02:42:34'),
(858, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:45:13', '2024-07-25 02:45:13'),
(859, 'Fabrice OGOU', 'Super Admin', 'Devis: 0007/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:49:54', '2024-07-25 02:49:54'),
(860, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:52:08', '2024-07-25 02:52:08'),
(861, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:54:04', '2024-07-25 02:54:04'),
(862, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 02:55:53', '2024-07-25 02:55:53'),
(863, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 03:06:59', '2024-07-25 03:06:59'),
(864, 'Fabrice OGOU', 'Super Admin', 'Devis: 0001/24', 'Modifier', 'warning', '20231001154444.jpg', '2024-07-25 03:17:13', '2024-07-25 03:17:13'),
(865, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-07-25 08:56:05', '2024-07-25 08:56:05'),
(866, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Approuver', 'success', '20231001154444.jpg', '2024-07-25 09:01:48', '2024-07-25 09:01:48'),
(867, 'Fabrice OGOU', 'Super Admin', 'Devis', 'Valider', 'success', '20231001154444.jpg', '2024-07-25 09:01:55', '2024-07-25 09:01:55'),
(868, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-12-16 12:02:55', '2024-12-16 12:02:55');

-- --------------------------------------------------------

--
-- Structure de la table `materials`
--

DROP TABLE IF EXISTS `materials`;
CREATE TABLE IF NOT EXISTS `materials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `materials`
--

INSERT INTO `materials` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'acier', '1', '2023-11-21 21:43:58', '2023-11-23 19:16:03', 1),
(2, 'inox', '1', '2023-11-21 21:44:20', '2023-11-23 19:15:57', 1),
(3, 'API SCH40', '1', '2023-11-21 21:44:39', '2023-11-23 19:15:28', 1),
(4, 'API SCH80', '1', '2023-11-21 21:44:49', '2023-11-21 22:24:28', 1),
(5, 'API SCH100', '1', '2023-11-21 21:45:06', '2023-11-21 22:24:15', 1),
(6, 'Hydraulique', '1', '2023-11-21 21:45:21', '2023-11-21 22:23:57', 1);

-- --------------------------------------------------------

--
-- Structure de la table `messageries`
--

DROP TABLE IF EXISTS `messageries`;
CREATE TABLE IF NOT EXISTS `messageries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(255) NOT NULL,
  `port` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `sender` varchar(150) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `messageries`
--

INSERT INTO `messageries` (`id`, `host`, `port`, `user`, `password`, `sender`, `updated_at`) VALUES
(1, '173.249.8.9', '465', 'rhsoft@jacquescyrille.net', 'SU95Jo+zI+5', 'MANCI', '2023-09-19 19:52:16');

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2024_07_09_190000_truncate_ships_table', 1),
(2, '2024_07_09_000000_delete_colum_ships_table', 2),
(3, '2024_07_09_000000_add_colum_ships_table', 3),
(4, '2024_07_09_000000_add_colum_devis_table', 4),
(5, '2024_07_09_000000_add_colum_supplies_table', 5),
(13, '2024_07_09_000000_create_headers_table', 7),
(12, '2024_07_09_000000_drop_headers_table', 6);

-- --------------------------------------------------------

--
-- Structure de la table `pages`
--

DROP TABLE IF EXISTS `pages`;
CREATE TABLE IF NOT EXISTS `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `fichier` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `position` tinyint(2) NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `pages`
--

INSERT INTO `pages` (`id`, `libelle`, `fichier`, `position`, `status`) VALUES
(1, 'Mon Compte', 'account', 18, '1'),
(2, 'Mot de passe', 'password', 19, '1'),
(3, 'Utilisateurs', 'users', 20, '1'),
(4, 'Profils', 'profils', 21, '1'),
(5, 'Pistes d\'audit', 'logs', 22, '1'),
(6, 'Tableau de bord', 'dashboard/0', 1, '1'),
(7, 'Clients', 'clients', 4, '1'),
(8, 'Navires', 'navires', 5, '1'),
(9, 'Inspecteurs', 'inspectors', 6, '1'),
(10, 'Adresse Facturaction', 'billaddress', 7, '1'),
(11, 'Type Devis', 'devistyp', 8, '1'),
(12, 'Type (Fourniture)', 'suppltyp', 10, '1'),
(13, 'Horaires', 'schedules', 9, '1'),
(14, 'Libellé (Fourniture)', 'suppllib', 11, '1'),
(15, 'Transports', 'transport', 15, '1'),
(16, 'Quantités', 'quantity', 16, '1'),
(17, 'En-têtes', 'headers', 17, '1'),
(18, 'Devis', 'devis', 3, '1'),
(19, 'Factures', 'billings', 2, '1'),
(20, 'Matière (Fourniture)', 'materials', 12, '1'),
(21, 'Diamètre (Fourniture)', 'diameters', 13, '1'),
(22, 'Désignation (Fourniture)', 'supplies', 14, '1');

-- --------------------------------------------------------

--
-- Structure de la table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `profils`
--

DROP TABLE IF EXISTS `profils`;
CREATE TABLE IF NOT EXISTS `profils` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `profils`
--

INSERT INTO `profils` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'Super Admin', 1, '2017-07-31 10:25:40', '2023-09-23 20:36:11', 0),
(2, 'Administrateur', 0, '2023-09-29 12:35:18', '2024-04-04 18:11:39', 0),
(3, 'COMMERCIAL', 1, '2023-10-05 12:41:58', '2023-10-05 12:42:09', 2);

-- --------------------------------------------------------

--
-- Structure de la table `proforma`
--

DROP TABLE IF EXISTS `proforma`;
CREATE TABLE IF NOT EXISTS `proforma` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `total` float NOT NULL,
  `mt_rem` int(11) NOT NULL,
  `see_rem` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `see_price` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
  `alias` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `devttr_id` int(11) NOT NULL,
  `devtyp_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `proforma`
--

INSERT INTO `proforma` (`id`, `total`, `mt_rem`, `see_rem`, `see_price`, `alias`, `created_at`, `updated_at`, `devttr_id`, `devtyp_id`) VALUES
(1, 400000, 0, '0', '0', '1', '2024-04-15 19:07:18', '2024-07-25 02:55:53', 1, 1),
(2, 265500, 0, '0', '1', '1', '2024-04-15 19:08:40', '2024-07-25 03:17:13', 1, 2),
(3, 230500, 0, '0', '0', '1', '2024-04-15 19:27:12', '2024-07-25 03:06:59', 2, 1),
(4, 89000, 0, '0', '1', '1', '2024-04-15 19:58:53', '2024-04-16 08:31:55', 2, 2),
(5, 805000, 0, '0', '1', '1', '2024-04-16 05:57:39', '2024-04-16 08:48:03', 3, 3),
(6, 216600, 0, '1', '0', '1', '2024-04-16 07:31:10', '2024-07-18 19:10:16', 3, 1),
(7, 239500, 0, '0', '1', '1', '2024-04-16 07:34:38', '2024-04-16 08:25:24', 3, 2),
(8, 245000, 0, '0', '1', '1', '2024-04-16 07:36:48', '2024-04-16 07:49:36', 1, 3),
(9, 282500, 0, '0', '0', '1', '2024-04-16 08:12:31', '2024-07-18 19:18:30', 4, 1),
(10, 102500, 0, '0', '1', '1', '2024-04-16 08:17:53', '2024-04-16 08:52:58', 4, 2),
(11, 245000, 0, '0', '1', '1', '2024-04-16 08:19:44', '2024-04-16 08:19:44', 2, 3),
(12, 245000, 0, '0', '1', '1', '2024-04-16 09:00:23', '2024-04-16 09:00:23', 4, 3),
(13, 264500, 0, '0', '0', '1', '2024-04-16 09:04:25', '2024-04-17 07:42:23', 5, 1),
(19, 35000, 0, '0', '1', '1', '2024-04-16 10:06:09', '2024-04-16 10:06:09', 11, 2),
(20, 206500, 0, '0', '0', '1', '2024-04-16 18:33:29', '2024-04-28 23:43:17', 11, 1),
(21, 150000, 0, '1', '1', '1', '2024-04-17 07:41:30', '2024-07-20 01:53:47', 5, 2),
(22, 245000, 0, '0', '1', '1', '2024-04-17 08:21:52', '2024-04-17 08:21:52', 12, 3),
(23, 525000, 0, '0', '1', '1', '2024-04-17 08:24:40', '2024-07-18 19:26:19', 13, 3),
(24, 95000, 0, '0', '0', '1', '2024-07-10 18:24:12', '2024-07-18 19:05:31', 14, 1),
(25, 142500, 0, '0', '1', '1', '2024-07-11 20:25:34', '2024-07-11 20:25:34', 14, 2),
(26, 187500, 0, '0', '1', '1', '2024-07-11 20:31:48', '2024-07-11 20:31:48', 15, 1),
(27, 151000, 0, '0', '0', '1', '2024-07-17 13:15:20', '2024-07-17 18:15:03', 16, 1),
(28, 101500, 0, '0', '1', '1', '2024-07-17 13:16:55', '2024-07-25 01:31:39', 16, 2),
(29, 109500, 0, '0', '0', '1', '2024-07-17 15:42:14', '2024-07-17 18:08:41', 17, 1),
(30, 225000, 0, '0', '1', '1', '2024-07-17 15:45:31', '2024-07-17 15:45:31', 17, 2),
(31, 354000, 0, '0', '0', '1', '2024-07-17 15:47:09', '2024-07-17 17:14:15', 18, 1),
(32, 179500, 0, '0', '0', '1', '2024-07-17 16:17:36', '2024-07-17 18:17:08', 19, 1),
(33, 100000, 0, '0', '1', '1', '2024-07-17 17:09:49', '2024-07-17 17:09:49', 18, 2),
(34, 142500, 0, '0', '1', '1', '2024-07-17 18:20:05', '2024-07-17 18:20:05', 19, 2),
(35, 90500, 0, '0', '0', '1', '2024-07-17 18:32:20', '2024-07-25 02:41:26', 20, 1),
(36, 800000, 0, '0', '1', '1', '2024-07-17 18:37:10', '2024-07-18 21:24:42', 20, 2),
(37, 328000, 0, '0', '0', '1', '2024-07-18 21:19:10', '2024-07-25 02:36:26', 21, 1),
(38, 895000, 0, '0', '1', '1', '2024-07-18 21:27:14', '2024-07-18 21:38:12', 21, 2),
(39, 475000, 0, '0', '0', '1', '2024-07-18 21:37:08', '2024-07-18 22:46:30', 22, 1),
(40, 480500, 0, '0', '1', '1', '2024-07-18 21:40:17', '2024-07-25 02:49:54', 22, 2),
(41, 219000, 0, '0', '0', '1', '2024-07-18 22:35:46', '2024-07-18 22:39:17', 23, 1),
(42, 185000, 0, '0', '1', '1', '2024-07-18 22:38:00', '2024-07-18 22:49:33', 23, 2),
(43, 315000, 0, '0', '0', '1', '2024-07-18 22:41:11', '2024-07-18 22:42:12', 24, 1),
(44, 242750, 0, '0', '1', '1', '2024-07-18 22:43:44', '2024-07-18 22:52:40', 24, 2),
(45, 71000, 0, '0', '1', '1', '2024-07-20 02:20:27', '2024-07-20 02:20:27', 25, 1),
(46, 100000, 0, '0', '1', '1', '2024-07-20 02:29:14', '2024-07-25 02:52:08', 25, 2),
(47, 251000, 0, '0', '1', '1', '2024-07-25 01:15:42', '2024-07-25 01:47:01', 26, 1),
(48, 200000, 0, '0', '1', '1', '2024-07-25 01:34:21', '2024-07-25 01:34:21', 15, 2),
(49, 20000, 0, '0', '1', '1', '2024-07-25 01:57:08', '2024-07-25 01:57:08', 26, 2),
(50, 142000, 0, '0', '0', '1', '2024-07-25 02:15:43', '2024-07-25 02:17:33', 27, 1),
(51, 100000, 0, '0', '1', '1', '2024-07-25 02:20:25', '2024-07-25 02:42:34', 27, 2);

--
-- Déclencheurs `proforma`
--
DROP TRIGGER IF EXISTS `delete_dev`;
DELIMITER $$
CREATE TRIGGER `delete_dev` AFTER DELETE ON `proforma` FOR EACH ROW BEGIN
    DECLARE v_mtrem float;
    DECLARE v_mttva float;
    DECLARE v_devis_id int;
    SELECT devis.id, mt_rem, mt_tva INTO v_devis_id, v_mtrem, v_mttva FROM devis, devis_ttr WHERE devis.id=devis_ttr.devis_id AND devis_ttr.id=OLD.devttr_id;
    CALL devis(v_devis_id, v_mtrem, v_mttva);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `insert_dev`;
DELIMITER $$
CREATE TRIGGER `insert_dev` AFTER INSERT ON `proforma` FOR EACH ROW BEGIN
    DECLARE v_sumrem int;
    DECLARE v_sumtva int;
    DECLARE v_devis_id int;
    SELECT devis.id, sum_rem, sum_tva INTO v_devis_id, v_sumrem, v_sumtva FROM devis, devis_ttr WHERE devis.id=devis_ttr.devis_id AND devis_ttr.id=NEW.devttr_id;
    CALL devis(v_devis_id, v_sumrem, v_sumtva);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `quantity`
--

DROP TABLE IF EXISTS `quantity`;
CREATE TABLE IF NOT EXISTS `quantity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `valeur` float NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Déchargement des données de la table `quantity`
--

INSERT INTO `quantity` (`id`, `libelle`, `valeur`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, '¼', 0.25, '1', '2023-10-02 11:29:03', '2023-10-02 11:29:03', 1),
(2, '½', 0.5, '1', '2023-10-02 11:29:03', '2023-10-02 11:29:03', 1),
(3, '¾', 0.75, '1', '2023-10-02 11:29:03', '2023-10-02 11:29:03', 1),
(5, '⅜', 0.375, '1', '2023-11-12 16:23:16', '2023-11-12 16:23:27', 1);

-- --------------------------------------------------------

--
-- Structure de la table `rights`
--

DROP TABLE IF EXISTS `rights`;
CREATE TABLE IF NOT EXISTS `rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `rights`
--

INSERT INTO `rights` (`id`, `libelle`) VALUES
(1, 'Voir'),
(2, 'Ajouter'),
(3, 'Modifier'),
(4, 'Activer/Désactiver'),
(5, 'Transmettre'),
(6, 'Approuver/Rejeter'),
(7, 'Valider/Annuler'),
(8, 'Supprimer');

-- --------------------------------------------------------

--
-- Structure de la table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
CREATE TABLE IF NOT EXISTS `schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `schedules`
--

INSERT INTO `schedules` (`id`, `libelle`, `amount`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'Main d’œuvre', 0, '0', '2023-10-02 11:24:10', '2023-10-12 13:11:20', 1),
(2, 'Ouvrier spécialisé mains nues', 4500, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1),
(3, 'Chauffeur', 8000, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1),
(4, 'Soudeur à l\'arc (MMA) homologue', 1100, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1),
(5, 'Soudeur TIG/MIG', 18000, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1),
(6, 'Chaudronnier', 1300, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1),
(7, 'Tuyateur', 13000, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1),
(8, 'Aide chaudronnier, Aide tuyauteur', 9000, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1),
(9, 'Monteurs, Assembleurs, Ajusteurs', 8000, '1', '2023-10-02 11:24:10', '2023-10-04 13:54:11', 1);

-- --------------------------------------------------------

--
-- Structure de la table `ships`
--

DROP TABLE IF EXISTS `ships`;
CREATE TABLE IF NOT EXISTS `ships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `client_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `ships`
--

INSERT INTO `ships` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `client_id`, `user_id`) VALUES
(1, 'ALBONICA SA', '1', '2024-07-10 13:43:04', '2024-07-10 13:45:35', 1, 1),
(2, 'ZEBEROA', '1', '2024-07-10 13:46:01', '2024-07-10 13:46:01', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `statistic`
--

DROP TABLE IF EXISTS `statistic`;
CREATE TABLE IF NOT EXISTS `statistic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `draft` int(11) NOT NULL,
  `pending` int(11) NOT NULL,
  `approved` int(11) NOT NULL,
  `rejected` int(11) NOT NULL,
  `validated` int(11) NOT NULL,
  `canceled` int(11) NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `statistic`
--

INSERT INTO `statistic` (`id`, `draft`, `pending`, `approved`, `rejected`, `validated`, `canceled`, `status`, `created_at`, `updated_at`) VALUES
(1, 6, 0, 0, 0, 1, 0, '1', '2024-04-15 19:07:18', '2024-07-25 09:01:55');

-- --------------------------------------------------------

--
-- Structure de la table `supplies`
--

DROP TABLE IF EXISTS `supplies`;
CREATE TABLE IF NOT EXISTS `supplies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` int(11) NOT NULL,
  `cost` int(11) NOT NULL DEFAULT 0,
  `unit` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `suppllib_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `diameter_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `supplies`
--

INSERT INTO `supplies` (`id`, `amount`, `cost`, `unit`, `created_at`, `updated_at`, `suppllib_id`, `material_id`, `diameter_id`, `user_id`) VALUES
(1, 7500, 0, '', '2023-11-22 13:59:15', '2023-11-22 14:14:32', 8, 5, 7, 1),
(2, 3500, 0, '', '2023-11-22 14:15:43', '2023-11-22 14:15:43', 3, 6, 5, 1),
(3, 3500, 0, '', '2023-11-23 20:06:21', '2023-11-23 20:06:21', 8, 1, 6, 1),
(4, 5000, 0, '', '2023-11-23 20:06:21', '2023-11-23 20:06:21', 5, 4, 5, 1),
(5, 2500, 0, '', '2023-11-23 20:14:53', '2023-11-23 20:14:53', 5, 3, 7, 1),
(6, 4500, 0, '', '2023-11-23 20:14:53', '2023-11-23 20:14:53', 5, 3, 6, 1),
(7, 4000, 0, '', '2023-11-23 22:04:59', '2023-11-23 22:04:59', 10, 2, 7, 1),
(8, 2000, 0, 'kg', '2023-11-23 22:15:01', '2023-12-05 20:47:44', 8, 1, 5, 1),
(9, 8500, 0, 'paq', '2023-11-24 09:00:08', '2023-12-05 20:47:29', 1, 2, 5, 1),
(10, 5000, 0, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 6, 1, 7, 1),
(11, 3000, 0, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 6, 2, 6, 1),
(12, 20000, 0, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 10, 3, 5, 1),
(13, 50000, 0, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 10, 4, 6, 1),
(14, 6500, 0, 'paq', '2023-11-26 20:38:52', '2023-12-05 20:46:58', 5, 5, 3, 1),
(15, 7500, 0, 'l', '2023-11-27 12:02:21', '2023-12-05 20:46:44', 7, 1, 7, 1),
(16, 8500, 0, 'l', '2023-11-27 12:02:21', '2023-12-05 20:46:34', 7, 1, 6, 1),
(17, 19500, 0, 'kg', '2023-11-27 12:06:40', '2023-12-05 20:46:11', 8, 1, 7, 1),
(18, 10000, 0, 'kg', '2023-12-04 07:28:47', '2023-12-05 20:44:26', 8, 2, 7, 1),
(19, 5000, 0, 'paq', '2023-12-04 07:28:47', '2023-12-05 20:44:39', 5, 5, 7, 1),
(20, 7500, 0, 'm', '2023-12-04 08:07:54', '2023-12-05 20:43:46', 10, 5, 7, 1),
(21, 15000, 0, 'kg', '2023-12-04 12:27:29', '2023-12-05 20:43:25', 8, 1, 4, 1),
(22, 25000, 0, 'm', '2023-12-04 12:30:37', '2023-12-05 20:43:11', 10, 6, 4, 1),
(23, 6500, 0, 'm', '2023-12-05 20:42:32', '2023-12-05 20:42:32', 10, 6, 5, 1),
(25, 9500, 0, 'l', '2023-12-06 12:26:04', '2023-12-06 12:26:04', 8, 6, 6, 1),
(27, 5000, 0, 'kg', '2023-12-11 20:59:45', '2023-12-11 20:59:45', 8, 1, 2, 1),
(28, 2500, 0, 'kg', '2023-12-12 09:46:14', '2023-12-12 09:46:14', 8, 1, 1, 1),
(30, 1500, 0, NULL, '2024-04-04 01:05:20', '2024-04-04 01:05:20', 1, 0, 0, 1),
(31, 2500, 0, 'kg', '2024-04-04 01:39:28', '2024-04-04 01:39:28', 2, 0, 0, 1),
(32, 5000, 0, 'paq', '2024-04-04 19:27:45', '2024-04-04 19:27:45', 11, 5, 7, 1),
(33, 5000, 0, 'kit', '2024-04-06 06:47:41', '2024-04-06 06:47:41', 8, 5, 0, 1),
(34, 2500, 0, 'kg', '2024-04-15 09:11:52', '2024-04-15 09:11:52', 8, 5, 4, 1),
(35, 20000, 0, 'kg', '2024-04-15 09:22:12', '2024-04-15 09:22:12', 8, 0, 0, 1),
(36, 2000, 0, 'paq', '2024-04-15 19:58:53', '2024-04-15 19:58:53', 11, 0, 0, 1),
(37, 1500, 0, 'paq', '2024-04-15 19:58:53', '2024-04-15 19:58:53', 12, 0, 0, 1),
(38, 5000, 0, 'm', '2024-04-15 19:58:53', '2024-04-15 19:58:53', 5, 0, 0, 1),
(39, 3000, 0, 'kg', '2024-04-16 07:34:38', '2024-04-16 07:34:38', 3, 1, 7, 1),
(40, 3500, 0, 'm', '2024-04-16 08:31:55', '2024-04-16 08:31:55', 3, 1, 4, 1),
(41, 4500, 0, 'kg', '2024-04-16 08:31:55', '2024-04-16 08:31:55', 4, 3, 0, 1),
(42, 2500, 0, 'm', '2024-04-16 08:52:58', '2024-04-16 08:52:58', 1, 5, 4, 1),
(43, 3500, 0, 'm', '2024-04-16 08:52:58', '2024-04-16 08:52:58', 4, 2, 1, 1),
(44, 2500, 0, 'm', '2024-04-16 10:06:09', '2024-04-16 10:06:09', 10, 1, 7, 1),
(45, 4500, 0, 'paq', '2024-04-17 07:41:30', '2024-04-17 07:41:30', 10, 6, 0, 1),
(46, 7500, 0, 'paq', '2024-04-17 07:41:30', '2024-04-17 07:41:30', 10, 2, 0, 1),
(47, 5000, 0, 'kg', '2024-07-17 17:09:49', '2024-07-17 17:09:49', 4, 1, 7, 1),
(48, 10000, 0, 'kg', '2024-07-17 17:09:49', '2024-07-17 17:09:49', 4, 1, 6, 1),
(49, 10000, 8000, 'm', '2024-07-17 18:37:10', '2024-07-18 18:11:15', 4, 1, 4, 1),
(50, 10000, 5000, 'm', '2024-07-18 18:11:01', '2024-07-18 18:11:01', 4, 2, 4, 1),
(51, 1000, 0, 'kg', '2024-07-18 21:24:42', '2024-07-18 21:24:42', 7, 2, 6, 1),
(52, 2500, 0, 'kg', '2024-07-18 21:40:17', '2024-07-18 21:40:17', 10, 1, 4, 1),
(53, 7500, 0, 'kg', '2024-07-18 21:40:17', '2024-07-18 21:40:17', 10, 1, 2, 1),
(54, 8500, 0, 'kg', '2024-07-18 22:26:04', '2024-07-18 22:26:04', 10, 1, 6, 1),
(55, 10000, 0, 'kg', '2024-07-18 22:26:04', '2024-07-18 22:26:04', 10, 1, 1, 1),
(56, 7500, 0, 'kg', '2024-07-18 22:49:33', '2024-07-18 22:49:33', 4, 1, 2, 1),
(57, 8550, 0, 'm', '2024-07-18 22:52:40', '2024-07-18 22:52:40', 7, 1, 4, 1),
(58, 7500, 0, 'm', '2024-07-18 22:52:40', '2024-07-18 22:52:40', 7, 5, 0, 1),
(59, 5000, 0, 'paq', '2024-07-25 01:57:08', '2024-07-25 01:57:08', 11, 1, 4, 1),
(60, 8500, 0, 'kg', '2024-07-25 02:45:13', '2024-07-25 02:45:13', 10, 1, 5, 1),
(61, 7500, 0, 'kg', '2024-07-25 02:49:54', '2024-07-25 02:49:54', 10, 1, 3, 1);

-- --------------------------------------------------------

--
-- Structure de la table `suppl_lib`
--

DROP TABLE IF EXISTS `suppl_lib`;
CREATE TABLE IF NOT EXISTS `suppl_lib` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `suppltyp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `suppl_lib`
--

INSERT INTO `suppl_lib` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `suppltyp_id`, `user_id`) VALUES
(1, 'API SCH40', '0', '2023-11-21 16:02:19', '2023-11-22 10:48:46', 1, 1),
(2, 'API SCH80', '0', '2023-11-21 16:03:40', '2023-11-22 10:48:46', 1, 1),
(3, 'API SCH100', '0', '2023-11-21 16:04:07', '2023-11-22 10:48:46', 1, 1),
(4, 'Tuyau hydraulique', '1', '2023-11-21 16:04:27', '2023-11-23 19:14:22', 1, 1),
(5, 'Tuyau inox', '1', '2023-11-21 16:04:56', '2023-11-23 19:14:15', 1, 1),
(6, 'Tuyau galvanisé', '1', '2023-11-21 16:05:42', '2023-11-23 19:14:08', 1, 1),
(7, 'Tuyau aluminium', '1', '2023-11-21 16:06:04', '2023-11-23 19:13:59', 1, 1),
(8, 'Bride à souder', '1', '2023-11-21 16:06:58', '2023-11-22 14:02:15', 2, 1),
(10, 'Bride pleine', '1', '2023-11-21 21:31:01', '2023-11-22 14:01:43', 2, 1),
(11, 'Bloc de note', '1', '2024-03-20 15:47:54', '2024-03-20 15:48:04', 4, 1),
(12, 'Papier', '1', '2024-03-20 15:48:23', '2024-07-08 19:39:13', 4, 1);

-- --------------------------------------------------------

--
-- Structure de la table `suppl_typ`
--

DROP TABLE IF EXISTS `suppl_typ`;
CREATE TABLE IF NOT EXISTS `suppl_typ` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) NOT NULL,
  `status` enum('0','1') NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `suppl_typ`
--

INSERT INTO `suppl_typ` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'Tuyaux', '1', '2023-10-02 11:23:19', '2023-11-22 10:47:46', 1),
(2, 'Brides', '1', '2023-10-02 11:23:19', '2023-11-22 10:47:50', 1),
(3, 'Cartouche', '1', '2023-11-20 10:31:19', '2023-11-22 10:47:53', 1),
(4, 'Bureau', '1', '2024-03-20 15:47:12', '2024-03-20 15:47:24', 1);

-- --------------------------------------------------------

--
-- Structure de la table `transport`
--

DROP TABLE IF EXISTS `transport`;
CREATE TABLE IF NOT EXISTS `transport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `transport`
--

INSERT INTO `transport` (`id`, `libelle`, `amount`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'Transport  de jour A/R', 35000, '1', '2023-10-02 11:25:44', '2023-10-02 11:25:44', 1),
(2, 'Transport  de nuit A/R', 35000, '1', '2023-10-02 11:25:44', '2023-10-02 11:25:44', 1);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(20) COLLATE utf8mb3_unicode_ci NOT NULL,
  `firstname` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `gender` enum('M','F') COLLATE utf8mb3_unicode_ci NOT NULL,
  `number` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `avatar` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `login_at` datetime DEFAULT NULL,
  `password_at` datetime DEFAULT NULL,
  `status` enum('0','1') COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `profil_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `lastname`, `firstname`, `gender`, `number`, `email`, `password`, `avatar`, `login_at`, `password_at`, `status`, `created_at`, `updated_at`, `profil_id`, `user_id`) VALUES
(1, 'OGOU', 'Fabrice', 'M', '0749598979', 'fabiodesign2010@gmail.com', '$2y$10$hf8lSzUWqok1jYWsLehqr.Pf/wP4btReMUp/3nRAych1McU/glc3W', '20231001154444.jpg', '2024-12-16 12:02:55', '2024-05-19 11:04:54', '1', '2016-12-30 19:47:18', '2024-12-16 12:02:55', 1, 0),
(2, 'N\'CHO', 'Paul Emmanuel', 'M', '0778351588', 'ncho.pemmanuel@gmail.com', '$2y$10$a/SU4iKxCIa3dvl0If455uMIRjRzd6moOh49sKI5pO2x19rPKMGNS', 'homme.jpg', '2023-11-14 17:14:23', NULL, '1', '2023-09-29 12:39:23', '2023-11-14 17:14:23', 3, 0),
(3, 'AKRAN', 'James', 'M', '0707583261', 'jamesakran@gmail.com', '$2y$10$VIcMyWaNx0G.HPh4oWVBkupOgpW8HJEOw/L9hP6srqzUA2oK5bsXa', 'homme.jpg', '2023-11-11 18:59:28', NULL, '1', '2023-09-30 12:18:45', '2023-11-11 18:59:28', 2, 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
