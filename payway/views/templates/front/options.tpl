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
                            <label for="decidir-holder">{l s='Holder name' mod='payway'}</label>
                            <input type="text" id="decidir-holder" data-decidir="card_holder_name" name="decidir-holder"
                            class="form-control" value="{$data->fname} {$data->lname}" placeholder="{l s='John Doe' mod='payway'}" required>
                        </div>
                    </div>
                </div>

                <!-- DOC TYPE AND NUMBER-->
                <div class="row">
                    <div class="col-12 col-lg-3">
                        <div class="form-group">
                            <label for="decidir-doc-type">{l s='Document type' mod='payway'}</label>
                            <select id="decidir-doc-type" data-decidir="card_holder_doc_type" name="decidir-doc-type"
                            class="form-control" required>
                                <option value="dni">DNI</option>
                                <option value="cuil">CUIL</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-12 col-lg-9">
                        <div class="form-group">
                            <label for="decidir-doc-number">{l s='Document number' mod='payway'}</label>
                            <input type="text" id="decidir-doc-number" data-decidir="card_holder_doc_number" name="decidir-doc-number"
                            class="form-control" value="" placeholder="********" required>
                        </div>
                    </div>
                </div>

                <!-- CARD NUMBER -->
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <div class="form-group">
                            <label for="decidir-card-number">{l s='Card number' mod='payway'}</label>
                            <input type="text" id="decidir-card-number" class="form-control" name="decidir-card-number-view"
                            value="" placeholder="   " maxlength="24" required>
                            <input type="hidden" data-decidir="card_number" name="decidir-card-number" value="">
                        </div>
                    </div>
                </div>

                <!-- BILLING ADDRESS AND DOOR NUMBER -->
                <div class="row">
                    <div class="col-6 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-address">{l s='Billing Address' mod='payway'}</label>
                            <input type="text" id="decidir-address" class="form-control" name="decidir-address-view"
                            value="" placeholder="   " maxlength="24" required>
                            <input type="hidden" data-decidir="address" name="decidir-address" value="">
                        </div>
                    </div>
                    <div class="col-6 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-door-number">{l s='Altura de calle' mod='payway'}</label>
                            <input type="text" data-decidir="card_holder_door_number" id="decidir-door-number" class="form-control" name="decidir-door-number-view"
                            value="" placeholder="Numero de puerta de facturacion" maxlength="5" required>
                        </div>
                    </div>
                </div>

                <!-- CARD AND ISSUER -->
                <div class="row">
                    <div class="col-12 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-method-id">{l s='Card brand' mod='payway'}</label>
                            <select id="decidir-method-id" data-decidir="type" name="decidir-method-id"
                            class="form-control" required>
                                {foreach from=$data->cards key="i" item="crd"}
                                <option value="{$crd->id_sps}" data-logo="{$data->url}modules/decidir/views/images/cards/{$crd->logo}">{$crd->name}</option>
                                {/foreach}
                            </select>
                        </div>
                        <input type="hidden" id="decidir-method-name" name="decidir-method-name" value="">
                    </div>
                    <div class="col-12 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-issuer-id">{l s='Issuer' mod='payway'}</label>
                            <select id="decidir-issuer-id" name="decidir-issuer-id"
                            class="form-control" required>
                                {foreach from=$data->banks key="i" item="bnk"}
                                <option value="{$bnk->id_bank}" data-logo="{$data->url}modules/decidir/views/images/banks/{$bnk->logo}">{$bnk->name}</option>
                                {/foreach}
                                <option value="0" data-logo="">{l s='Other' mod='payway'}</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- EXPIRATION DATE AND SECURITY CODE -->
                <div class="row">
                    <div class="col-12 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-expir">{l s='Expiration date' mod='payway'}</label>
                            <input type="text" id="decidir-expir" class="form-control" name="decidir-expir"
                            value="" placeholder="{l s='MM/YY' mod='payway'}" maxlength="5" required>
                        </div>
                    </div>
                    <div class="col-12 col-lg-6">
                        <div class="form-group">
                            <label for="decidir-cvv">{l s='Card verification number' mod='payway'}</label>
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
                            <label for="decidir-installments">{l s='Installments' mod='payway'}</label>
                            <select id="decidir-installments" data-decidir="type" name="decidir-installments"
                            class="form-control" required>

                            </select>
                            <input type="hidden" id="decidir-installments-total" name="decidir-installments-total">
                        </div>
                    </div>
                </div>

                <!-- CARD TOKEN -->
                <input type="hidden" id="decidir-pay-token" name="decidir-pay-token" value="">
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
                {l s='Checkout' mod='payway'}
            </button>
        </div>
        {/if}

    </div>
</form>

<script src="https://live.decidir.com/static/v2.5/decidir.js"></script>
{if $data->sbx}
<script>
var decidir_cbs = {(int)$data->cbs};
var decidir_url = "https://developers.decidir.com/api/v2";
var decidir_key = "{$data->key_pub}";
var decidir = new Decidir(decidir_url, !decidir_cbs);
decidir.setTimeout(0);
decidir.setPublishableKey(decidir_key);
</script>
{else}
<script>
var decidir_cbs = {(int)$data->cbs};
var decidir_url = "https://live.decidir.com/api/v2";
var decidir_key = "{$data->key_pub}";
var decidir = new Decidir(decidir_url, !decidir_cbs);
decidir.setTimeout(5000);
decidir.setPublishableKey(decidir_key);
</script>
{/if}

