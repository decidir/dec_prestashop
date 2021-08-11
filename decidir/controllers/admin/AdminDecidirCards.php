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

class AdminDecidirCardsController extends ModuleAdminController
{
    public function __construct()
    {
       parent::__construct();
       $this->bootstrap = true;
       $this->module = new Decidir();
    }
    
    public function initContent()
    {
        parent::initContent();
    }
    
    public function renderList()
    {
        $modu = $this->module;
        $data = $modu->setUp();
        if (Tools::getValue('decidir-add-card')) {
            $this->addCard();
        }
        if (Tools::getValue('decidir-upd-card')) {
            $this->updCard();
        }
        if (Tools::getValue('decidir-del-card')) {
            $cid = (int) Tools::getValue('decidir-del-card');
            $modu->delCard($cid);
        }
        $data->cards = $modu->getCards();
        return $this->module->displayTpl('admin/cards', $data);
    }
    
    // ADD CARD
    public function addCard()
    {
        $mod = $this->module;
        $cid = $mod->addCard(array(
            'name' => pSQL(Tools::getValue('decidir-new-card-name')),
            'id_sps' => (int)Tools::getValue('decidir-new-card-sps'),
            'id_nps' => (int)Tools::getValue('decidir-new-card-nps')
        ));
        if ($cid) {
            $ipt = 'decidir-new-card-logo';
            $dir = 'views/images/cards';
            $mod->imgUpload($ipt, $dir, $cid);
        }
        return $cid;
    }
    
    // UPDATE CARD
    public function updCard()
    {
        $mod = $this->module;
        $cid = (int)Tools::getValue('decidir-upd-card');
        $mod->updCard($cid, array(
            'name' => pSQL(Tools::getValue("decidir-upd-card-name-$cid")),
            'id_sps' => (int)Tools::getValue("decidir-upd-card-sps-$cid"),
            'id_nps' => (int)Tools::getValue("decidir-upd-card-nps-$cid")
        ));
        $ipt = "decidir-upd-card-logo-$cid";
        $dir = 'views/images/cards';
        $mod->imgUpload($ipt, $dir, $cid);
    }
}
