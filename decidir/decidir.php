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

class Decidir extends PaymentModule
{
    
    private $hooks = array(
        'payment',
        'paymentReturn',
        'paymentOptions'
    );
    
    public function __construct()
    {
        $this->name = 'decidir';
        $this->displayName = $this->l('Decidir');
        $this->description = $this->l('Prisma Decidir - Gateway de Pago');
        $this->paymentMethodName = $this->l('Credit Card (Decidir)');
        $this->tab = 'payments_gateways';
        $this->version = '1.0.0';
        $this->author = 'IURCO';
        
        $this->need_instance = 0;
        $this->bootstrap = true;
        $this->path = realpath(dirname(__FILE__));
        $this->ps_version = Configuration::get('PS_VERSION_DB');
        $this->ps_version = explode('.', $this->ps_version);
        $this->ps_version = $this->ps_version[0].$this->ps_version[1];
        $this->ps_versions_compliancy = array(
            'min' => '1.6',
            'max' => _PS_VERSION_
        );
        
        parent::__construct();
    }
    
    // DATA USED BY MODULE
    public function setUp()
    {
        $data = new stdClass();
        $data->mod = $this;
        $data->lnk = new Link();
        $data->ctx = Context::getContext();
        $data->pth = $this->path;
        $data->url = _PS_BASE_URL_.__PS_BASE_URI__;
        $data->ver = $this->ps_version;
        $data->lng = $data->ctx->language->id;
        $data->iso = $data->ctx->language->iso_code;
        $data->shp = $data->ctx->shop->id;
        $data->ssl = Tools::usingSecureMode();
        $data->pay = $data->lnk->getModuleLink($this->name, 'payment', [], $data->ssl);
        $this->getKeys($data);
        
        return $data;
    }
    
    // CONFIG PAGE
    public function getContent()
    {
        $this->regHooks();
        $data = $this->setUp();
        $this->updateKeys();
        $this->getKeys($data);
        $this->createOrderStates();
        return $this->displayTpl('admin/config', $data);
    }
    
    // PAYMENT
    public function hookPayment($prms)
    {
        if (!$this->active) {
            return '';
        }
        $prms = Tools::jsonEncode($prms);
        $prms = Tools::jsonDecode($prms);
        $data = $this->setUp();
        if (!$data->key_pub) {
            return '';
        }
        
        $cart = $this->context->cart;
        $cust = new Customer($cart->id_customer);
        $data->fname = $cust->firstname;
        $data->lname = $cust->lastname;
        $data->cart = $prms;
        
        $data->ins = explode(',', $data->ins);
        $data->crd = explode(',', $data->crd);
        $ctrl = 'payment';
        $name = $this->name;
        $link = $data->pay;
        return $this->displayTpl('front/options', $data);
    }
    
    // PAYMENT OPTIONS
    public function hookPaymentOptions($prms)
    {
        if (!$this->active) {
            return [];
        }
        $prms = Tools::jsonEncode($prms);
        $prms = Tools::jsonDecode($prms);
        $data = $this->setUp();
        if (!$data->key_pub) {
            return [];
        }
        
        $cart = $this->context->cart;
        $cust = new Customer($cart->id_customer);
        $data->fname = $cust->firstname;
        $data->lname = $cust->lastname;
        
        $data->ins = explode(',', $data->ins);
        $data->crd = explode(',', $data->crd);
        $ctrl = 'payment';
        $name = $this->name;
        $dnam = $data->ttl;
        $link = $data->pay;
        $tmpl = $this->displayTpl('front/options', $data);
        
        $option = new \PrestaShop\PrestaShop\Core\Payment\PaymentOption();
        $option->setAction($link);
        $option->setCallToActionText($dnam);
        $option->setForm($tmpl);
        return [$option];
    }
    
    // PAYMENT RETURN
    public function hookPaymentReturn($prms)
    {
        if (!$this->active) {
            return '';
        }
        $prms = Tools::jsonEncode($prms);
        $prms = Tools::jsonDecode($prms);
        $data = $this->setUp();
        if ($data->ver == 16) {
            return $this->displayTpl('front/success', $data);
        }
    }
    
    // INSTALL MODULE
    public function install()
    {
        parent::install();
        $this->regHooks();
        Configuration::updateValue('DECIDIR_SBX', 1);
        Configuration::updateValue('DECIDIR_CBS', 1);
        Configuration::updateValue('DECIDIR_VRT', 'retail');
        include "{$this->path}/includes/install.php";
        $this->createOrderStates();
        return true;
    }
    
    // UNINSTALL MODULE
    public function uninstall()
    {
        parent::uninstall();
        include "{$this->path}/includes/uninstall.php";
        $this->deleteKeys();
        return true;
    }
    
    // REGISTER HOOKS
    private function regHooks()
    {
        foreach ($this->hooks as $hook) {
            if (!$this->isRegisteredInHook($hook)) {
                $this->registerHook($hook);
            }
        }
    }
    
