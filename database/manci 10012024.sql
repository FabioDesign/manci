-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : mer. 10 jan. 2024 à 23:10
-- Version du serveur : 5.7.44
-- Version de PHP : 8.1.25

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

DELIMITER |
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `devis`|
CREATE PROCEDURE `devis` (`v_devis_id` INT, `v_sumrem` INT, `v_sumtva` INT)   BEGIN

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

  END|

DROP PROCEDURE IF EXISTS `statistic`|
CREATE PROCEDURE `statistic` ()   BEGIN

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

  END|

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `bill_addr`
--

DROP TABLE IF EXISTS `bill_addr`;
CREATE TABLE IF NOT EXISTS `bill_addr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `content` text COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `client_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `libelle` text COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `clients`
--

INSERT INTO `clients` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'GRUPO ALBACORA', '1', '2023-10-02 10:40:21', '2023-10-02 10:40:21', 1),
(2, 'CLIENT TEST 2', '1', '2023-10-04 19:21:36', '2023-10-04 19:40:31', 2),
(3, 'CLIENT TEST 3', '1', '2023-10-04 19:43:26', '2023-10-04 19:43:50', 2),
(4, 'CLIENT TEST 4', '1', '2023-10-04 19:43:41', '2023-10-04 19:43:46', 2);

-- --------------------------------------------------------

--
-- Structure de la table `commandes`
--

DROP TABLE IF EXISTS `commandes`;
CREATE TABLE IF NOT EXISTS `commandes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` float NOT NULL,
  `quantity` float NOT NULL,
  `valeur` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `unit` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `item_id` int(11) NOT NULL,
  `devttr_id` int(11) NOT NULL,
  `devtyp_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `devis`
--

DROP TABLE IF EXISTS `devis`;
CREATE TABLE IF NOT EXISTS `devis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `date_at` date NOT NULL,
  `mt_ht` float DEFAULT NULL,
  `mt_rem` float DEFAULT NULL,
  `mt_tva` float DEFAULT NULL,
  `mt_ttc` float DEFAULT NULL,
  `mt_euro` float DEFAULT NULL,
  `sum_rem` tinyint(4) NOT NULL,
  `sum_tva` tinyint(4) NOT NULL,
  `see_tva` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `see_rem` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `see_euro` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `motif` text COLLATE utf8_unicode_ci,
  `approved_at` datetime DEFAULT NULL,
  `validated_at` datetime DEFAULT NULL,
  `transmitted_at` datetime DEFAULT NULL,
  `status` enum('0','1','2','3','4','5') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `header_id` int(11) NOT NULL,
  `billaddr_id` int(11) NOT NULL,
  `approved_id` int(11) DEFAULT NULL,
  `validated_id` int(11) DEFAULT NULL,
  `transmitted_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déclencheurs `devis`
--
DROP TRIGGER IF EXISTS `insert_stat`;
DELIMITER |
CREATE TRIGGER `insert_stat` AFTER INSERT ON `devis` FOR EACH ROW BEGIN
    CALL statistic();
END
|
DELIMITER ;
DROP TRIGGER IF EXISTS `update_dev`;
DELIMITER |
CREATE TRIGGER `update_dev` AFTER UPDATE ON `devis` FOR EACH ROW BEGIN
    CALL statistic();
END
|
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `devis_ttr`
--

DROP TABLE IF EXISTS `devis_ttr`;
CREATE TABLE IF NOT EXISTS `devis_ttr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `devis_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `devis_txt`
--

DROP TABLE IF EXISTS `devis_txt`;
CREATE TABLE IF NOT EXISTS `devis_txt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `devttr_id` int(11) NOT NULL,
  `devtyp_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1683 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
(1537, 1, 6, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1538, 1, 19, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1539, 1, 18, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1540, 1, 18, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1541, 1, 18, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1542, 1, 18, 5, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1543, 1, 18, 6, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1544, 1, 18, 7, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1545, 1, 18, 8, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1546, 1, 7, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1547, 1, 7, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1548, 1, 7, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1549, 1, 7, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1550, 1, 8, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1551, 1, 8, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1552, 1, 8, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1553, 1, 8, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1554, 1, 9, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1555, 1, 9, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1556, 1, 9, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1557, 1, 9, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1558, 1, 10, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1559, 1, 10, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1560, 1, 10, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1561, 1, 10, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1562, 1, 11, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1563, 1, 11, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1564, 1, 13, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1565, 1, 13, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1566, 1, 13, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1567, 1, 13, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1568, 1, 12, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1569, 1, 12, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1570, 1, 12, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1571, 1, 12, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1572, 1, 14, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1573, 1, 14, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1574, 1, 14, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1575, 1, 14, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1576, 1, 20, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1577, 1, 20, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1578, 1, 20, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1579, 1, 20, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1580, 1, 21, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1581, 1, 21, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1582, 1, 21, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1583, 1, 21, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1584, 1, 22, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1585, 1, 22, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1586, 1, 22, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1587, 1, 15, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1588, 1, 15, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1589, 1, 15, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1590, 1, 15, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1591, 1, 16, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1592, 1, 16, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1593, 1, 16, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1594, 1, 16, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1595, 1, 17, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1596, 1, 17, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1597, 1, 17, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1598, 1, 17, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1599, 1, 1, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1600, 1, 2, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1601, 1, 3, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1602, 1, 3, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1603, 1, 3, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1604, 1, 3, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1605, 1, 4, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1606, 1, 4, 2, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1607, 1, 4, 3, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1608, 1, 4, 4, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
(1609, 1, 5, 1, '2023-11-23 19:18:37', '2023-11-23 19:18:37'),
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
(1682, 2, 5, 1, '2023-12-14 12:00:11', '2023-12-14 12:00:11');

-- --------------------------------------------------------

--
-- Structure de la table `headers`
--

DROP TABLE IF EXISTS `headers`;
CREATE TABLE IF NOT EXISTS `headers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `logo` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `headers`
--

