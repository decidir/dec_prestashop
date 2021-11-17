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
*  @author    IURCO <info@iurco.com>
*  @copyright 2021 IURCO
*  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

if (!defined('_PS_VERSION_')) {
    exit;
}

// Cybersource Retail
if ($data->vrt == 'retail') {

    $pmnt['fraud_detection'] = array();
    $fd = &$pmnt['fraud_detection'];
    if ($data->sbx) {
        $fd['device_unique_identifier'] = 'decidir_agregador';
    } else {
        $fd['device_unique_identifier'] = $modu->genFingerprint();
    }
    $fd['send_to_cs'] = true;
    $fd['channel'] = 'Web';
    $fd['bill_to'] = array();
    $fd['purchase_totals'] = array();
    $fd['customer_in_site'] = array();
    $fd['dispatch_method'] = $carr->name;
    $fd['retail_transaction_data'] = array();

    $pt = &$fd['purchase_totals'];
    $pt['currency'] = $curr->iso_code;
    $pt['amount'] = (int)number_format($pmnt['amount'], 2, '', '');

    $cs = &$fd['customer_in_site'];
    $d1 = new DateTime($cust->date_add);
    $d2 = new DateTime('now');
    $d3 = $d1->diff($d2);
    $cs['days_in_site'] = (int)$d3->format('%a');
    $cs['is_guest'] = $cust->isGuest();
    $cs['password'] = $cust->passwd;
    $sql = "
    SELECT id_order FROM "._DB_PREFIX_."orders
    WHERE id_customer = {$cust->id};";
    $tr = Db::getInstance()->executeS($sql);
    $cs['num_of_transactions'] = count($tr);

    $bt = &$fd['bill_to'];
    $bt['city'] = $bill_addr->city;
    $bt['state'] = $bill_stat->iso_code;
    $bt['country'] = $bill_ctry->iso_code;
    $bt['customer_id'] = (string)$cust->id;
    $bt['email'] = $cust->email;
    $bt['first_name'] = $cust->firstname;
    $bt['last_name'] = $cust->lastname;
    $bt['street1'] = $bill_addr->address1;
    $bt['street2'] = $bill_addr->address2;
    $bt['postal_code'] = $ship_addr->postcode;
    if ($bill_addr->phone) {
        $bt['phone_number'] = $bill_addr->phone;
    } else {
        $bt['phone_number'] = $bill_addr->phone_mobile;
    }

    $rt = &$fd['retail_transaction_data'];
    $rt['ship_to'] = array();
    $rt['items'] = array();

    $st = &$rt['ship_to'];
    $st['city'] = $ship_addr->city;
    $st['state'] = $ship_stat->iso_code;
    $st['country'] = $ship_ctry->iso_code;
    $st['customer_id'] = (string)$cust->id;
    $st['email'] = $cust->email;
    $st['first_name'] = $cust->firstname;
    $st['last_name'] = $cust->lastname;
    $st['street1'] = $ship_addr->address1;
    $st['street2'] = $ship_addr->address2;
    $st['postal_code'] = $ship_addr->postcode;
    if ($ship_addr->phone) {
        $st['phone_number'] = $ship_addr->phone;
    } else {
        $st['phone_number'] = $ship_addr->phone_mobile;
    }

    $it = &$rt['items'];
    $prods = $cart->getProducts();
    foreach ($prods as $p) {
        $p = Tools::jsonEncode($p);
        $p = Tools::jsonDecode($p);
        $item = array();
        $item['code'] = $p->reference;
        $item['sku'] = $p->reference;
        if (!$p->description_short) {
            $p->description_short = $modu->l('No description');
        }
        $item['description'] = strip_tags($p->description_short);
        $item['name'] = $p->name;
        if (isset($p->attributes)) {
            $item['name'] .= $p->attributes;
        }
        $item['total_amount'] = (int)number_format($total, 2, '', '');
        $item['unit_price'] = (int)number_format($p->price, 2, '', '');
        $item['quantity'] = (int)$p->quantity;
        array_push($it, $item);
    }
}