    // DISPLAY TEMPLATE
    private function displayTpl($tpl, $data = null)
    {
        $name = $this->name;
        $this->context->smarty->assign('data', $data);
        if ($this->ps_version < 17) {
            return $this->display(__FILE__, "/views/templates/$tpl.tpl");
        } else {
            return $this->fetch("module:$name/views/templates/$tpl.tpl");
        }
    }
    
    // GET CONFIG KEYS
    private function getKeys($data)
    {
        $data->sbx = (int) Configuration::get('DECIDIR_SBX');
        $data->key_pub_prd = Configuration::get('DECIDIR_KEY_PUB');
        $data->key_prv_prd = Configuration::get('DECIDIR_KEY_PRV');
        $data->key_pub_sbx = Configuration::get('DECIDIR_KEY_PUB_SBX');
        $data->key_prv_sbx = Configuration::get('DECIDIR_KEY_PRV_SBX');
        $data->sid_prd = Configuration::get('DECIDIR_SID');
        $data->sid_sbx = Configuration::get('DECIDIR_SID_SBX');
        $data->key_pub = $data->key_pub_prd;
        $data->key_prv = $data->key_prv_prd;
        $data->sid = $data->sid_prd;
        if ($data->sbx) {
            $data->key_pub = $data->key_pub_sbx;
            $data->key_prv = $data->key_prv_sbx;
            $data->sid = $data->sid_sbx;
        }
        $data->cbs = Configuration::get('DECIDIR_CBS');
        $data->mrc = Configuration::get('DECIDIR_MRC');
        $data->vrt = Configuration::get('DECIDIR_VRT');
        $data->crd = Configuration::get('DECIDIR_CRD');
        $data->ins = Configuration::get('DECIDIR_INS');
        $data->ttl = Configuration::get('DECIDIR_TTL');
        if (!$data->ttl) {
            $data->ttl = $this->paymentMethodName;
        }
    }
    
    // UPDATE CONFIG KEYS
    private function updateKeys()
    {
        if (Tools::getIsset('decidir-sbx')) {
            $sbx = trim(Tools::getValue('decidir-sbx'));
            Configuration::updateValue('DECIDIR_SBX', $sbx);
        }
        if (Tools::getIsset('decidir-key-pub')) {
            $key = trim(Tools::getValue('decidir-key-pub'));
            Configuration::updateValue('DECIDIR_KEY_PUB', $key);
        }
        if (Tools::getIsset('decidir-key-prv')) {
            $tkn = trim(Tools::getValue('decidir-key-prv'));
            Configuration::updateValue('DECIDIR_KEY_PRV', $tkn);
        }
        if (Tools::getIsset('decidir-key-pub-sbx')) {
            $key = trim(Tools::getValue('decidir-key-pub-sbx'));
            Configuration::updateValue('DECIDIR_KEY_PUB_SBX', $key);
        }
        if (Tools::getIsset('decidir-key-prv-sbx')) {
            $tkn = trim(Tools::getValue('decidir-key-prv-sbx'));
            Configuration::updateValue('DECIDIR_KEY_PRV_SBX', $tkn);
        }
        if (Tools::getIsset('decidir-sid')) {
            $sid = trim(Tools::getValue('decidir-sid'));
            Configuration::updateValue('DECIDIR_SID', $sid);
        }
        if (Tools::getIsset('decidir-sid-sbx')) {
            $sid = trim(Tools::getValue('decidir-sid-sbx'));
            Configuration::updateValue('DECIDIR_SID_SBX', $sid);
        }
        if (Tools::getIsset('decidir-cbs')) {
            $cbs = trim(Tools::getValue('decidir-cbs'));
            Configuration::updateValue('DECIDIR_CBS', $cbs);
        }
        if (Tools::getIsset('decidir-mrc')) {
            $cbs = trim(Tools::getValue('decidir-mrc'));
            Configuration::updateValue('DECIDIR_MRC', $cbs);
        }
        if (Tools::getIsset('decidir-vrt')) {
            $vrt = trim(Tools::getValue('decidir-vrt'));
            Configuration::updateValue('DECIDIR_VRT', $vrt);
        }
        if (Tools::getIsset('decidir-crd')) {
            $crd = implode(',', Tools::getValue('decidir-crd'));
            Configuration::updateValue('DECIDIR_CRD', $crd);
        }
        if (Tools::getIsset('decidir-ins')) {
            $ins = implode(',', Tools::getValue('decidir-ins'));
            Configuration::updateValue('DECIDIR_INS', $ins);
        }
        if (Tools::getIsset('decidir-ttl')) {
            $nos = trim(Tools::getValue('decidir-ttl'));
            Configuration::updateValue('DECIDIR_TTL', $nos);
        }
    }
    
