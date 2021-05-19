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

<form id="decidir-form" action="{$data->pay|escape:'htmlall':'UTF-8'}" method="post">
    <div class="decidir-panel">
        <h3>{$data->ttl|escape:'htmlall':'UTF-8'}</h3>
        <hr {if ($data->ver == 17)}style="margin: 10px 0;"{/if}>
        <div {if ($data->ver < 17)}class="row"{/if}>
            <div class="col-12 {if ($data->ver < 17)}col-lg-6{/if}">
                
                <!-- HOLDER NAME -->
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <div class="form-group">
                            <label for="decidir-holder">{l s='Holder name' mod='decidir'}</label>
                            <input type="text" id="decidir-holder" data-decidir="card_holder_name" name="decidir-holder"
                            class="form-control" value="{$data->fname} {$data->lname}" placeholder="{l s='John Doe' mod='decidir'}" required>
                        </div>
                    </div>
                </div>
                
                <!-- DOC TYPE AND NUMBER-->
                <div class="row">
                    <div class="col-12 col-lg-3">
                        <div class="form-group">
                            <label for="decidir-doc-type">{l s='Document type' mod='decidir'}</label>
                            <select id="decidir-doc-type" data-decidir="card_holder_doc_type" name="decidir-doc-type"
                            class="form-control" required>
                                <option value="dni">DNI</option>
                                <option value="cuil">CUIL</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-12 col-lg-9">
                        <div class="form-group">
                            <label for="decidir-doc-number">{l s='Document number' mod='decidir'}</label>
                            <input type="text" id="decidir-doc-number" data-decidir="card_holder_doc_number" name="decidir-doc-number"
                            class="form-control" value="" placeholder="********" required>
                        </div>
                    </div>
                </div>
                
                <!-- CARD NUMBER -->
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <div class="form-group">
                            <label for="decidir-card-number">{l s='Credit card number' mod='decidir'}</label>
                            <input type="text" id="decidir-card-number" class="form-control"
                            value="" placeholder="**** **** **** ****" maxlength="24" required>
                            <input type="hidden" data-decidir="card_number" name="decidir-card-number" value="">
                        </div>
                    </div>
                </div>
                
                <!-- PAYMENT METHOD -->
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <div class="form-group">
                            <label for="decidir-card-number">{l s='Issuer' mod='decidir'}</label>
                            <select id="decidir-method-id" data-decidir="type" name="decidir-method-id"
                            class="form-control" required>
                                {foreach from=$data->mod->getPaymentMethods() key="i" item="it"}
                                    {if (in_array($i, $data->crd))}
                                    <option value="{$i}">{$it}</option>
                                    {/if}
                                {/foreach}
                            </select>
                        </div>
                        <input type="hidden" id="decidir-method-name" name="decidir-method-name" value="">
                    </div>
                </div>
                
                <!-- EXPIRATION DATE AND SECURITY CODE -->
                <div class="row">
                    <div class="col-12 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-expir">{l s='Expiration date' mod='decidir'}</label>
                            <input type="text" id="decidir-expir" class="form-control" name="decidir-expir"
                            value="" placeholder="{l s='MM/YY' mod='decidir'}" maxlength="5" required>
                        </div>
                    </div>
                    <div class="col-12 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-cvv">{l s='Card verification number' mod='decidir'}</label>
                            <input id="decidir-cvv" name="decidir-cvv" data-decidir="security_code"
                            class="form-control" type="text" value="" placeholder="***" maxlength="4" required>
                        </div>
                    </div>
                    <input type="hidden" data-decidir="card_expiration_month" name="decidir-expir-m" value="">
                    <input type="hidden" data-decidir="card_expiration_year" name="decidir-expir-y" value="">
                </div>
                
                <!-- INSTALLMENTS -->
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <div class="form-group">
                            <label for="decidir-installments">{l s='Installments' mod='decidir'}</label>
                            <select id="decidir-installments" data-decidir="type" name="decidir-installments"
                            class="form-control" required>
                                {foreach from=$data->ins item=i}
                                <option value="{$i}">{$i}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- CARD TOKEN -->
                <input type="hidden" id="decidir-card-token" name="decidir-card-token" value="">
                <input type="hidden" id="decidir-card-bin" name="decidir-card-bin" value="">
                
                <!-- ERROR MESSAGE -->
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <div class="form-group">
                            <div class="decidir-form-err"></div>
                        </div>
                    </div>
               </div>
                
            </div>
        </div>
        
        {if ($data->ver == 16)}
        <!-- SUBMIT -->
        <div>
            <button type="submit"
            class="btn btn-primary">
                {l s='Checkout' mod='decidir'}
            </button>
        </div>
        {/if}
        
    </div>
</form>

