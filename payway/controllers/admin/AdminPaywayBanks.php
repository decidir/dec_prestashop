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

class AdminPaywayBanksController extends ModuleAdminController
{

    public $test = '';
    public function __construct()
    {
       parent::__construct();
       $this->bootstrap = true;
       $this->module = new Payway();
    }

    public function initContent()
    {
        parent::initContent();
    }

    public function renderList()
    {
        $modu = $this->module;
        $data = $modu->setUp();
        if (Tools::getValue('decidir-add-bank')) {
            $this->addBank();
        }
        if (Tools::getValue('decidir-upd-bank')) {
            $this->updBank();
        }
        if (Tools::getValue('decidir-del-bank')) {
            $bid = (int) Tools::getValue('decidir-del-bank');
            $modu->delBank($bid);
        }
        $data->banks = $modu->getBanks();
        return $this->module->displayTpl('admin/banks', $data);
    }

    // ADD BANK
    public function addBank()
    {
        $mod = $this->module;
        $bid = $mod->addBank(array(
            'name' => pSQL(Tools::getValue('decidir-new-bank-name'))
        ));
        if ($bid) {
            $ipt = 'decidir-new-bank-logo';
            $dir = 'views/images/banks';
            $mod->imgUpload($ipt, $dir, $bid);
        }
        return $bid;
    }

    // UPDATE BANK
    public function updBank()
    {
        $mod = $this->module;
        $bid = (int)Tools::getValue('decidir-upd-bank');
        $mod->updBank($bid, array(
            'name' => pSQL(Tools::getValue("decidir-upd-bank-name-$bid"))
        ));
        $ipt = "decidir-upd-bank-logo-$bid";
        $dir = 'views/images/banks';
        $bid = $mod->imgUpload($ipt, $dir, $bid);
    }
}
