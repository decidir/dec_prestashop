<?php
/**
* 2007 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author    KaisarCode <info@kaisarcode.com>
*  @copyright 2021 KaisarCode
*  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

$sql = array();
$dbx = _DB_PREFIX_;
$eng = _MYSQL_ENGINE_;

$sql[] = "
ALTER TABLE `{$dbx}order_state`
ADD `decidir_state` VARCHAR(80) NULL;";

// Create table banks
$sql[] = "
CREATE TABLE `{$dbx}decidir_banks` (
`id_bank` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR(255) NOT NULL DEFAULT '',
`logo` VARCHAR(255) NOT NULL DEFAULT '',
`active` INT(1) NOT NULL DEFAULT '0',
PRIMARY KEY (`id_bank`)) ENGINE = $eng;";

// Create table cards
$sql[] = "
CREATE TABLE `{$dbx}decidir_cards` (
`id_card` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR(255) NOT NULL DEFAULT '',
`id_sps` INT(6) NOT NULL DEFAULT '0',
`id_nps` INT(6) NOT NULL DEFAULT '0',
`logo` VARCHAR(255) NOT NULL DEFAULT '',
`active` INT(1) NOT NULL DEFAULT '0',
PRIMARY KEY (`id_card`)) ENGINE = $eng;";

// Create table promotions
$sql[] = "
CREATE TABLE `{$dbx}decidir_promotions` (
`id_promotion` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR(255) NOT NULL DEFAULT '',
`banks` VARCHAR(255) NOT NULL DEFAULT '',
`cards` VARCHAR(255) NOT NULL DEFAULT '',
`id_merchant` VARCHAR(255) NOT NULL DEFAULT '',
`active` INT(1) NOT NULL DEFAULT '0',
`position` INT(8) NOT NULL DEFAULT '0',
`date_from` DATETIME NULL,
`date_to` DATETIME NULL,
`applicable_days` VARCHAR(13) NOT NULL DEFAULT '1,2,3,4,5,6,7',
`shops` VARCHAR(255) NOT NULL DEFAULT '',
PRIMARY KEY (`id_promotion`)) ENGINE = $eng;";

// Create table installments
$sql[] = "
CREATE TABLE `{$dbx}decidir_installments` (
`id_installment` INT NOT NULL AUTO_INCREMENT,
`id_promotion` INT NOT NULL DEFAULT 0,
`installment` INT(8) NOT NULL DEFAULT 1,
`coefficient` VARCHAR(255) NOT NULL DEFAULT '1.00',
`tea` VARCHAR(255) NOT NULL DEFAULT '0.00',
`cft` VARCHAR(255) NOT NULL DEFAULT '0.00',
`bank_refund` VARCHAR(255) NOT NULL DEFAULT '0.00',
`bank_refund_unit` VARCHAR(1) NOT NULL DEFAULT '%',
`discount` VARCHAR(255) NOT NULL DEFAULT '0.00',
`discount_unit` VARCHAR(1) NOT NULL DEFAULT '%',
`installment_to_send` VARCHAR(255) NOT NULL DEFAULT 1,
PRIMARY KEY (`id_installment`)) ENGINE = $eng;";

// Insert banks
$sql[] = "
INSERT INTO `{$dbx}decidir_banks`
(`id_bank`, `name`, `logo`, `active`)
VALUES (NULL, 'Ahora 12', 'default/ahora12.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_banks`
(`id_bank`, `name`, `logo`, `active`)
VALUES (NULL, 'Banco de Galicia y Buenos Aires S.A.', 'default/galicia.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_banks`
(`id_bank`, `name`, `logo`, `active`)
VALUES (NULL, 'Banco de la Nación Argentina', 'default/nacion.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_banks`
(`id_bank`, `name`, `logo`, `active`)
VALUES (NULL, 'Banco de la Provincia de Buenos Aires', 'default/bapro.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_banks`
(`id_bank`, `name`, `logo`, `active`)
VALUES (NULL, 'Standard Bank Argentina S.A. - ICBC', 'default/icbc.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_banks`
(`id_bank`, `name`, `logo`, `active`)
VALUES (NULL, 'CitiBank S.A.', 'default/citi.jpg', 1) ";

// Insert cards
$sql[] = "
INSERT INTO `{$dbx}decidir_cards`
(`id_card`, `name`, `id_sps`, `id_nps`, `logo`, `active`)
VALUES (NULL, 'VISA', 1, 14, 'default/visa.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_cards`
(`id_card`, `name`, `id_sps`, `id_nps`, `logo`, `active`)
VALUES (NULL, 'American Express', 65, 1, 'default/american.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_cards`
(`id_card`, `name`, `id_sps`, `id_nps`, `logo`, `active`)
VALUES (NULL, 'Diners', 8, 2, 'default/diners.jpg', 1);";
$sql[] = "
INSERT INTO `{$dbx}decidir_cards`
(`id_card`, `name`, `id_sps`, `id_nps`, `logo`, `active`)
VALUES (NULL, 'MasterCard', 15, 5, 'default/master.jpg', 1);";

// Execute sql
foreach ($sql as $q) {
    try {
        Db::getInstance()->execute($q);
    } catch (Exception $e) {
        
    }
}
