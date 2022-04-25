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
    $fraudDetection = &$pmnt['fraud_detection'];

    // Whether to send this data to Cybersource (always `true`)
    $fraudDetection['send_to_cs'] = true;

    // Channel is always fixed to be `Web`
    $fraudDetection['channel'] = 'Web';
    $fraudDetection['dispatch_method'] = $carr->name;

    // *****
    // A note about `retail_transaction_data`
    //
    // Given this version isn't built on top of the SDK Data classes
    // We need to strictly specify the `retail_transaction_data` with `ship_to` and `items` nodes
    // cause this association occurs within the `Cybersource\AbstractData::construc()` method
    //
    // In a regular sceneario where this data layer relies on the SDK Data class,
    // both keys (`ship_to` and `items`) would be assigned to the root array node.
    // As `bill_to`, 'purchase_totals', field currently are.
    // This will be refactored in futures version to avoid having this poorly data modeling
    $fraudDetection['retail_transaction_data'] = array();

    // *****
    // Purchase Totals data set
    $fraudDetection['purchase_totals'] = array(
        'currency' => (string) $curr->iso_code,
        'amount' => (int) number_format($pmnt['amount'], 2, '', '')
    );


    // *****
    // Customer In Site data set
    $customerInSite = array();
    $customerIsGuest = $cust->isGuest();
    $customerDaysInSite = 0;
    $customerTransactionCount = 0;

    // Retrieve the `customer_id`
    // either send the registered Customer id
    // or construct the value based on Customer Firstname and Lastname
    $customerId = $customerIsGuest
        ? (string) ($cust->firstname . '_' . $cust->lastname)
        : (string) $cust->id;

    // If it's a registered Customer
    if (!$customerIsGuest) {
        $d1 = new DateTime($cust->date_add);
        $d2 = new DateTime('now');
        $d3 = $d1->diff($d2);
        $customerDaysInSite = $d3->format('%a');

        // Retrieve Customer stats
        // `nb_orders` will only take into account Paid and Completed Orders
        // because it filters by `<database_prefix>_orders.valid` = 1
        // @see Customer::getStats()
        $customerStats = $cust->getStats();
        $customerTransactionCount = $customerStats['nb_orders'];
    }

    $customerInSite = array(
        'is_guest' => $customerIsGuest,
        'days_in_site' => (int) $customerDaysInSite,
        'num_of_transactions' => (int) $customerTransactionCount
    );

    $fraudDetection['customer_in_site'] = $customerInSite;


    // *****
    // Bill To data set
    $billToAddress = array(
        'city' => $bill_addr->city,
        'state' => $bill_stat->iso_code,
        'country' => $bill_ctry->iso_code,
        'customer_id' => $customerId,
        'email' => $cust->email,
        'first_name' => $cust->firstname,
        'last_name' => $cust->lastname,
        'street1' => $bill_addr->address1,
        'street2' => $bill_addr->address2,
        'postal_code' => $bill_addr->postcode
    );

    // either send the telephone or mobile phone number
    if ($bill_addr->phone) {
        $billPhoneNumber = $bill_addr->phone;
    } else {
        $billPhoneNumber = $bill_addr->phone_mobile;
    }
    $billToAddress['phone_number'] = $billPhoneNumber;

    $fraudDetection['bill_to'] = $billToAddress;


    // ******
    // Builds Shipping Address data
    $shipToAddress = array(
        'city' => $ship_addr->city,
        'state' => $ship_stat->iso_code,
        'country' => $ship_ctry->iso_code,
        'customer_id' => $customerId,
        'email' => $cust->email,
        'first_name' => $cust->firstname,
        'last_name' => $cust->lastname,
        'street1' => $ship_addr->address1,
        'street2' => $ship_addr->address2,
        'postal_code' => $ship_addr->postcode
    );

    if ($ship_addr->phone) {
        $shipPhoneNumber = $ship_addr->phone;
    } else {
        $shipPhoneNumber = $ship_addr->phone_mobile;
    }
    $shipToAddress['phone_number'] = $shipPhoneNumber;

    $fraudDetection['retail_transaction_data']['ship_to'] = $shipToAddress;


    // ******
    // Build Order Items data
    $items = array();
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

        array_push($items, $item);
    }
    $fraudDetection['retail_transaction_data']['items'] = $items;
}