<script src="https://live.decidir.com/static/v2.5/decidir.js"></script>
{if $data->sbx}
<script>
var decidir_url = "https://developers.decidir.com/api/v2";
var decidir_key = "{$data->key_pub}";
var decidir = new Decidir(decidir_url);
decidir.setTimeout(0);
decidir.setPublishableKey(decidir_key);
</script>
{else}
<script>
var decidir_url = "https://live.decidir.com/api/v2";
var decidir_key = "{$data->key_pub}";
var decidir = new Decidir(decidir_url);
decidir.setTimeout(5000);
decidir.setPublishableKey(decidir_key);
</script>
{/if}

<script>
setTimeout(function(){
    
    // Manage doc number
    function docNumber() {
        var ipt = $('#decidir-doc-number');
        function mask() {
            var el = $(this);
            $(el).val($(el).val().replace(/\s/g, ''));
            $(el).val($(el).val().replace(/-/g, ''));
            $(el).val($(el).val().replace(/\./g, ''));
            $(el).val($(el).val().replace(/[a-zA-Z]/g, ''));
            $(el).val($(el).val().trim());
        }
        ipt.on('keyup', mask);
        ipt.on('change', mask);
        ipt.trigger('change');
    } docNumber();
    
    // Manage card number
    function cardNumber() {
        var ipt = $('#decidir-card-number');
        function mask() {
            var el = $(this);
            $(el).val($(el).val().replace(/\s/g, ''));
            $(el).val($(el).val().replace(/-/g, ''));
            $(el).val($(el).val().replace(/\./g, ''));
            $(el).val($(el).val().replace(/[a-zA-Z]/g, ''));
            var chr = $(el).val().split('');
            if (chr.length > 4) chr.splice(4, 0, ' ');
            if (chr.length > 8) chr.splice(9, 0, ' ');
            if (chr.length > 12) chr.splice(14, 0, ' ');
            if (chr.length > 16) chr.splice(19, 0, ' ');
            var val = chr.join('').trim();
            $(el).val(val);
            val = val.replace(/\s+/g, '');
            $('[name="decidir-card-number"]').val(val);
        }
        ipt.on('keyup', mask);
        ipt.on('change', mask);
        ipt.trigger('change');
    } cardNumber();
    
    // Manage card expiration
    function cardExpiration() {
        var ipt = $('#decidir-expir');
        function mask() {
            var el = $(this);
            $(el).val($(el).val().replace(/-/g, ''));
            $(el).val($(el).val().replace(/\//g, ''));
            $(el).val($(el).val().replace(/[a-zA-Z]/g, ''));
            var chr = $(el).val().split('');
            if (chr.length > 2) {
                chr.splice(2, 0, '/');
            }
            var val = chr.join('').trim();
            $(el).val(val);
            val = val.split('/');
            $('[name="decidir-expir-m"]').val(val[0]||'');
            $('[name="decidir-expir-y"]').val(val[1]||'');
        }
        ipt.on('keyup', mask);
        ipt.on('change', mask);
        ipt.trigger('change');
    } cardExpiration();
    
    // Manage CVV
    function cardCVV() {
        var ipt = $('#decidir-cvv');
        function mask() {
            var el = $(this);
            $(el).val($(el).val().replace(/\s/g, ''));
            $(el).val($(el).val().replace(/[a-zA-Z]/g, ''));
        }
        ipt.on('keyup', mask);
        ipt.on('change', mask);
        ipt.trigger('change');
    } cardCVV();
    
    // Manage payment method
    function paymentMethod() {
        var ipt = $('#decidir-method-id');
        ipt.on('change', function(){
            var txt = ipt.find('option:selected').text();
            $('#decidir-method-name').val(txt);
        }); ipt.trigger('change');
    } paymentMethod();
    
    // VALIDATE AND SUBMIT
    var decidir_valid = false;
    var form = document.forms["decidir-form"];
    form.onsubmit = function() {
        $('.decidir-err').hide();
        $('.decidir-invalid').removeClass('decidir-invalid');
        decidir.createToken(form, function(sts, res){
            if (sts == 200 || sts == 201) {
                decidir_valid = true;
                jQuery('#decidir-card-token').val(res.id);
                jQuery('#decidir-card-bin').val(res.bin);
                form.submit();
            } else {
                jQuery('.decidir-form-err').text(res.message);
                return false;
            }
        });
        if (!decidir_valid) {
            jQuery('#payment-confirmation button').prop('disabled', 1);
            return false;
        }
    }
    
}, 0);
</script>

<style>
.decidir-panel {
    border: 1px solid #cccccc;
    border-radius: 4px;
    padding: 25px 20px 20px;
    margin: 0 0 10px;
}
.decidir-panel h3 {
    margin-top: 0;
    color: #222222;
    font-size: 18px;
    font-weight: bold; 
    text-transform: uppercase;
}
.decidir-panel .decidir-invalid {
    border: 1px solid red;
}
.decidir-err {
    color: red;
}
</style>