INSERT INTO `headers` (`id`, `libelle`, `logo`, `status`, `created_at`, `updated_at`) VALUES
(1, 'MANCI', 'manci.jpg', '1', '2023-10-05 16:03:48', '2023-10-05 16:05:04'),
(2, 'IMNS', 'imns.jpg', '1', '2023-10-05 16:03:48', '2023-10-05 16:05:04'),
(3, 'SORENA', 'sorena.jpg', '1', '2023-10-05 16:03:48', '2023-10-05 16:05:04');

-- --------------------------------------------------------

--
-- Structure de la table `inspectors`
--

DROP TABLE IF EXISTS `inspectors`;
CREATE TABLE IF NOT EXISTS `inspectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `firstname` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `profil` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `action` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `color` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `avatar` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `logs`
--

INSERT INTO `logs` (`id`, `username`, `profil`, `libelle`, `action`, `color`, `avatar`, `created_at`, `updated_at`) VALUES
(1, 'James AKRAN', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-12-22 11:47:08', '2023-12-22 11:47:08'),
(2, 'Paul N\'CHO', 'COMMERCIAL', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-12-22 11:49:06', '2023-12-22 11:49:06'),
(3, 'James AKRAN', 'Administrateur', 'Tableau de bord', 'Deconnecter', 'primary', 'homme.jpg', '2023-12-22 12:10:28', '2023-12-22 12:10:28'),
(4, 'James AKRAN', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-12-26 16:17:32', '2023-12-26 16:17:32'),
(5, 'James AKRAN', 'Administrateur', 'Tableau de bord', 'Deconnecter', 'primary', 'homme.jpg', '2023-12-26 16:17:58', '2023-12-26 16:17:58'),
(6, 'James AKRAN', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-12-26 19:46:00', '2023-12-26 19:46:00'),
(7, 'James AKRAN', 'Administrateur', 'Tableau de bord', 'Deconnecter', 'primary', 'homme.jpg', '2023-12-26 20:03:51', '2023-12-26 20:03:51'),
(8, 'James AKRAN', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-12-27 17:48:10', '2023-12-27 17:48:10'),
(9, 'James AKRAN', 'Administrateur', 'Tableau de bord', 'Deconnecter', 'primary', 'homme.jpg', '2023-12-27 17:56:47', '2023-12-27 17:56:47'),
(10, 'James AKRAN', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-12-27 18:33:06', '2023-12-27 18:33:06'),
(11, 'James AKRAN', 'Administrateur', 'Tableau de bord', 'Deconnecter', 'primary', 'homme.jpg', '2023-12-27 22:32:11', '2023-12-27 22:32:11'),
(12, 'James AKRAN', 'Administrateur', 'Accueil', 'Connecter', 'primary', 'homme.jpg', '2023-12-28 15:12:53', '2023-12-28 15:12:53'),
(13, 'Fabrice OGOU', 'Super Admin', 'Mot de passe oublié', 'Modifier', 'warning', '20231001154444.jpg', '2024-01-04 14:27:20', '2024-01-04 14:27:20'),
(14, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-01-04 14:28:00', '2024-01-04 14:28:00'),
(15, 'Fabrice OGOU', 'Super Admin', 'Tableau de bord', 'Deconnecter', 'primary', '20231001154444.jpg', '2024-01-04 14:29:14', '2024-01-04 14:29:14'),
(16, 'Fabrice OGOU', 'Super Admin', 'Accueil', 'Connecter', 'primary', '20231001154444.jpg', '2024-01-04 14:29:26', '2024-01-04 14:29:26'),
(17, 'Fabrice OGOU', 'Super Admin', 'Tableau de bord', 'Deconnecter', 'primary', '20231001154444.jpg', '2024-01-04 14:29:31', '2024-01-04 14:29:31');

-- --------------------------------------------------------

--
-- Structure de la table `materials`
--

DROP TABLE IF EXISTS `materials`;
CREATE TABLE IF NOT EXISTS `materials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `pages`
--

