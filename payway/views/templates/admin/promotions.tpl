{**
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
*}

<form action="" method="post" class="form-horizontal">
    <div class="panel col-lg-12">
        <div class="panel-heading">
            <span>{l s='Promotions' mod='payway'}</span>
            <span class="badge">{count($data->promotions)}</span>
            <span class="panel-heading-action">
                <a href="#" class="list-toolbar-btn decidir-new-promotion">
                    <span title=""
                    data-toggle="tooltip"
                    class="label-tooltip"
                    data-original-title="{l s='Add' mod='payway'}"
                    data-html="true" data-placement="top">
                        <i class="process-icon-new"></i>
                    </span>
                </a>
            </span>
        </div>
        <div class="table-responsive-row decidir-table-promotions">
            <table class="table table-striped">
                <thead>
                    <tr class="nodrag nodrop">
                        <th>{l s='Name' mod='payway'}</th>
                        <th>{l s='Shops' mod='payway'}</th>
                        <th class="center">{l s='Active' mod='payway'}</th>
                        <th class="center fixed-width-xs">{l s='Position' mod='payway'}</th>
                        <th class="center fixed-width-xs">{l s='Action' mod='payway'}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$data->promotions item=promotion}
                    <tr class="decidir-row-promotion" data-id="{$promotion->id_promotion}">
                        <td>
                            {if $promotion->name}
                                {$promotion->name|upper}
                            {else}
                                <em>({l s='empty' mod='payway'})</em>
                            {/if}
                        </td>
                        <td>
                        {foreach from=$data->shops item=shop}
                            {if in_array($shop['id_shop'], $promotion->shops)}
                                {$shop['name']|upper}
                            {/if}
                        {/foreach}
                        </td>
                        <td class="center">
                        {if $promotion->active == 1}
                            {l s='Yes' mod='payway'}
                        {else}
                            {l s='No' mod='payway'}
                        {/if}
                        </td>
                        <td class="center">
                            {$promotion->position|upper}
                        </td>
                        <td class="center fixed-width-xs" style="white-space: nowrap;">
                            <button type="button" name="decidir-cfg-promotion"
                            value="{$promotion->id_promotion}" class="btn btn-sm btn-default">
                                <i class="icon icon-cog"></i>
                                <span>{l s='Edit' mod='payway'}</span>
                            </button>
                            <button type="submit" name="decidir-del-promotion"
                            value="{$promotion->id_promotion}" class="btn btn-sm btn-default">
                                <i class="icon icon-trash"></i>
                                <span>{l s='Delete' mod='payway'}</span>
                            </button>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- NEW PROMOTION -->
    <div id="decidir-new-promotion" class="modal fade" role="dialog">
        <div class="modal-dialog decidir-modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">{l s='New promotion' mod='payway'}</h4>
                </div>
                <div class="modal-body form-wrapper">
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Name -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Name' mod='payway'}</label>
                                <input type="text" name="decidir-new-promotion-name" value="" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Merchant ID -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Merchant ID' mod='payway'}</label>
                                <input type="text" name="decidir-new-promotion-merchant-id" value="" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Cards -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Cards' mod='payway'}</label>
                                <select name="decidir-new-promotion-cards[]" multiple autocomplete="off">
                                    {foreach from=$data->cards item=card}
                                    <option value="{$card->id_card}" selected>{$card->name}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Banks -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Banks' mod='payway'}</label>
                                <select name="decidir-new-promotion-banks[]" multiple autocomplete="off">
                                    {foreach from=$data->banks item=bank}
                                    <option value="{$bank->id_bank}" selected>{$bank->name}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Applicable days -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Applicable days' mod='payway'}</label>
                                <select name="decidir-new-promotion-applicable-days[]" multiple autocomplete="off">
                                    <option value="1" selected>{l s='Monday' mod='payway'}</option>
                                    <option value="2" selected>{l s='Tuesday' mod='payway'}</option>
                                    <option value="3" selected>{l s='Wednesday' mod='payway'}</option>
                                    <option value="4" selected>{l s='Thursday' mod='payway'}</option>
                                    <option value="5" selected>{l s='Friday' mod='payway'}</option>
                                    <option value="6" selected>{l s='Saturday' mod='payway'}</option>
                                    <option value="7" selected>{l s='Sunday' mod='payway'}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Date from -->
                            <div class="form-group decidir-col-form-group decidir-input-icon">
                                <label>{l s='From date' mod='payway'}</label>
                                <input type="text" class="decidir-datepicker"
                                name="decidir-new-promotion-date-from" value="{date('Y-m-d H:i:s')}" autocomplete="off">
                                <i class="icon icon-calendar-empty"></i>
                            </div>
                            <!-- Date to -->
                            <div class="form-group decidir-col-form-group decidir-input-icon">
                                <label>{l s='To date' mod='payway'}</label>
                                <input type="text" class="decidir-datepicker"
                                name="decidir-new-promotion-date-to" value="{date('Y-m-d H:i:s')}" autocomplete="off">
                                <i class="icon icon-calendar-empty"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Shops -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Shops' mod='payway'}</label>
                                <select name="decidir-new-promotion-shops[]" multiple autocomplete="off">
                                    {foreach from=$data->shops item=shop}
                                    <option value="{$shop['id_shop']}" {if $shop['id_shop'] == $data->shp}selected{/if}>{$shop['name']}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Position -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Position' mod='payway'}</label>
                                <input type="text" name="decidir-new-promotion-position" value="0" autocomplete="off">
                            </div>
                            <!-- Active -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Active' mod='payway'}</label>
                                <span class="switch prestashop-switch fixed-width-lg">
                                    <input id="decidir-new-promotion-active-on" type="radio" name="decidir-new-promotion-active" value="1" checked>
                                    <label for="decidir-new-promotion-active-on">{l s='Yes' mod='payway'}</label>
                                    <input id="decidir-new-promotion-active-off" type="radio" name="decidir-new-promotion-active" value="0">
                                    <label for="decidir-new-promotion-active-off">{l s='No' mod='payway'}</label>
                                    <a class="slide-button btn"></a>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Installments -->
                    <div class="panel panel-default">
                        <div class="panel-heading decidir-nobg">
                            <span>{l s='Installments' mod='payway'}</span>
                            <span class="panel-heading-action">
                                <a href="#" class="list-toolbar-btn decidir-new-add-installment">
                                    <span title=""
                                    data-toggle="tooltip"
                                    class="label-tooltip"
                                    data-original-title="{l s='Add' mod='payway'}"
                                    data-html="true" data-placement="top">
                                        <i class="process-icon-new"></i>
                                    </span>
                                </a>
                            </span>
                        </div>
                        <div class="table-responsive-row decidir-table-installments">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>{l s='Installment' mod='payway'}</th>
                                        <th>{l s='Coefficient' mod='payway'}</th>
                                        <th>{l s='%TEA' mod='payway'}</th>
                                        <th>{l s='%CFT' mod='payway'}</th>
                                        <th>{l s='Installment to send' mod='payway'}</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="decidir-ins-rows-new"></tbody>
                            </table>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        <i class="icon-close"></i>
                        <span>{l s='Close' mod='payway'}</span>
                    </button>
                    <button type="submit" name="decidir-add-promotion" value="1"
                    class="btn btn-primary pull-right">
                        <i class="icon-save"></i>
                        <span>{l s='Save' mod='payway'}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- EDIT PROMOTIONS -->
    {foreach from=$data->promotions item=promotion}
    <div id="decidir-modal-promotion-{$promotion->id_promotion}" class="modal fade" role="dialog">
        <div class="modal-dialog decidir-modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">{l s='Edit promotion' mod='payway'}</h4>
                </div>
                <div class="modal-body form-wrapper">
                    
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Name -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Name' mod='payway'}</label>
                                <input type="text" name="decidir-upd-promotion-name-{$promotion->id_promotion}"
                                value="{$promotion->name|escape:'html'}" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Merchant ID -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Merchant ID' mod='payway'}</label>
                                <input type="text" name="decidir-upd-promotion-merchant-id-{$promotion->id_promotion}"
                                value="{$promotion->id_merchant|escape:'html'}" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Cards -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Cards' mod='payway'}</label>
                                <select name="decidir-upd-promotion-cards-{$promotion->id_promotion}[]" multiple autocomplete="off">
                                    {foreach from=$data->cards item=card}
                                    <option value="{$card->id_card}" {if in_array($card->id_card, $promotion->cards)}selected{/if}>{$card->name}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Banks -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Banks' mod='payway'}</label>
                                <select name="decidir-upd-promotion-banks-{$promotion->id_promotion}[]" multiple autocomplete="off">
                                    {foreach from=$data->banks item=bank}
                                    <option value="{$bank->id_bank}" {if in_array($bank->id_bank, $promotion->banks)}selected{/if}>{$bank->name}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Applicable days -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Applicable days' mod='payway'}</label>
                                <select name="decidir-upd-promotion-applicable-days-{$promotion->id_promotion}[]" multiple autocomplete="off">
                                    <option value="1" {if in_array(1, $promotion->applicable_days)}selected{/if}>{l s='Monday' mod='payway'}</option>
                                    <option value="2" {if in_array(2, $promotion->applicable_days)}selected{/if}>{l s='Tuesday' mod='payway'}</option>
                                    <option value="3" {if in_array(3, $promotion->applicable_days)}selected{/if}>{l s='Wednesday' mod='payway'}</option>
                                    <option value="4" {if in_array(4, $promotion->applicable_days)}selected{/if}>{l s='Thursday' mod='payway'}</option>
                                    <option value="5" {if in_array(5, $promotion->applicable_days)}selected{/if}>{l s='Friday' mod='payway'}</option>
                                    <option value="6" {if in_array(6, $promotion->applicable_days)}selected{/if}>{l s='Saturday' mod='payway'}</option>
                                    <option value="7" {if in_array(7, $promotion->applicable_days)}selected{/if}>{l s='Sunday' mod='payway'}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Date from -->
                            <div class="form-group decidir-col-form-group decidir-input-icon">
                                <label>{l s='From date' mod='payway'}</label>
                                <input type="text" class="decidir-datepicker" autocomplete="off"
                                name="decidir-upd-promotion-date-from-{$promotion->id_promotion}" value="{$promotion->date_from|escape:'html'}">
                                <i class="icon icon-calendar-empty"></i>
                            </div>
                            <!-- Date to -->
                            <div class="form-group decidir-col-form-group decidir-input-icon">
                                <label>{l s='To date' mod='payway'}</label>
                                <input type="text" class="decidir-datepicker" autocomplete="off"
                                name="decidir-upd-promotion-date-to-{$promotion->id_promotion}" value="{$promotion->date_to|escape:'html'}">
                                <i class="icon icon-calendar-empty"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-6">
                            <!-- Shops -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Shops' mod='payway'}</label>
                                <select name="decidir-upd-promotion-shops-{$promotion->id_promotion}[]" multiple autocomplete="off">
                                    {foreach from=$data->shops item=shop}
                                    <option value="{$shop['id_shop']}" {if in_array($shop['id_shop'], $promotion->shops)}selected{/if}>{$shop['name']}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <!-- Position -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Position' mod='payway'}</label>
                                <input type="text" name="decidir-upd-promotion-position-{$promotion->id_promotion}"
                                value="{$promotion->position|escape:'html'}" autocomplete="off">
                            </div>
                            <!-- Active -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Active' mod='payway'}</label>
                                <span class="switch prestashop-switch fixed-width-lg">
                                    <input id="decidir-upd-promotion-active-on-{$promotion->id_promotion}"
                                    type="radio" name="decidir-upd-promotion-active-{$promotion->id_promotion}" value="1" {if $promotion->active == 1}checked{/if}>
                                    <label for="decidir-upd-promotion-active-on-{$promotion->id_promotion}">{l s='Yes' mod='payway'}</label>
                                    <input id="decidir-upd-promotion-active-off-{$promotion->id_promotion}"
                                    type="radio" name="decidir-upd-promotion-active-{$promotion->id_promotion}" value="0" {if $promotion->active == 0}checked{/if}>
                                    <label for="decidir-upd-promotion-active-off-{$promotion->id_promotion}">{l s='No' mod='payway'}</label>
                                    <a class="slide-button btn"></a>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Installments -->
                    <div class="panel panel-default">
                        <div class="panel-heading decidir-nobg">
                            <span>{l s='Installments' mod='payway'}</span>
                            <span class="panel-heading-action">
                                <a href="#" class="list-toolbar-btn decidir-upd-add-installment-{$promotion->id_promotion}">
                                    <span title=""
                                    data-toggle="tooltip"
                                    class="label-tooltip"
                                    data-original-title="{l s='Add' mod='payway'}"
                                    data-html="true" data-placement="top">
                                        <i class="process-icon-new"></i>
                                    </span>
                                </a>
                            </span>
                        </div>
                        <div class="table-responsive-row decidir-table-installments">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>{l s='Installment' mod='payway'}</th>
                                        <th>{l s='Coefficient' mod='payway'}</th>
                                        <th>{l s='%TEA' mod='payway'}</th>
                                        <th>{l s='%CFT' mod='payway'}</th>
                                        <th>{l s='Installment to send' mod='payway'}</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="decidir-ins-rows-{$promotion->id_promotion}"></tbody>
                            </table>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        <i class="icon-close"></i>
                        <span>{l s='Close' mod='payway'}</span>
                    </button>
                    <button type="submit" name="decidir-upd-promotion" value="{$promotion->id_promotion}"
                    class="btn btn-primary pull-right">
                        <i class="icon-save"></i>
                        <span>{l s='Save' mod='payway'}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    {/foreach}
