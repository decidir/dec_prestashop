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


<form action="" method="post">
    <div class="row">
        
        <!-- CREDENTIALS -->
        <div class="col-lg-12">
            <div class="panel panel-default form-horizontal">
                <div class="panel-header">
                    <div class="panel-heading">
                        <i class="icon-cogs"></i>
                        <span>{l s='Credentials' mod='decidir'}</span>
                    </div>
                </div>
                <div class="form-wrapper">
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Sandbox' mod='decidir'}</label>
                        <div class="col-lg-9">
                            <span class="switch prestashop-switch fixed-width-lg">
                                <input id="decidir-sbx-on" type="radio" name="decidir-sbx" value="1" {if $data->sbx}checked{/if}>
                                <label for="decidir-sbx-on">{l s='Yes' mod='decidir'}</label>
                                <input id="decidir-sbx-off" type="radio" name="decidir-sbx" value="0" {if !$data->sbx}checked{/if}>
                                <label for="decidir-sbx-off">{l s='No' mod='decidir'}</label>
                                <a class="slide-button btn"></a>
                            </span>
                        </div>
                    </div>
                    <div class="decidir-sbx-off" {if $data->sbx}style="display:none;"{/if}>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Public key' mod='decidir'}</label>
                            <div class="col-lg-8">
                                <input type="text" name="decidir-key-pub" value="{$data->key_pub_prd}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Private key' mod='decidir'}</label>
                            <div class="col-lg-8">
                                <input type="text" name="decidir-key-prv" value="{$data->key_prv_prd}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Site ID' mod='decidir'}</label>
                            <div class="col-lg-8">
                                <input type="text" name="decidir-sid" value="{$data->sid_prd}">
                            </div>
                        </div>
                    </div>
                    <div class="decidir-sbx-on" {if !$data->sbx}style="display:none;"{/if}>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Public key' mod='decidir'} ({l s='Sandbox' mod='decidir'})</label>
                            <div class="col-lg-8">
                                <input type="text" name="decidir-key-pub-sbx" value="{$data->key_pub_sbx}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Private key' mod='decidir'} ({l s='Sandbox' mod='decidir'})</label>
                            <div class="col-lg-8">
                                <input type="text" name="decidir-key-prv-sbx" value="{$data->key_prv_sbx}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Site ID' mod='decidir'} ({l s='Sandbox' mod='decidir'})</label>
                            <div class="col-lg-8">
                                <input type="text" name="decidir-sid-sbx" value="{$data->sid_sbx}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel-footer">
                    <button type="submit" class="btn btn-default pull-right">
                        <i class="process-icon-save"></i>
                        <span>{l s='Save' mod='decidir'}</span>
                    </button>
                </div>
            </div>
        </div>
    
    </div>
    <div class="row">
        
        <!-- CYBERSOURCE -->
        <div class="col-lg-12">
             <div class="panel panel-default form-horizontal">
                <div class="panel-header">
                    <div class="panel-heading">
                        <i class="icon-cogs"></i>
                        <span>{l s='Cybersource' mod='decidir'}</span>
                    </div>
                </div>
                <div class="form-wrapper">
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Enable Cybersource' mod='decidir'}</label>
                        <div class="col-lg-9">
                            <span class="switch prestashop-switch fixed-width-lg">
                                <input id="decidir-cbs-on" type="radio" name="decidir-cbs" value="1" {if $data->cbs}checked{/if}>
                                <label for="decidir-cbs-on">{l s='Yes' mod='decidir'}</label>
                                <input id="decidir-cbs-off" type="radio" name="decidir-cbs" value="0" {if !$data->cbs}checked{/if}>
                                <label for="decidir-cbs-off">{l s='No' mod='decidir'}</label>
                                <a class="slide-button btn"></a>
                            </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Merchant ID' mod='decidir'}</label>
                        <div class="col-lg-8">
                            <input type="text" name="decidir-mrc" value="{$data->mrc}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Vertical' mod='decidir'}</label>
                        <div class="col-lg-8">
                            <select name="decidir-vrt">
                                <option value="retail" {if ($data->vrt == 'retail')}selected{/if}>{l s='Retail' mod='decidir'}</option>
                                <!--<option value="travel" {if ($data->vrt == 'travel')}selected{/if}>{l s='Travel' mod='decidir'}</option>
                                <option value="digital" {if ($data->vrt == 'digital')}selected{/if}>{l s='Digital goods' mod='decidir'}</option>
                                <option value="ticketing" {if ($data->vrt == 'ticketing')}selected{/if}>{l s='Ticketing' mod='decidir'}</option>
                                <option value="services" {if ($data->vrt == 'services')}selected{/if}>{l s='Services' mod='decidir'}</option>-->
                            </select>
                        </div>
                    </div>
                </div>
                <div class="panel-footer">
                    <button type="submit" class="btn btn-default pull-right">
                        <i class="process-icon-save"></i>
                        <span>{l s='Save' mod='decidir'}</span>
                    </button>
                </div>
             </div>
        </div>
        
    </div>
    <div class="row">
        
        <!-- ORDER -->
        <div class="col-lg-12">
            <div class="panel panel-default form-horizontal">
                <div class="panel-header">
                    <div class="panel-heading">
                        <i class="icon-cogs"></i>
                        <span>{l s='Order' mod='decidir'}</span>
                    </div>
                </div>
                <div class="form-wrapper">
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Title' mod='decidir'}</label>
                        <div class="col-lg-8">
                            <input type="text" name="decidir-ttl" value="{$data->ttl}">
                        </div>
                    </div>
                </div>
                <div class="form-wrapper">
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Credit cards' mod='decidir'}</label>
                        <div class="col-lg-8">
                            <select class="decidir-crd" name="decidir-crd[]" multiple>
                                {foreach from=$data->mod->getPaymentMethods() key="i" item="it"}
                                <option value="{$i}">{$it}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Installments' mod='decidir'}</label>
                        <div class="col-lg-8">
                            <select class="decidir-ins" name="decidir-ins[]" multiple>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                                <option value="12">12</option>
                                <option value="13">13</option>
                                <option value="14">14</option>
                                <option value="15">15</option>
                                <option value="16">16</option>
                                <option value="17">17</option>
                                <option value="18">18</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="panel-footer">
                    <button type="submit" class="btn btn-default pull-right">
                        <i class="process-icon-save"></i>
                        <span>{l s='Save' mod='decidir'}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
// Prevent form resend
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}
$('#decidir-sbx-on').on('change', function(){
    var chk = $(this).is(':checked');
    $('.decidir-sbx-on').show();
    $('.decidir-sbx-off').hide();
});
$('#decidir-sbx-off').on('change', function(){
    var chk = $(this).is(':checked');
    $('.decidir-sbx-on').hide();
    $('.decidir-sbx-off').show();
});
var cards = '{$data->crd}'.split(',');
var instl = '{$data->ins}'.split(',');
cards.forEach(function(i){
    $('.decidir-crd option[value="'+i+'"]').prop('selected', 1);
});
instl.forEach(function(i){
    $('.decidir-ins option[value="'+i+'"]').prop('selected', 1);
});
</script>
