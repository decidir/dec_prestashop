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
        'paymentOptions',
        'displayBackofficeHeader'
    );
    
    public function __construct()
    {
        $this->name = 'decidir';
        $this->displayName = $this->l('Decidir');
        $this->description = $this->l('Prisma Decidir - Payment Gateway');
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
        $this->getKeys($data);
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
        $data->srv = $data->lnk->getModuleLink($this->name, 'spromotions', ['decidir-token' => $data->skey], $data->ssl);
        
        return $data;
    }
    
    // BO HEADER
    public function hookDisplayBackofficeHeader()
    {
        $data = $this->setUp();
        return $this->displayTpl('admin/header', $data);
    }
    
    // CONFIG PAGE
    public function getContent()
    {
        $this->regHooks();
        $data = $this->setUp();
        $this->updateKeys();
        $this->getKeys($data);
        $this->createOrderStates();
        
        // If credentials not set preselect the tab
        $data->tab = Tools::getValue('decidir-tab');
        !$data->tab && (
        !Configuration::get('DECIDIR_KEY_PUB') ||
        !Configuration::get('DECIDIR_KEY_PRV') ||
        !Configuration::get('DECIDIR_KEY_PUB_SBX')||
        !Configuration::get('DECIDIR_KEY_PRV_SBX'))&&
        $data->tab = 'crds';
        
        // Display config
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
        $data->total = $cart->getOrderTotal(true, Cart::BOTH);
        $data->cards = $this->getCards(true);
        $data->banks = $this->getBanks(true);
        $curr = new Currency($cart->id_currency);
        $data->curs = $curr->sign;
        $data->cart = $cart;
        $data->ins = explode(',', $data->ins);
        $data->crd = explode(',', $data->crd);
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
        $data->total = $cart->getOrderTotal(true, Cart::BOTH);
        $data->cards = $this->getCards(true);
        $data->banks = $this->getBanks(true);
        $curr = new Currency($cart->id_currency);
        $data->curs = $curr->sign;
        
        $dnam = $data->ttl;
        $link = $data->pay;
        $tmpl = $this->displayTpl('front/options', $data);
        $option = new \PrestaShop\PrestaShop\Core\Payment\PaymentOption();
        $option->setCallToActionText($dnam);
        $option->setAction($link);
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
    
    // DISPLAY TEMPLATE
    public function displayTpl($tpl, $data = null)
    {
        $name = $this->name;
        $this->context->smarty->assign('data', $data);
        if ($this->ps_version < 17) {
            return $this->display(__FILE__, "/views/templates/$tpl.tpl");
        } else {
            return $this->fetch("module:$name/views/templates/$tpl.tpl");
        }
    }
    
    // INSTALL MODULE
    public function install()
    {
        parent::install();
        $this->regHooks();
        $this->installTabs();
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
        $this->uninstallTabs();
        $this->deleteOrderStates();
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
    
    // INSTALL TABS
    public function installTabs()
    {
        $this->addTab($this->l('Prisma Decidir'));
        $this->addTab($this->l('Promotions'), 'Promotions');
        $this->addTab($this->l('Cards'), 'Cards');
        $this->addTab($this->l('Banks'), 'Banks');
    }
    
    // UNINSTALL TABS
    public function uninstallTabs()
    {
        $dbx = _DB_PREFIX_;
        $sql = "
        SELECT id_tab FROM {$dbx}tab
        WHERE module = '{$this->name}'";
        $tabs = Db::getInstance()->executeS($sql);
        foreach ($tabs as $t) {
            $idt = $t['id_tab'];
            $tab = new Tab($idt);
            $tab->delete();
        }
    }
    
    // ADD MENU TAB
    public function addTab($txt, $cls = '')
    {
        $tnm = 'AdminDecidir';
        $pid = Tab::getIdFromClassName($tnm);
        $tid = Tab::getIdFromClassName($tnm.$cls);
        $lns = Language::getLanguages(false);
        if (!$tid) {
            $tab = new Tab();
            $tab->class_name = $tnm.$cls;
            $tab->module = $this->name;
            $tab->id_parent = 0;
            $cls && $tab->id_parent = $pid;
            $cls && $tab->icon = 'settings';
            foreach($lns as $ln){
                $tab->name[$ln['id_lang']] = $txt;
            }
            $tab->save();
        }
    }
    
    // UPDATE CONFIG KEYS
    private function updateKeys()
    {
        // Sandbox mode
        if (Tools::getIsset('decidir-sbx')) {
            $sbx = trim(Tools::getValue('decidir-sbx'));
            Configuration::updateValue('DECIDIR_SBX', $sbx);
        }
        
        // Production public key
        if (Tools::getIsset('decidir-key-pub')) {
            $key = trim(Tools::getValue('decidir-key-pub'));
            Configuration::updateValue('DECIDIR_KEY_PUB', $key);
        }
        
        // Production private key
        if (Tools::getIsset('decidir-key-prv')) {
            $tkn = trim(Tools::getValue('decidir-key-prv'));
            Configuration::updateValue('DECIDIR_KEY_PRV', $tkn);
        }
        
        // Sandbox public key
        if (Tools::getIsset('decidir-key-pub-sbx')) {
            $key = trim(Tools::getValue('decidir-key-pub-sbx'));
            Configuration::updateValue('DECIDIR_KEY_PUB_SBX', $key);
        }
        
        // Sandbox private key
        if (Tools::getIsset('decidir-key-prv-sbx')) {
            $tkn = trim(Tools::getValue('decidir-key-prv-sbx'));
            Configuration::updateValue('DECIDIR_KEY_PRV_SBX', $tkn);
        }
        
        // Production site ID
        if (Tools::getIsset('decidir-sid')) {
            $sid = trim(Tools::getValue('decidir-sid'));
            Configuration::updateValue('DECIDIR_SID', $sid);
        }
        
        // Sandbox site ID
        if (Tools::getIsset('decidir-sid-sbx')) {
            $sid = trim(Tools::getValue('decidir-sid-sbx'));
            Configuration::updateValue('DECIDIR_SID_SBX', $sid);
        }
        
        // Enable cybersource
        if (Tools::getIsset('decidir-cbs')) {
            $cbs = trim(Tools::getValue('decidir-cbs'));
            Configuration::updateValue('DECIDIR_CBS', $cbs);
        }
        
        // Merchant ID
        if (Tools::getIsset('decidir-mrc')) {
            $cbs = trim(Tools::getValue('decidir-mrc'));
            Configuration::updateValue('DECIDIR_MRC', $cbs);
        }
        
        // Vertical
        if (Tools::getIsset('decidir-vrt')) {
            $vrt = trim(Tools::getValue('decidir-vrt'));
            Configuration::updateValue('DECIDIR_VRT', $vrt);
        }
        
        // Payment option title
        if (Tools::getIsset('decidir-ttl')) {
            $nos = trim(Tools::getValue('decidir-ttl'));
            Configuration::updateValue('DECIDIR_TTL', $nos);
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
        $data->ttl = Configuration::get('DECIDIR_TTL');
        if (!$data->ttl) {
            $data->ttl = $this->paymentMethodName;
        }
        
        // Obtain internal service key
        $data->skey = Configuration::get('DECIDIR_SRV_KEY');
        if (!$data->skey) {
            $data->skey = bin2hex(time().uniqid());
            Configuration::updateValue('DECIDIR_SRV_KEY', $data->skey);
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
            $i = $ost->id_order_state;
            $s = $ost->decidir_state;
            $o = new OrderState($i);
            $o->unremovable = 1;
            $o->deleted = 0;
            $o->save();
            array_push($sts, $s);
        }
        if (!in_array('review', $sts)) {
            $this->createOrderState('review', 'Decidir - Review', true);
        }
        if (!in_array('approved', $sts)) {
            $this->createOrderState('approved', 'Decidir - Approved', true);
        }
        if (!in_array('rejected', $sts)) {
            $this->createOrderState('rejected', 'Decidir - Rejected', true);
        }
        if (!in_array('annulled', $sts)) {
            $this->createOrderState('annulled', 'Decidir - Annulled', true);
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
        $state->unremovable = 1;
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
    
    // DELETE ORDER STATES
    public function deleteOrderStates()
    {
        foreach ($this->getOrderStates() as $ost) {
            $s = $ost->id_order_state;
            $ost = new OrderState($s);
            $ost->deleted = 1;
            $ost->save();
        }
    }
    
    // GET BANKS
    public function getBanks($only_active = false)
    {
        $dbx = _DB_PREFIX_;
        $sql = "SELECT * FROM {$dbx}decidir_banks";
        if ($only_active) {
            $sql .= " WHERE active = 1";
        }
        $res = Db::getInstance()->executeS($sql);
        $res = Tools::jsonEncode($res);
        $res = Tools::jsonDecode($res);
        return $res;
    }
    
    // ADD BANK
    public function addBank($cfg = array())
    {
        $tbl = 'decidir_banks';
        Db::getInstance()->insert($tbl, $cfg);
        $id = Db::getInstance()->Insert_ID();
        Db::getInstance()->update($tbl, array(
        'logo' =>"$id.jpg"), "id_bank = $id");
        return $bid;
    }
    
    // UPDATE BANK
    public function updBank($id = 0, $cfg = array())
    {
        $id = (int) $id;
        $tbl = 'decidir_banks';
        $whr = "id_bank = $id";
        Db::getInstance()->update($tbl, $cfg, $whr);
        return $bid;
    }
    
    // DELETE BANK
    public function delBank($id = 0)
    {
        $id = (int) $id;
        $tbl = 'decidir_banks';
        $whr = "id_bank = $id";
        Db::getInstance()->delete($tbl, $whr);
        $pth = dirname(__FILE__);
        @unlink("$pth/views/images/banks/$id.jpg");
        return $bid;
    }
    
    // GET CARDS
    public function getCards($only_active = false)
    {
        $dbx = _DB_PREFIX_;
        $sql = "SELECT * FROM {$dbx}decidir_cards";
        if ($only_active) {
            $sql .= " WHERE active = 1";
        }
        $res = Db::getInstance()->executeS($sql);
        $res = Tools::jsonEncode($res);
        $res = Tools::jsonDecode($res);
        return $res;
    }
    
    // ADD CARD
    public function addCard($cfg = array())
    {
        $tbl = 'decidir_cards';
        Db::getInstance()->insert($tbl, $cfg);
        $id = Db::getInstance()->Insert_ID();
        Db::getInstance()->update($tbl, array(
        'logo' =>"$id.jpg"), "id_card = $id");
        return $id;
    }
    
    // UPDATE CARD
    public function updCard($id = 0, $cfg = array())
    {
        $id = (int) $id;
        $tbl = 'decidir_cards';
        $whr = "id_card = $id";
        Db::getInstance()->update($tbl, $cfg, $whr);
        return $id;
    }
    
    // DELETE CARD
    public function delCard($id = 0)
    {
        $id = (int) $id;
        $tbl = 'decidir_cards';
        $whr = "id_card = $id";
        Db::getInstance()->delete($tbl, $whr);
        $pth = dirname(__FILE__);
        @unlink("$pth/views/images/cards/$id.jpg");
        return $cid;
    }
    
    // GET PROMOTIONS
    public function getPromotions($only_active = false)
    {
        $prs = array();
        $dbx = _DB_PREFIX_;
        $sql = "SELECT * FROM {$dbx}decidir_promotions";
        if ($only_active) {
            $sql .= " WHERE active = 1";
        }
        $sql .= " ORDER BY position ASC";
        $res = Db::getInstance()->executeS($sql);
        $res = Tools::jsonEncode($res);
        $res = Tools::jsonDecode($res);
        foreach ($res as $r) {
            $r->banks = explode(',', $r->banks);
            $r->cards = explode(',', $r->cards);
            $r->shops = explode(',', $r->shops);
            $r->applicable_days = explode(',', $r->applicable_days);
            array_push($prs, $r);
        }
        return $prs;
    }
    
    // ADD PROMOTION
    public function addPromotion($cfg = array())
    {
        $tbl = 'decidir_promotions';
        Db::getInstance()->insert($tbl, $cfg);
        return Db::getInstance()->Insert_ID();
    }
    
    // UPDATE PROMOTION
    public function updPromotion($id = 0, $cfg = array())
    {
        $id = (int) $id;
        $tbl = 'decidir_promotions';
        $whr = "id_promotion = $id";
        Db::getInstance()->update($tbl, $cfg, $whr);
        return $id;
    }
    
    // DELETE PROMOTION
    public function delPromotion($id = 0)
    {
        $id = (int) $id;
        Db::getInstance()->delete('decidir_installments', "id_promotion = $id");
        Db::getInstance()->delete('decidir_promotions', "id_promotion = $id");
        return $id;
    }
    
    // GET INSTALLMENTS
    public function getPromotionInstallments($arrange = false, $pro = 0)
    {
        $dbx = _DB_PREFIX_;
        $sql = "
        SELECT * FROM {$dbx}decidir_installments";
        $pro && $sql .= "
        WHERE id_promotion = $pro";
        $arrange && $sql .= "
        ORDER BY installment ASC";
        $res = Db::getInstance()->executeS($sql);
        $res = Tools::jsonEncode($res);
        $res = Tools::jsonDecode($res);
        return $res;
    }
    
    // ADD INSTALLMENT
    public function addPromotionInstallment($cfg = array())
    {
        $tbl = 'decidir_installments';
        Db::getInstance()->insert($tbl, $cfg);
        return Db::getInstance()->Insert_ID();
    }
    
    // UPDATE INSTALLMENT
    public function updPromotionInstallment($id = 0, $cfg = array())
    {
        $id = (int) $id;
        $tbl = 'decidir_installments';
        $whr = "id_installment = $id";
        Db::getInstance()->update($tbl, $cfg, $whr);
        return $id;
    }
    
    // DELETE INSTALLMENT
    public function delPromotionInstallment($id = 0)
    {
        $id = (int) $id;
        $tbl = 'decidir_installments';
        $whr = "id_installment = $id";
        Db::getInstance()->delete($tbl, $whr);
        return $id;
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
    
    // UPLOAD IMAGES
    public function imgUpload($ipt, $dir, $nam)
    {
        $out = false;
        if ($fil = @$_FILES[$ipt]) {
            $pth = dirname(__FILE__);
            $dir = "$pth/$dir";
            $fln = $fil['name'];
            $prt = pathinfo($fln);
            $fln = $prt['filename'];
            $tmp = $fil['tmp_name'];
            $typ = strtolower($fil['type']);
            $img = false;
            $typ == 'image/png' &&
            $img = imagecreatefrompng($tmp);
            $typ == 'image/gif' &&
            $img = imagecreatefromgif($tmp);
            $typ == 'image/jpg' &&
            $img = imagecreatefromjpeg($tmp);
            $typ == 'image/jpeg' &&
            $img = imagecreatefromjpeg($tmp);
            if ($img) {
                $pth = "$dir/$nam.jpg";
                @unlink($pth);
                imagejpeg($img, $pth);
            }
            return $pth;
        }
    }
    
    // GET FORM VALUE AND PARSE AS DATE
    public function getDateValue($key)
    {
        $val = Tools::getValue($key);
        $val = new DateTime($val);
        $val = $val->format('Y-m-d H:i:s');
        return $val;
    }
    
    // GET FORM MULTI VALUE AND IMPLODE
    public function getMultiValue($key)
    {
        $val = Tools::getValue($key);
        $val = implode(',', $val);
        return $val;
    }
}