</form>

<!-- INSTALLMENT TEMPLATE -->
<script id="decidir-installment-template" type="text/x-custom-template">
<input type="hidden" class="decidir-installment-row" value="1">
<input type="hidden" class="decidir-installment-pro" value="1">
<td class="decidir-installment-row-installment">
    <input type="number" class="form-control" value="1">
</td>
<td class="decidir-installment-row-coefficient">
    <input type="number" step="0.01" class="form-control" value="1.00">
</td>
<td class="decidir-installment-row-tea">
    <input type="number" step="0.01" class="form-control" value="0.00">
</td>
<td class="decidir-installment-row-cft">
    <input type="number" step="0.01" class="form-control" value="0.00">
</td>
<td class="decidir-installment-row-to-send">
    <input type="number" step="1" class="form-control" value="1">
</td>
<td>
    <button type="button" class="
    btn btn-sm btn-default decidir-del-installment">
        <i class="icon icon-trash"></i>
    </button>
    <input type="hidden" class="decidir-del-installment-flag" value="0">
</td>
</script>

<!-- STYLES -->
<style>
@media (max-width: 991px) {
    
    /*Promotions table headings mobile*/
    .decidir-table-promotions td:nth-of-type(1)::before {
        content: "{l s='Name' mod='payway'}";
    }
    .decidir-table-promotions td:nth-of-type(2)::before {
        content: "{l s='Shops' mod='payway'}";
    }
    .decidir-table-promotions td:nth-of-type(3)::before {
        content: "{l s='Active' mod='payway'}";
    }
    .decidir-table-promotions td:nth-of-type(4)::before {
        content: "{l s='Position' mod='payway'}";
    }
    .decidir-table-promotions td:nth-of-type(5)::before {
        content: "{l s='Action' mod='payway'}";
    }
    
    /*Installments table headings mobile*/
    .decidir-table-installments td:nth-of-type(1)::before {
        content: "{l s='Installment' mod='payway'}";
    }
    .decidir-table-installments td:nth-of-type(2)::before {
        content: "{l s='Coefficient' mod='payway'}";
    }
    .decidir-table-installments td:nth-of-type(3)::before {
        content: "{l s='%TEA' mod='payway'}";
    }
    .decidir-table-installments td:nth-of-type(4)::before {
        content: "{l s='%CFT' mod='payway'}";
    }
    .decidir-table-installments td:nth-of-type(7)::before {
        content: "{l s='Installment to send' mod='payway'}";
    }
}
</style>