    // DELETE CONFIG KEYS
    private function deleteKeys()
    {
        Configuration::deleteByName('DECIDIR_SBX');
        Configuration::deleteByName('DECIDIR_KEY_PUB');
        Configuration::deleteByName('DECIDIR_KEY_PUB_SBX');
        Configuration::deleteByName('DECIDIR_KEY_PRV');
        Configuration::deleteByName('DECIDIR_KEY_PRV_SBX');
        Configuration::deleteByName('DECIDIR_SID');
        Configuration::deleteByName('DECIDIR_SID_SBX');
        Configuration::deleteByName('DECIDIR_CBS');
        Configuration::deleteByName('DECIDIR_MRC');
        Configuration::deleteByName('DECIDIR_VRT');
        Configuration::deleteByName('DECIDIR_CRD');
        Configuration::deleteByName('DECIDIR_INS');
        Configuration::deleteByName('DECIDIR_TTL');
    }
    
    // GET ORDER STATES
    public function getOrderStates()
    {
        $data = $this->setUp();
        $dbx = _DB_PREFIX_;
        $sql = "
        SELECT
            id_order_state,
            decidir_state
        FROM {$dbx}order_state
        WHERE module_name = 'decidir';";
        $res = Db::getInstance()->executeS($sql);
        $res = Tools::jsonEncode($res);
        $res = Tools::jsonDecode($res);
        return $res;
    }
    
    // GET ORDER STATE
    public function getOrderState($id)
    {
        $ost = 0;
        $osts = $this->getOrderStates();
        foreach ($osts as $os) {
            if ($os->decidir_state == $id) {
                $ost = $os->id_order_state;
            }
        }
        return (int) $ost;  
    }
    
    // CREATE ORDER STATES
    public function createOrderStates()
    {
        $sts = array();
        foreach ($this->getOrderStates() as $ost) {
            $s = $ost->decidir_state;
            array_push($sts, $s);
        }
        if (!in_array('approved', $sts)) {
            $this->createOrderState('approved', 'Decidir - Approved', true);
        }
    }
    
    // CREATE ORDER STATE
    private function createOrderState($id, $name, $paid = false)
    {
        $data = $this->setUp();
        $dbx = _DB_PREFIX_;
        $state = new OrderState();
        $state->name = array();
        foreach (Language::getLanguages() as $lang) {
            $l = $lang['id_lang'];
            $state->name[$l] = $name;
        }
        $state->module_name = 'decidir';
        $state->color = '#19396C';
        $state->unremovable = false;
        $state->paid = $paid;
        $dir = _PS_ROOT_DIR_;
        if ($state->add()) {
            $file = $dir.'/img/os/'.$state->id.'.gif';
            copy($data->pth.'/logo.gif', $file);
        }
        $sql = "
        UPDATE {$dbx}order_state
        SET decidir_state = '$id'
        WHERE id_order_state = {$state->id};";
        Db::getInstance()->execute($sql);
    }
    
    // GET PAYMENT METHODS
    public function getPaymentMethods()
    {
        $methods = array();
        $methods['31'] = 'Visa Débito';
        $methods['66'] = 'MasterCard Debit';
        $methods['67'] = 'Cabal Débito';
        $methods['1'] = 'Visa';
        $methods['15'] = 'MasterCard';
        $methods['65'] = 'American Express';
        $methods['8'] = 'Diners Club';
        $methods['27'] = 'Cabal';
        $methods['23'] = 'Tarjeta Shopping';
        $methods['24'] = 'Tarjeta Naranja';
        $methods['39'] = 'Tarjeta Nevada';
        $methods['42'] = 'Nativa';
        $methods['43'] = 'Tarjeta Más';
        $methods['44'] = 'Tarjeta Carrefour / Cetelem';
        $methods['56'] = 'Tarjeta Club Día';
        $methods['61'] = 'Tarjeta La Anónima';
        $methods['30'] = 'ArgenCard';
        $methods['99'] = 'Maestro';
        $methods['54'] = 'Grupar';
        $methods['59'] = 'Tuya';
        $methods['103'] = 'Favacard';
        $methods['29'] = 'Italcred';
        $methods['37'] = 'Nexo';
        $methods['45'] = 'Tarjeta PymeNacion';
        $methods['50'] = 'BBPS';
        $methods['52'] = 'Qida';
        $methods['55'] = 'Patagonia 365';
        $methods['60'] = 'Distribution';
        $methods['64'] = 'Tarjeta SOL';
        $methods['25'] = 'PagoFacil';
        $methods['26'] = 'RapiPago';
        $methods['48'] = 'Caja de Pagos';
        $methods['51'] = 'Cobro Express';
        return $methods;
    }
    
    // API REQUESTS
    public function callAPI($ept = '', $prm = array())
    {
        $data = $this->setUp();
        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://developers.decidir.com/api/v2/{$ept}",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => Tools::jsonEncode($prm),
            CURLOPT_HTTPHEADER => array(
                "apikey: {$data->key_prv}",
                "cache-control: no-cache",
                "content-type: application/json"
            ),
        ));
        $res = curl_exec($curl);
        $res = Tools::jsonDecode($res);
        curl_close($curl);
        return $res;
    }
}