<script>
if (document.readyState != 'loading'){
    setOptionDecidir();
} else {
    document.addEventListener
    ('DOMContentLoaded', setOptionDecidir);
}
function setOptionDecidir() {
    var srv = '{$data->srv nofilter}';
    var cur = '{$data->curs}';
    setTimeout(function(){

        // Manage Installments
        function addInstallment(ipt, cfg = {}) {
            var opt = document.createElement('option');
            var tot = parseFloat('{$data->total}');
            var tos = cfg.installment_to_send;
            var ins = cfg.installment;
            var coe = cfg.coefficient;
            tot = tot * coe;
            var amn = tot;
            amn = (amn / ins).toFixed(2);
            tot = tot.toFixed(2);
            var txt = ins;
            if (ins == 1) {
                txt += " {l s='installment of' mod='payway'}";
            } else {
                txt += " {l s='installments of' mod='payway'}";
            }
            txt += " "+amn+cur+" ("+tot+cur+")";
            $(opt).attr('value', tos);
            $(opt).attr('data-total', tot);
            $(opt).text(txt);
            ipt.append(opt);
            $('#decidir-installments').trigger('change');
        }

        // Manage Promotions
        function installmentPromotions() {
            var ipt = $('#decidir-installments');
            var shp = {$data->shp};
            var mid = $('#decidir-method-id').val();
            var bid = $('#decidir-issuer-id').val();

            ipt.empty();
            $.post(srv+'&decidir-action=get-promotion-installments', {
                shop: shp,
                bank: bid,
                card: mid
            }, function(res){
                ipt.empty();
                if (!res.res.length) {
                    addInstallment(ipt, {
                        installment_to_send: 1,
                        installment: 1,
                        coefficient: 1
                    })
                } else {
                    res.res.forEach(function(a, b){
                        addInstallment(ipt, {
                            installment_to_send: a.installment_to_send,
                            installment: a.installment,
                            coefficient: a.coefficient
                        });
                    });
                }
            });
        }
        $('#decidir-method-id').on('change', installmentPromotions);
        $('#decidir-issuer-id').on('change', installmentPromotions);
        $('#decidir-installments').on('change', function(){
            var ipt = $(this);
            var opt = ipt.find('option:selected');
            var tot = opt.attr('data-total');
            $('#decidir-installments-total').val(tot);
        });

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

        // Manage payment method
        function paymentMethod() {
            var ipt = $('#decidir-method-id');
            ipt.on('change', function(){
                var txt = ipt.find('option:selected').text();
                var lgo = ipt.find('option:selected').attr('data-logo');
                ipt.css('background-image', 'url('+lgo+')');
                $('#decidir-method-name').val(txt);
            }); ipt.trigger('change');
        } paymentMethod();

        // Manage Issuer
        function issuerBank() {
            var ipt = $('#decidir-issuer-id');
            ipt.on('change', function(){
                var lgo = ipt.find('option:selected').attr('data-logo');
                if (lgo) {
                    ipt.css('background-image', "url('"+lgo+"')");
                } else {
                    ipt.css('background-image', "");
                }
            }); ipt.trigger('change');
        } issuerBank();

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

        // VALIDATE AND SUBMIT
        var valid = false;
        var form = document.forms["decidir-form"];
        form.onsubmit = function() {
            $('.decidir-err').hide();
            $('.decidir-invalid').removeClass('decidir-invalid');
            decidir.createToken(form, function(sts, res){
                if (sts == 200 || sts == 201) {
                    valid = true;
                    jQuery('#decidir-pay-token').val(res.id);
                    jQuery('#decidir-card-bin').val(res.bin);
                    form.submit();
                } else {
                    jQuery('.decidir-form-err').text(res.message);
                    return false;
                }
            });
            if (!valid) {
                jQuery('#payment-confirmation button').prop('disabled', 1);
                return false;
            }
        }

    },0);
}
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
#decidir-form input,
#decidir-form select {
    height: auto;
    font-size: 12px;
    padding: 6px 8px;
    border-radius: 3px;
    background-color: #fff;
}
#decidir-form input:focus,
#decidir-form select:focus {
    outline: 1px solid #2fb5d2;
}
#decidir-form select {
    padding: 6px 3px;
}
#decidir-form label {
    font-size: 12px;
}
#decidir-form #decidir-method-id,
#decidir-form #decidir-issuer-id {
    padding-left: 30px;
    background-size: 21px;
    background-repeat: no-repeat;
    background-position: 4px center;
    background-image:  url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MzE5QzczNjhCQTA3MTFFQkE2QUNERkFCMkUyRDVBN0QiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MzE5QzczNjlCQTA3MTFFQkE2QUNERkFCMkUyRDVBN0QiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDozMTlDNzM2NkJBMDcxMUVCQTZBQ0RGQUIyRTJENUE3RCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDozMTlDNzM2N0JBMDcxMUVCQTZBQ0RGQUIyRTJENUE3RCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pgq/hNMAAAAPSURBVHjaYjpz5gxAgAEABNQCZyQYsb8AAAAASUVORK5CYII=');
}
</style>
