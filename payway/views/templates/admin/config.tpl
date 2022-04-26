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

{if ($data->tab)}
    {assign var="tab" value=$data->tab}
{else}
    {assign var="tab" value='opts'}
{/if}
<form action="" method="post">
    <input type="hidden" name="decidir-tab" value="{$tab}">
    
    <!-- TABS -->
    <ul class="decidir-tabs nav nav-tabs">
        <li {if ($tab == 'crds')}class="active"{/if} data-sel="spl">
            <a data-toggle="tab" href="#decidir-tab-crds">{l s='Credentials' mod='payway'}</a>
        </li>
        <li {if ($tab == 'opts')}class="active"{/if} data-sel="grp">
            <a data-toggle="tab" href="#decidir-tab-opts">{l s='Options' mod='payway'}</a>
        </li>
    </ul>
    
    <!-- TAB PANELS -->
    <div class="decidir-tab-panel tab-content panel panel-default form-horizontal">
        
        <!-- CREDENTIALS -->
        <div id="decidir-tab-crds" class="tab-pane fade in
        {if ($tab == 'crds')}active{/if}">
            <div class="form-wrapper">
                
                <!-- Sandbox mode -->
                <div class="form-group">
                    <label class="control-label col-lg-3">{l s='Sandbox' mod='payway'}</label>
                    <div class="col-lg-9">
                        <span class="switch prestashop-switch fixed-width-lg">
                            <input id="decidir-sbx-on" type="radio" name="decidir-sbx" value="1" {if $data->sbx}checked{/if}>
                            <label for="decidir-sbx-on">{l s='Yes' mod='payway'}</label>
                            <input id="decidir-sbx-off" type="radio" name="decidir-sbx" value="0" {if !$data->sbx}checked{/if}>
                            <label for="decidir-sbx-off">{l s='No' mod='payway'}</label>
                            <a class="slide-button btn"></a>
                        </span>
                    </div>
                </div>
                
                <!-- Keys Production -->
                <div class="decidir-sbx-off" {if $data->sbx}style="display:none;"{/if}>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Public key' mod='payway'}</label>
                        <div class="col-lg-8">
                            <input type="text" name="decidir-key-pub" value="{$data->key_pub_prd}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Private key' mod='payway'}</label>
                        <div class="col-lg-8">
                            <input type="password" name="decidir-key-prv" value="{$data->key_prv_prd}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Site ID' mod='payway'}</label>
                        <div class="col-lg-8">
                            <input type="text" name="decidir-sid" value="{$data->sid_prd}">
                        </div>
                    </div>
                </div>
                
                <!-- Keys Sandbox -->
                <div class="decidir-sbx-on" {if !$data->sbx}style="display:none;"{/if}>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Public key' mod='payway'} ({l s='Sandbox' mod='payway'})</label>
                        <div class="col-lg-8">
                            <input type="text" name="decidir-key-pub-sbx" value="{$data->key_pub_sbx}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Private key' mod='payway'} ({l s='Sandbox' mod='payway'})</label>
                        <div class="col-lg-8">
                            <input type="password" name="decidir-key-prv-sbx" value="{$data->key_prv_sbx}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Site ID' mod='payway'} ({l s='Sandbox' mod='payway'})</label>
                        <div class="col-lg-8">
                            <input type="text" name="decidir-sid-sbx" value="{$data->sid_sbx}">
                        </div>
                    </div>
                </div>
                
            </div>
            <div class="panel-footer">
                <button
                name="decidir-tab" value="crds"
                type="submit" class="btn btn-default pull-right">
                    <i class="process-icon-save"></i>
                    <span>{l s='Save' mod='payway'}</span>
                </button>
            </div>
        </div>
        
        <!-- CONFIGURATION -->
        <div id="decidir-tab-opts" class="tab-pane fade in
        {if ($tab == 'opts')}active{/if}">
            <div class="form-wrapper">
                
                <!-- Payment option title -->
                <div class="form-wrapper">
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='Payment option title' mod='payway'}</label>
                        <div class="col-lg-8">
                            <input type="text" name="decidir-ttl" value="{$data->ttl}">
                            <div><small><i>*{l s='Text to display in the checkout process' mod='payway'}.</i></small></div>
                        </div>
                    </div>
                </div>
                
                <!-- Merchant ID -->
                <div class="form-group">
                    <label class="control-label col-lg-3">{l s='Merchant ID' mod='payway'}</label>
                    <div class="col-lg-8">
                        <input type="text" name="decidir-mrc" value="{$data->mrc}">
                    </div>
                </div>
                
                <!-- Enable cybersource -->
                <div class="form-group">
                    <label class="control-label col-lg-3">{l s='Enable Cybersource' mod='payway'}</label>
                    <div class="col-lg-9">
                        <span class="switch prestashop-switch fixed-width-lg">
                            <input id="decidir-cbs-on" type="radio" name="decidir-cbs" value="1" {if $data->cbs}checked{/if}>
                            <label for="decidir-cbs-on">{l s='Yes' mod='payway'}</label>
                            <input id="decidir-cbs-off" type="radio" name="decidir-cbs" value="0" {if !$data->cbs}checked{/if}>
                            <label for="decidir-cbs-off">{l s='No' mod='payway'}</label>
                            <a class="slide-button btn"></a>
                        </span>
                    </div>
                </div>
                
                <!-- Vertical -->
                <div class="form-group">
                    <label class="control-label col-lg-3">{l s='Vertical' mod='payway'}</label>
                    <div class="col-lg-8">
                        <select name="decidir-vrt">
                            <option value="retail" {if ($data->vrt == 'retail')}selected{/if}>{l s='Retail' mod='payway'}</option>
                            <!--<option value="travel" {if ($data->vrt == 'travel')}selected{/if}>{l s='Travel' mod='payway'}</option>
                            <option value="digital" {if ($data->vrt == 'digital')}selected{/if}>{l s='Digital goods' mod='payway'}</option>
                            <option value="ticketing" {if ($data->vrt == 'ticketing')}selected{/if}>{l s='Ticketing' mod='payway'}</option>
                            <option value="services" {if ($data->vrt == 'services')}selected{/if}>{l s='Services' mod='payway'}</option>-->
                        </select>
                    </div>
                </div>
                
            </div>
            <div class="panel-footer">
                <button
                name="decidir-tab" value="opts"
                type="submit" class="btn btn-default pull-right">
                    <i class="process-icon-save"></i>
                    <span>{l s='Save' mod='payway'}</span>
                </button>
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
</script>
