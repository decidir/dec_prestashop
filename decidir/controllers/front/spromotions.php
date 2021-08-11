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

class DecidirSPromotionsModuleFrontController extends ModuleFrontController
{
    public $display_column_left = false;
    public $display_column_right = false;
    public function initContent()
    {
        parent::initContent();
        $this->ajax = true;
    }
    
    public function displayAjax()
    {
        header('Content-Type: application/json');
        $modu = $this->module;
        $data = $modu->setUp();
        
        // PREPARE OUTPUT
        $out = new stdClass();
        $out->ok = 0;
        $out->res = null;
        $out->err = [];
        
        // READ REQUEST BODY
        $ac = Tools::getValue('decidir-action');
        $tk = Tools::getValue('decidir-token');
        $in = file_get_contents('php://input');
        $in = Tools::jsonDecode($in);
        if (!$in) {
            $in = new stdClass();
        }
        
        // PING
        if ($ac == 'ping') {
            $out->ok = 1;
            $out->res = 42;
        }
        
        // GET PROMOTIONS
        if ($ac == 'get-promotion-installments' && $tk == $data->skey) {
            $out->ok = 1;
            $out->res = array();
            $day = date('w');
            $shp = (int) Tools::getValue('shop');
            $bnk = (int) Tools::getValue('bank');
            $crd = 0;
            
            // Get card id from card sps
            $sps = (int) Tools::getValue('card');
            $cdd = $modu->getCards("WHERE id_sps = $sps");
            count($cdd) && $crd = (int) $cdd[0]->id_card;
            
            // Iterate promotions
            foreach ($modu->getPromotions() as $pro) {
                $active = $pro->active;
                $datefr = strtotime($pro->date_from);
                $dateto = strtotime($pro->date_to.' +1 day');
                $has_shop = in_array($shp, $pro->shops);
                $has_card = in_array($crd, $pro->cards);
                $has_bank = in_array($bnk, $pro->banks);
                $has_days = in_array($day, $pro->applicable_days);
                $has_date = $datefr < time() && $dateto > time();
                $ins_taken = array();
                if ($active && $has_shop && $has_card && $has_bank && $has_days && $has_date) {
                    $pid = $pro->id_promotion;
                    $inss = $modu->getPromotionInstallments(true, $pid);
                    foreach ($inss as $ins) {
                        $out->res[] = $ins;
                    }
                }
            }
        }
        
        // SHOW OUTPUT
        $data = Tools::jsonEncode($out);
        echo $data;
    }
}
