-- MySQL dump 10.13  Distrib 5.7.23, for macos10.13 (x86_64)
--
-- Host: 127.0.0.1    Database: shinkohd_abridge
-- ------------------------------------------------------
-- Server version	5.7.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

USE shinko;

--
-- Table structure for table `admin_user`
--

DROP TABLE IF EXISTS `admin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) unsigned NOT NULL,
  `user_id` varchar(127) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `administrator` smallint(6) DEFAULT '0',
  `is_active` tinyint(4) unsigned DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `base_products`
--

DROP TABLE IF EXISTS `base_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `base_products` (
  `base_id` int(11) NOT NULL COMMENT '拠点ID',
  `jan_cd` char(20) NOT NULL COMMENT 'JANコード',
  `price_start_date` date NOT NULL DEFAULT '2000-01-01' COMMENT '価格開始日',
  `price_end_date` date NOT NULL DEFAULT '2999-01-01' COMMENT '価格終了日',
  `supplier_code` char(20) DEFAULT '0' COMMENT '倉庫仕入先コード',
  `case_jan_cd` char(20) DEFAULT NULL COMMENT 'ボールJAN',
  `box_jan_cd` char(20) DEFAULT NULL COMMENT '箱JAN',
  `product_standard` varchar(255) DEFAULT NULL COMMENT '規格',
  `lot_quantity` int(11) DEFAULT '0' COMMENT '入数',
  `list_price` int(11) NOT NULL DEFAULT '0' COMMENT '税抜定価',
  `list_price_tax` int(11) NOT NULL DEFAULT '0' COMMENT '税込定価',
  `wholesale_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税抜卸値',
  `wholesale_price_tax` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税込卸値',
  `purchase_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税抜仕入値',
  `purchase_price_tax` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税込仕入値',
  `rebate_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税抜割戻価格',
  `rebate_price_tax` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税込割戻価格',
  `rebate_edlp_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税抜割戻価格(EDLP)',
  `rebate_edlp_price_tax` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税込割戻価格(EDLP)',
  `final_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税抜最終単価',
  `final_price_tax` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '税込最終単価',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登録日',
  `created_user_id` bigint(20) DEFAULT NULL COMMENT '登録者ID',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新日',
  `updated_user_id` bigint(20) DEFAULT NULL COMMENT '更新者ID',
  PRIMARY KEY (`base_id`,`jan_cd`,`price_start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `id` int(11) NOT NULL,
  `name` varchar(127) NOT NULL DEFAULT '',
  `zip` varchar(8) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `tel` char(20) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT '1',
  `close` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `company_admin_user_stores`
--

DROP TABLE IF EXISTS `company_admin_user_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_admin_user_stores` (
  `company_admin_user_id` int(11) NOT NULL,
  `store_id` int(11) NOT NULL,
  PRIMARY KEY (`company_admin_user_id`,`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `company_admin_users`
--

DROP TABLE IF EXISTS `company_admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `company_id` int(11) NOT NULL COMMENT '会社ID',
  `user_id` varchar(127) NOT NULL COMMENT 'ユーザーID',
  `email` varchar(255) DEFAULT NULL COMMENT 'メールアドレス',
  `name` varchar(255) DEFAULT NULL COMMENT '名前',
  `password` varchar(255) DEFAULT NULL COMMENT 'パスワード',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '有効/無効',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '登録日',
  `created_user_id` bigint(20) DEFAULT NULL COMMENT '登録者',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新日',
  `uppdated_user_id` bigint(20) DEFAULT NULL COMMENT '更新者',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `company_stores`
--

DROP TABLE IF EXISTS `company_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_stores` (
  `company_id` int(11) NOT NULL,
  `store_id` int(11) NOT NULL,
  PRIMARY KEY (`company_id`,`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `m_base`
--

DROP TABLE IF EXISTS `m_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `m_base` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(55) NOT NULL,
  `remarks` varchar(255) NOT NULL COMMENT '説明',
  `lower_limit_price` int(11) DEFAULT NULL,
  `lower_limit_quantity` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '有効/無効',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ms_products`
--

DROP TABLE IF EXISTS `ms_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ms_products` (
  `jan_cd` char(20) NOT NULL COMMENT 'JANコード',
  `product_name` varchar(255) NOT NULL COMMENT '商品名',
  `product_name_web` varchar(255) DEFAULT NULL COMMENT '商品名WEB',
  `product_name_kana` varchar(255) DEFAULT NULL COMMENT '商品名カナ',
  `product_name_pos` varchar(14) DEFAULT NULL COMMENT 'POS商品名',
  `maker_id` char(10) NOT NULL COMMENT 'メーカーID',
  `product_standard` varchar(255) DEFAULT NULL COMMENT '規格',
  `l_dep_id` char(10) NOT NULL COMMENT '部門ID',
  `m_dep_id` char(10) NOT NULL COMMENT '中部門ID',
  `s_dep_id` char(10) NOT NULL COMMENT '小部門ID',
  `annotation` varchar(255) DEFAULT NULL COMMENT '注釈・コメント',
  `description` text COMMENT '商品説明',
  `image` varchar(255) DEFAULT NULL COMMENT '画像ファイル名',
  `start_date` date NOT NULL DEFAULT '2000-01-01' COMMENT '販売開始日',
  `end_date` date NOT NULL DEFAULT '2999-01-01' COMMENT '販売終了日',
  `out_stock_date` date DEFAULT '2999-01-01' COMMENT 'メーカー欠品日',
  `old_jan_cd` char(20) DEFAULT NULL COMMENT '旧JANコード',
  `tax_rate` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '消費税率',
  `is_yamazaki` tinyint(1) unsigned DEFAULT '0' COMMENT 'ヤマザキパンフラグ',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '登録日',
  `created_user_id` varchar(127) DEFAULT NULL COMMENT '登録者ID',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新日',
  `updated_user_id` varchar(127) DEFAULT NULL COMMENT '更新者ID',
  PRIMARY KEY (`jan_cd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `store` (
  `id` int(11) NOT NULL,
  `company_id` int(11) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `zip` varchar(8) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `opening_time` varchar(7) DEFAULT NULL,
  `closing_time` varchar(7) DEFAULT NULL,
  `shift_open_time` tinyint(2) DEFAULT '0',
  `shift_close_time` tinyint(2) DEFAULT '0',
  `lot_flag` int(11) DEFAULT '0',
  `ship_date_add` int(11) NOT NULL DEFAULT '2',
  `price_card_flag` int(11) DEFAULT NULL,
  `is_inventory` tinyint(2) DEFAULT '0',
  `is_shift` tinyint(2) DEFAULT '0',
  `is_video` tinyint(2) DEFAULT '0',
  `is_pricecard` tinyint(2) DEFAULT '0',
  `is_shincharin` tinyint(2) DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '有効/無効',
  `regist_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `regist_user_id` bigint(20) NOT NULL,
  `update_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `store_bases`
--

DROP TABLE IF EXISTS `store_bases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `store_bases` (
  `store_id` int(11) NOT NULL,
  `base_id` int(11) NOT NULL,
  PRIMARY KEY (`store_id`,`base_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'shinkohd_abridge'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-22 18:14:07