DROP TABLE IF EXISTS `pages`;
CREATE TABLE IF NOT EXISTS `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `fichier` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `position` tinyint(2) NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
-- Structure de la table `profils`
--

DROP TABLE IF EXISTS `profils`;
CREATE TABLE IF NOT EXISTS `profils` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `profils`
--

INSERT INTO `profils` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'Super Admin', 1, '2017-07-31 10:25:40', '2023-09-23 20:36:11', 0),
(2, 'Administrateur', 1, '2023-09-29 12:35:18', '2023-09-29 12:35:18', 0),
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
  `see_rem` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `devttr_id` int(11) NOT NULL,
  `devtyp_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déclencheurs `proforma`
--
DROP TRIGGER IF EXISTS `delete_dev`;
DELIMITER |
CREATE TRIGGER `delete_dev` AFTER DELETE ON `proforma` FOR EACH ROW BEGIN
    DECLARE v_mtrem float;
    DECLARE v_mttva float;
    DECLARE v_devis_id int;
    SELECT devis.id, mt_rem, mt_tva INTO v_devis_id, v_mtrem, v_mttva FROM devis, devis_ttr WHERE devis.id=devis_ttr.devis_id AND devis_ttr.id=OLD.devttr_id;
    CALL devis(v_devis_id, v_mtrem, v_mttva);
END
|
DELIMITER ;
DROP TRIGGER IF EXISTS `insert_dev`;
DELIMITER |
CREATE TRIGGER `insert_dev` AFTER INSERT ON `proforma` FOR EACH ROW BEGIN
    DECLARE v_sumrem int;
    DECLARE v_sumtva int;
    DECLARE v_devis_id int;
    SELECT devis.id, sum_rem, sum_tva INTO v_devis_id, v_sumrem, v_sumtva FROM devis, devis_ttr WHERE devis.id=devis_ttr.devis_id AND devis_ttr.id=NEW.devttr_id;
    CALL devis(v_devis_id, v_sumrem, v_sumtva);
END
|
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `quantity`
--

