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

class AdminDecidirPromotionsController extends ModuleAdminController
{

    public $test = '';
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
        if (Tools::getValue('decidir-add-promotion')) {
            $this->addPromotion();
        }
        if (Tools::getValue('decidir-upd-promotion')) {
            $this->updPromotion();
        }
        if (Tools::getValue('decidir-del-promotion')) {
            $pid = (int) Tools::getValue('decidir-del-promotion');
            $modu->delPromotion($pid);
        }
        $data->shops = Shop::getShops();
        $data->banks = $modu->getBanks();
        $data->cards = $modu->getCards();
        $data->promotions = $modu->getPromotions();
        $data->installments = $modu->getPromotionInstallments();
        return $this->module->displayTpl('admin/promotions', $data);
    }

    // ADD PROMOTION
    public function addPromotion()
    {
        $mod = $this->module;
        $pro = $mod->addPromotion(array(
            'name' => pSQL(Tools::getValue('decidir-new-promotion-name')),
            'active' => (int) Tools::getValue('decidir-new-promotion-active'),
            'banks' => pSQL($mod->getMultiValue('decidir-new-promotion-banks')),
            'cards' => pSQL($mod->getMultiValue('decidir-new-promotion-cards')),
            'shops' => pSQL($mod->getMultiValue('decidir-new-promotion-shops')),
            'position' => (int) Tools::getValue('decidir-new-promotion-position'),
            'date_to' => pSQL($mod->getDateValue("decidir-new-promotion-date-to")),
            'date_from' => pSQL($mod->getDateValue("decidir-new-promotion-date-from")),
            'id_merchant' => pSQL(Tools::getValue('decidir-new-promotion-merchant-id')),
            'applicable_days' => pSQL($mod->getMultiValue('decidir-new-promotion-applicable-days'))
        ));
        $this->addPromotionInstallments($pro);
    }

    // UPDATE PROMOTION
    public function updPromotion()
    {
        $mod = $this->module;
        $pro = (int) Tools::getValue('decidir-upd-promotion');
        $mod->updPromotion($pro, array(
            "name" => pSQL(Tools::getValue("decidir-upd-promotion-name-$pro")),
            "active" => (int) Tools::getValue("decidir-upd-promotion-active-$pro"),
            "banks" => pSQL($mod->getMultiValue("decidir-upd-promotion-banks-$pro")),
            "cards" => pSQL($mod->getMultiValue("decidir-upd-promotion-cards-$pro")),
            "shops" => pSQL($mod->getMultiValue("decidir-upd-promotion-shops-$pro")),
            "position" => (int) Tools::getValue("decidir-upd-promotion-position-$pro"),
            "date_to" => pSQL($mod->getDateValue("decidir-upd-promotion-date-to-$pro")),
            "date_from" => pSQL($mod->getDateValue("decidir-upd-promotion-date-from-$pro")),
            "id_merchant" => pSQL(Tools::getValue("decidir-upd-promotion-merchant-id-$pro")),
            "applicable_days" => pSQL($mod->getMultiValue("decidir-upd-promotion-applicable-days-$pro"))
        ));
        $this->updPromotionInstallments($pro);
    }

    // ADD INSTALLMENTS
    public function addPromotionInstallments($pro)
    {
        $mod = $this->module;
        $rows = Tools::getValue('decidir-new-installment-row');
        for ($i = 0; $i < count($rows); $i++) {
            if ((int) Tools::getValue("decidir-new-del-installment")[$i] == 0) {
                $mod->addPromotionInstallment(array(
                    "id_promotion" => (int) $pro,
                    "tea" => pSQL(Tools::getValue("decidir-new-installment-tea")[$i]),
                    "cft" => pSQL(Tools::getValue("decidir-new-installment-cft")[$i]),
                    "installment" => (int) Tools::getValue("decidir-new-installment-ins")[$i],
                    "coefficient" => pSQL(Tools::getValue("decidir-new-installment-coe")[$i]),
                    "installment_to_send" => (int) Tools::getValue("decidir-new-installment-tos")[$i],
                ));
            }
        }
    }

    // UPDATE INSTALLMENTS
    public function updPromotionInstallments($pro)
    {
        $mod = $this->module;
        $pros = Tools::getValue('decidir-upd-installment-pro');
        $rows = Tools::getValue('decidir-upd-installment-row');
        for ($i = 0; $i < count($rows); $i++) {
            if ($pros[$i] == $pro) {
                $iid = (int) Tools::getValue('decidir-upd-installment-row')[$i];
                if ((int) Tools::getValue("decidir-upd-del-installment")[$i] == 0) {
                    if ($iid == 0) {
                        $mod->addPromotionInstallment(array(
                            "id_promotion" => (int) $pro,
                            "tea" => pSQL(Tools::getValue("decidir-upd-installment-tea")[$i]),
                            "cft" => pSQL(Tools::getValue("decidir-upd-installment-cft")[$i]),
                            "installment" => (int) Tools::getValue("decidir-upd-installment-ins")[$i],
                            "coefficient" => pSQL(Tools::getValue("decidir-upd-installment-coe")[$i]),
                            "installment_to_send" => (int) Tools::getValue("decidir-upd-installment-tos")[$i],
                        ));
                    } else {
                        $mod->updPromotionInstallment($iid, array(
                            "tea" => pSQL(Tools::getValue("decidir-upd-installment-tea")[$i]),
                            "cft" => pSQL(Tools::getValue("decidir-upd-installment-cft")[$i]),
                            "installment" => (int) Tools::getValue("decidir-upd-installment-ins")[$i],
                            "coefficient" => pSQL(Tools::getValue("decidir-upd-installment-coe")[$i]),
                            "installment_to_send" => (int) Tools::getValue("decidir-upd-installment-tos")[$i],
                        ));
                    }
                } else {
                    $mod->delPromotionInstallment($iid);
                }
            }
        }
    }
}