<!-- SCRIPTS -->
<script>
// Prevent form resend
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}
$('.decidir-new-promotion').on('click', function(){
    var mdl = $('#decidir-new-promotion');
    mdl.modal('show');
});
$('[name="decidir-cfg-promotion"]').on('click', function(){
    var pid = $(this).val();
    var mdl = $('#decidir-modal-promotion-'+pid);
    mdl.modal('show');
});
$('[name="decidir-del-promotion"]').on('click', function(e){
    if (!confirm("{l s='Delete promotion?' mod='payway'}")) {
        return false;
    }
});

$(".decidir-datepicker").datetimepicker({
    prevText: '',
    nextText: '',
    dateFormat: 'yy-mm-dd'
});

// INSTALLMENTS
function decidirAddInstallmentRow(pfx, prn, opt) {
    prn = $(prn)[0];
    
    var tpl = $('#decidir-installment-template').html();
    var row = document.createElement('tr');
    prn.appendChild(row); $(row).html(tpl);
    
    var pro_flag = $(row).find('.decidir-installment-pro');
    var row_flag = $(row).find('.decidir-installment-row');
    var cell_ins = $(row).find('.decidir-installment-row-installment');
    var cell_coe = $(row).find('.decidir-installment-row-coefficient');
    var cell_tea = $(row).find('.decidir-installment-row-tea');
    var cell_cft = $(row).find('.decidir-installment-row-cft');
    var cell_tos = $(row).find('.decidir-installment-row-to-send');
    var del = $(row).find('.decidir-del-installment');
    var del_flag = $(row).find('.decidir-del-installment-flag');
    
    pro_flag.attr('name', 'decidir-'+pfx+'-installment-pro[]');
    row_flag.attr('name', 'decidir-'+pfx+'-installment-row[]');
    del_flag.attr('name', 'decidir-'+pfx+'-del-installment[]');
    
    cell_ins.find('input').attr('name', 'decidir-'+pfx+'-installment-ins[]');
    cell_coe.find('input').attr('name', 'decidir-'+pfx+'-installment-coe[]');
    cell_tea.find('input').attr('name', 'decidir-'+pfx+'-installment-tea[]');
    cell_cft.find('input').attr('name', 'decidir-'+pfx+'-installment-cft[]');
    cell_tos.find('input').attr('name', 'decidir-'+pfx+'-installment-tos[]');
    
    pro_flag.val(opt.pro);
    row_flag.val(opt.iid);
    cell_ins.find('input').val(opt.ins);
    cell_coe.find('input').val(opt.coe);
    cell_tea.find('input').val(opt.tea);
    cell_cft.find('input').val(opt.cft);
    cell_tos.find('input').val(opt.tos);
    
    del.on('click', function(){
        if (confirm("{l s='Delete installment?' mod='payway'}")) {
            $(row).hide();
            $(row).find('.decidir-del-installment-flag').val(1);
        }
    });
    
    return row;
}