DROP TABLE IF EXISTS `quantity`;
CREATE TABLE IF NOT EXISTS `quantity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `valeur` float NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `quantity`
--

INSERT INTO `quantity` (`id`, `libelle`, `valeur`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, '¼', 0.25, '1', '2023-10-02 11:29:03', '2023-10-02 11:29:03', 1),
(2, '½', 0.5, '1', '2023-10-02 11:29:03', '2023-10-02 11:29:03', 1),
(3, '¾', 0.75, '1', '2023-10-02 11:29:03', '2023-10-02 11:29:03', 1),
(4, '⅛', 0.125, '1', '2023-10-02 11:29:03', '2023-10-02 11:29:03', 1),
(5, '⅜', 0.375, '1', '2023-11-12 16:23:16', '2023-11-12 16:23:27', 1);

-- --------------------------------------------------------

--
-- Structure de la table `rights`
--

DROP TABLE IF EXISTS `rights`;
CREATE TABLE IF NOT EXISTS `rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
(8, 'Voir prix');

-- --------------------------------------------------------

--
-- Structure de la table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
CREATE TABLE IF NOT EXISTS `schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `inspector_id` int(11) NOT NULL,
  `billaddr_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `ships`
--

INSERT INTO `ships` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `inspector_id`, `billaddr_id`, `user_id`) VALUES
(1, 'ALBACORA QUINCE', '1', '2023-10-02 11:17:57', '2023-10-02 11:17:57', 1, 1, 1),
(2, 'LA SANTA MARIA, 1460,', '1', '2023-10-04 19:55:22', '2023-10-04 19:56:39', 2, 2, 2),
(3, 'LE QUEEN ANNE\'S REVENGE, 1710.', '1', '2023-10-04 19:56:21', '2023-10-04 19:56:45', 3, 2, 2),
(4, 'L\'AMERIGO VESPUCCI, 1931, 82M. ...', '1', '2023-10-04 20:03:14', '2023-10-04 20:03:27', 4, 3, 2);

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
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `supplies`
--

DROP TABLE IF EXISTS `supplies`;
CREATE TABLE IF NOT EXISTS `supplies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` int(11) NOT NULL,
  `unit` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `suppllib_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `diameter_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `supplies`
--

