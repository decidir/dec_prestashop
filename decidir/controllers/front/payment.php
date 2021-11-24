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

class DecidirPaymentModuleFrontController extends ModuleFrontController
{

    /** @var string Transaction platform origin service */
    const CONNECTOR_SERVICE = 'SDK-PHP-IURCO-PRESTASHOP';

    /** @var string Platform developer */
    const CONNECTOR_DEVELOPER = 'IURCO - Prisma SA';

    /** @var string Transaction origin prouper */
    const CONNECTOR_GROUPER = 'PS-Gateway-DECIDIR';

    public $display_column_left = false;
    public $display_column_right = false;

    public function initContent()
    {
        parent::initContent();
        $modu = $this->module;
        $data = $modu->setUp();
        $modu->createOrderStates();
        $cart = $this->context->cart;
        $prms = Tools::getAllValues();
        require "{$modu->path}/vendor/autoload.php";

        if ($cart->orderExists()) {
            $this->loadPageTemplate('front', 'exists', $data);
        } else if (!Tools::getValue('decidir-pay-token')) {
            $this->loadPageTemplate('front', 'disallow', $data);
        } else {
            $data->tst = null;

            $shop = new Shop($data->shp);
            $cust = new Customer($cart->id_customer);
            $curr = new Currency($cart->id_currency);
            $carr = new Carrier($cart->id_carrier);

            // Billing address
            $bill_addr = new Address($cart->id_address_invoice);
            $bill_ctry = new Country($bill_addr->id_country);
            $bill_stat = new State($bill_addr->id_state);

            // Shipping address
            $ship_addr = new Address($cart->id_address_delivery);
            $ship_ctry = new Country($ship_addr->id_country);
            $ship_stat = new State($ship_addr->id_state);

            // Order data
            $prott = Tools::getValue('decidir-installments-total');
            $total = $cart->getOrderTotal(true, Cart::BOTH);
            $refer = Order::generateReference();

            // Prepare Decidir payment
            $conn = new \Decidir\Connector(array(
                'public_key' => $data->key_pub,
                'private_key' => $data->key_prv
            ), $data->env, self::CONNECTOR_DEVELOPER, self::CONNECTOR_GROUPER, self::CONNECTOR_SERVICE);

            $pmnt = array();
            $pmnt['site_transaction_id'] = $refer;
            $pmnt['token'] = (string) $prms['decidir-pay-token'];
            $pmnt['payment_method_id'] = (int) $prms['decidir-method-id'];
            $pmnt['bin'] = (string) $prms['decidir-card-bin'];
            $pmnt['amount'] = $prott;
            $pmnt['currency'] = (string) $curr->iso_code;
            $pmnt['installments'] = (int) $prms['decidir-installments'];
            $pmnt['payment_type'] = 'single';
            $pmnt['sub_payments'] = array();
            $pmnt['email'] = $cust->email;
            $pmnt['ip_address'] = Tools::getRemoteAddr();

            $customerId = $cust->isGuest()
              ? (string) ($cust->firstname . '_' . $cust->lastname)
              : (string) $cust->id;

            $pmnt['customer'] = [
                'id' => $customerId,
                'email' => $cust->email,
                'ip_address' => Tools::getRemoteAddr()
            ];

            // Integrate Cybersource
            if ($data->cbs) {
                require_once "{$data->pth}/includes/cbs-retail.php";
            }

            try {

                // Execute Decidir payment
                $res = $conn->payment()->ExecutePayment($pmnt);
                $payid = $res->getId();
                $status = $res->getStatus();
                $fraud = $res->getFraud_detection();
                $fraud = $fraud['status']['decision'];
                $fraud == 'red' && $status = 'rejected';
                $fraud == 'yellow' && $status = 'review';

                // Process PS data
                if ($status == 'approved' || $status == 'review') {
                    $ost = $modu->getOrderState($status);

                    // Generate order
                    $modu->validateOrder($cart->id, $ost, $total, $data->ttl, null, [], null, false, $cart->secure_key);
                    $oid = Order::getOrderByCartId($cart->id);
                    $ord = new Order($oid);
                    $ord->reference = $refer;
                    $ord->save();

                    // Generate payment
                    $pay = new OrderPayment();
                    $pay->order_reference = $ord->reference;
                    $pay->id_currency = $curr->id;
                    $pay->amount = $total;
                    $pay->payment_method = $data->ttl;
                    $pay->transaction_id = $payid;
                    $pay->card_brand = Tools::getValue('decidir-method-name');
                    $pay->card_expiration = Tools::getValue('decidir-expir');
                    $pay->card_holder = Tools::getValue('decidir-holder');
                    $pay->save();

                    // Show approved view
                    if ($status == 'approved') {
                        //$this->loadPageTemplate('front', 'response', $data);
                        $url = 'index.php?controller=order-confirmation';
                        $url .= '&id_cart='.$cart->id;
                        $url .= '&id_module='.$modu->id;
                        $url .= '&id_order='.$oid;
                        $url .= '&key='.$cust->secure_key;
                        Tools::redirect($url);
                    }
                    if ($status == 'review') {
                        $this->loadPageTemplate('front', 'review', $data);
                    }

                } else if ($status == 'rejected') {
                    $this->loadPageTemplate('front', 'rejected', $data);
                } else if ($status == 'annulled') {
                    $this->loadPageTemplate('front', 'rejected', $data);
                } else {
                    $this->loadPageTemplate('front', 'error', $data);
                }

            } catch(\Exception $e) {

                // Catch Decidir errors
                $data->res = $e->getData();
                $data->res = Tools::jsonEncode($data->res);
                $data->res = Tools::jsonDecode($data->res);
                $this->loadPageTemplate('front', 'error', $data);
            }
        }
    }

    // LOAD PAGE TEMPLATE
    public function loadPageTemplate($ctrl, $tmpl, $data = null)
    {
        $modu = $this->module;
        $name = $modu->name;
        $smrt = $this->context->smarty;
        $smrt->assign('data', $data);
        if ($modu->ps_version < 17) {
            $this->setTemplate("$tmpl.tpl");
        } else {
            $base = "module:$name/views/templates";
            $smrt->assign('tmpl', "$base/$ctrl/$tmpl.tpl");
            $this->setTemplate("$base/include.tpl");
        }
    }
}