// Add installments promotion being created
function decidirAddNewInstallment(pfx, prn, pro) {
    pro = pro || 0;
    decidirAddInstallmentRow(pfx, prn, {
        pro: pro, // Promotion id
        iid: 0, // Installment id
        ins: 1, // Num. of installment
        tos: 1, // Installment to send
        coe: '1.00', // Coefficient
        tea: '0.00', // TEA
        cft: '0.00'  // CFT
    });
}
decidirAddNewInstallment('new', '#decidir-ins-rows-new', 0);
$('.decidir-new-add-installment').on('click', function(){
    decidirAddNewInstallment
    ('new', '#decidir-ins-rows-new', 0);
});

// Add installments promotion being edited
{foreach from=$data->promotions item=promotion}
$('.decidir-upd-add-installment-{$promotion->id_promotion}').on('click', function(){
    var pro = {$promotion->id_promotion};
    decidirAddNewInstallment
    ('upd', '#decidir-ins-rows-'+pro, pro);
});
{/foreach}

// List installments in promotion being edited
{foreach from=$data->installments item=ins}
    decidirAddInstallmentRow('upd', '#decidir-ins-rows-{$ins->id_promotion}', {
        pro: {$ins->id_promotion},
        iid: {$ins->id_installment},
        ins: {$ins->installment},
        tos: {$ins->installment_to_send},
        coe: '{$ins->coefficient}',
        tea: '{$ins->tea}',
        cft: '{$ins->cft}'
    });
{/foreach}
</script>