INSERT INTO `supplies` (`id`, `amount`, `unit`, `created_at`, `updated_at`, `suppllib_id`, `material_id`, `diameter_id`, `user_id`) VALUES
(1, 7500, '', '2023-11-22 13:59:15', '2023-11-22 14:14:32', 8, 5, 7, 1),
(2, 3500, '', '2023-11-22 14:15:43', '2023-11-22 14:15:43', 3, 6, 5, 1),
(3, 3500, '', '2023-11-23 20:06:21', '2023-11-23 20:06:21', 8, 1, 6, 1),
(4, 5000, '', '2023-11-23 20:06:21', '2023-11-23 20:06:21', 5, 4, 5, 1),
(5, 2500, '', '2023-11-23 20:14:53', '2023-11-23 20:14:53', 5, 3, 7, 1),
(6, 4500, '', '2023-11-23 20:14:53', '2023-11-23 20:14:53', 5, 3, 6, 1),
(7, 4000, '', '2023-11-23 22:04:59', '2023-11-23 22:04:59', 10, 2, 7, 1),
(8, 2000, 'kg', '2023-11-23 22:15:01', '2023-12-05 20:47:44', 8, 1, 5, 1),
(9, 8500, 'paq', '2023-11-24 09:00:08', '2023-12-05 20:47:29', 1, 2, 5, 1),
(10, 5000, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 6, 1, 7, 1),
(11, 3000, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 6, 2, 6, 1),
(12, 20000, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 10, 3, 5, 1),
(13, 50000, '', '2023-11-24 09:09:47', '2023-11-24 09:09:47', 10, 4, 6, 1),
(14, 6500, 'paq', '2023-11-26 20:38:52', '2023-12-05 20:46:58', 5, 5, 3, 1),
(15, 7500, 'l', '2023-11-27 12:02:21', '2023-12-05 20:46:44', 7, 1, 7, 1),
(16, 8500, 'l', '2023-11-27 12:02:21', '2023-12-05 20:46:34', 7, 1, 6, 1),
(17, 19500, 'kg', '2023-11-27 12:06:40', '2023-12-05 20:46:11', 8, 1, 7, 1),
(18, 10000, 'kg', '2023-12-04 07:28:47', '2023-12-05 20:44:26', 8, 2, 7, 1),
(19, 5000, 'paq', '2023-12-04 07:28:47', '2023-12-05 20:44:39', 5, 5, 7, 1),
(20, 7500, 'm', '2023-12-04 08:07:54', '2023-12-05 20:43:46', 10, 5, 7, 1),
(21, 15000, 'kg', '2023-12-04 12:27:29', '2023-12-05 20:43:25', 8, 1, 4, 1),
(22, 25000, 'm', '2023-12-04 12:30:37', '2023-12-05 20:43:11', 10, 6, 4, 1),
(23, 6500, 'm', '2023-12-05 20:42:32', '2023-12-05 20:42:32', 10, 6, 5, 1),
(24, 4500, 'l', '2023-12-06 12:26:04', '2023-12-06 12:26:04', 8, 6, 7, 1),
(25, 9500, 'l', '2023-12-06 12:26:04', '2023-12-06 12:26:04', 8, 6, 6, 1),
(26, 3500, 'kg', '2023-12-11 19:38:49', '2023-12-11 19:38:49', 8, 1, 3, 1),
(27, 5000, 'kg', '2023-12-11 20:59:45', '2023-12-11 20:59:45', 8, 1, 2, 1),
(28, 2500, 'kg', '2023-12-12 09:46:14', '2023-12-12 09:46:14', 8, 1, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `suppl_lib`
--

DROP TABLE IF EXISTS `suppl_lib`;
CREATE TABLE IF NOT EXISTS `suppl_lib` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `suppltyp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
(9, 'vide', '1', '2023-11-21 16:07:20', '2023-11-22 10:49:00', 2, 1),
(10, 'Bride pleine', '1', '2023-11-21 21:31:01', '2023-11-22 14:01:43', 2, 1);

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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `suppl_typ`
--

INSERT INTO `suppl_typ` (`id`, `libelle`, `status`, `created_at`, `updated_at`, `user_id`) VALUES
(1, 'Tuyaux', '1', '2023-10-02 11:23:19', '2023-11-22 10:47:46', 1),
(2, 'Brides', '1', '2023-10-02 11:23:19', '2023-11-22 10:47:50', 1),
(3, 'Cartouche', '1', '2023-11-20 10:31:19', '2023-11-22 10:47:53', 1);

-- --------------------------------------------------------

--
-- Structure de la table `transport`
--

DROP TABLE IF EXISTS `transport`;
CREATE TABLE IF NOT EXISTS `transport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

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
  `lastname` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `firstname` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `gender` enum('M','F') COLLATE utf8_unicode_ci NOT NULL,
  `number` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `avatar` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `login_at` datetime DEFAULT NULL,
  `password_at` datetime DEFAULT NULL,
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `profil_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `lastname`, `firstname`, `gender`, `number`, `email`, `password`, `avatar`, `login_at`, `password_at`, `status`, `created_at`, `updated_at`, `profil_id`, `user_id`) VALUES
(1, 'OGOU', 'Fabrice', 'M', '0749598979', 'fabiodesign2010@gmail.com', '$2y$10$4L.1Vc1NORn4m6z7RQnsROHDW5dfcQNJfubs68F9jy/sxgkXpb76a', '20231001154444.jpg', '2024-01-04 14:29:26', '2024-01-04 14:27:20', '1', '2016-12-30 19:47:18', '2024-01-04 14:29:26', 1, 0),
(2, 'N\'CHO', 'Paul Emmanuel', 'M', '0778351588', 'ncho.pemmanuel@gmail.com', '$2y$10$a/SU4iKxCIa3dvl0If455uMIRjRzd6moOh49sKI5pO2x19rPKMGNS', 'homme.jpg', '2023-12-22 11:49:06', NULL, '1', '2023-09-29 12:39:23', '2023-12-22 11:49:06', 3, 0),
(3, 'AKRAN', 'James', 'M', '0707583261', 'jamesakran@gmail.com', '$2y$10$VIcMyWaNx0G.HPh4oWVBkupOgpW8HJEOw/L9hP6srqzUA2oK5bsXa', 'homme.jpg', '2023-12-28 15:12:53', NULL, '1', '2023-09-30 12:18:45', '2023-12-28 15:12:53', 2, 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
