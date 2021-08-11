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

<form action="" method="post" enctype="multipart/form-data" class="form-horizontal">
    <div class="panel col-lg-12">
        <div class="panel-heading">
            <span>{l s='Banks' mod='decidir'}</span>
            <span class="badge">{count($data->banks)}</span>
            <span class="panel-heading-action">
                <a href="#" class="list-toolbar-btn decidir-new-bank">
                    <span title=""
                    data-toggle="tooltip"
                    class="label-tooltip"
                    data-original-title="{l s='Add' mod='decidir'}"
                    data-html="true" data-placement="top">
                        <i class="process-icon-new"></i>
                    </span>
                </a>
            </span>
        </div>
        <div class="table-responsive-row">
            <table class="table table-striped">
                <thead>
                    <tr class="nodrag nodrop">
                        <th>{l s='Name' mod='decidir'}</th>
                        <th class="center fixed-width-xs">{l s='Logo' mod='decidir'}</th>
                        <th class="center fixed-width-xs">{l s='Action' mod='decidir'}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$data->banks item=bank}
                    <tr class="decidir-row-bank" data-id="{$bank->id_bank}">
                        <td>
                            {if $bank->name}
                                {$bank->name|upper}
                            {else}
                                <em>({l s='empty' mod='decidir'})</em>
                            {/if}
                        </td>
                        <td class="center fixed-width-xs">
                            <div class="decidir-bank-logo-view"
                            style="background-image: url('{$data->url}modules/decidir/views/images/banks/{$bank->logo}?{uniqid()}')"></div>
                        </td>
                        <td class="center fixed-width-xs" style="white-space: nowrap;">
                            <button type="button" name="decidir-cfg-bank"
                            value="{$bank->id_bank}" class="btn btn-sm btn-default">
                                <i class="icon icon-cog"></i>
                                <span>{l s='Edit' mod='decidir'}</span>
                            </button>
                            <button type="submit" name="decidir-del-bank"
                            value="{$bank->id_bank}" class="btn btn-sm btn-default">
                                <i class="icon icon-trash"></i>
                                <span>{l s='Delete' mod='decidir'}</span>
                            </button>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- NEW BANK -->
    <div id="decidir-new-bank" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">{l s='New bank' mod='decidir'}</h4>
                </div>
                <div class="modal-body form-wrapper">
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Name -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Name' mod='decidir'}</label>
                                <input type="text" name="decidir-new-bank-name" value="">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Logo -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Logo' mod='decidir'}</label>
                                <input type="file"
                                class="decidir-input-bank-file"
                                id="decidir-new-bank-logo"
                                name="decidir-new-bank-logo"
                                value="" style="display: none;">
                                <div class="input-group">
                                    <input type="text" class="decidir-input-bank-logo-name" readonly="">
                                    <span class="input-group-btn">
                                        <label for="decidir-new-bank-logo" name="submitAddAttachments" class="btn btn-default">
                                            <i class="icon-folder-open"></i>
                                            <span>{l s='Upload image' mod='decidir'}</span>
                                        </label>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        <i class="icon-close"></i>
                        <span>{l s='Close' mod='decidir'}</span>
                    </button>
                    <button type="submit" name="decidir-add-bank" value="1"
                    class="btn btn-primary pull-right">
                        <i class="icon-save"></i>
                        <span>{l s='Save' mod='decidir'}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- EDIT BANKS -->
    {foreach from=$data->banks item=bank}
    <div id="decidir-modal-bank-{$bank->id_bank}" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">{l s='Edit bank' mod='decidir'}</h4>
                </div>
                <div class="modal-body form-wrapper">
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Name -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Name' mod='decidir'}</label>
                                <input type="text" name="decidir-upd-bank-name-{$bank->id_bank}" value="{$bank->name|escape:'html'}">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Name -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Logo' mod='decidir'}</label>
                                <input type="file"
                                class="decidir-input-bank-file"
                                id="decidir-upd-bank-logo-{$bank->id_bank}"
                                name="decidir-upd-bank-logo-{$bank->id_bank}"
                                value="" style="display: none;">
                                <div class="input-group">
                                    <input type="text" class="decidir-input-bank-logo-name" readonly=""
                                    style="background-image: url('{$data->url}modules/decidir/views/images/banks/{$bank->logo}?{uniqid()}')">
                                    <span class="input-group-btn">
                                        <label for="decidir-upd-bank-logo-{$bank->id_bank}"
                                        name="submitAddAttachments" class="btn btn-default">
                                            <i class="icon-folder-open"></i>
                                            <span>{l s='Upload image' mod='decidir'}</span>
                                        </label>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        <i class="icon-close"></i>
                        <span>{l s='Close' mod='decidir'}</span>
                    </button>
                    <button type="submit" name="decidir-upd-bank" value="{$bank->id_bank}"
                    class="btn btn-primary pull-right">
                        <i class="icon-save"></i>
                        <span>{l s='Save' mod='decidir'}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    {/foreach}
</form>
<style>
.decidir-bank-logo-view {
    height: 20px;
    width: 50px;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    background-color: #fff;
    border: 1px solid #ccc;
}
.decidir-input-bank-logo-name {
    background-size: 50px 100%;
    background-repeat: no-repeat;
    padding-left: 60px !important;
}
</style>
<script>
// Prevent form resend
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}
$('.decidir-new-bank').on('click', function(){
    var mdl = $('#decidir-new-bank');
    mdl.modal('show');
});
$('[name="decidir-cfg-bank"]').on('click', function(){
    var bid = $(this).val();
    var mdl = $('#decidir-modal-bank-'+bid);
    mdl.modal('show');
});
$('[name="decidir-del-bank"]').on('click', function(e){
    if (!confirm("{l s='Delete bank?' mod='decidir'}")) {
        return false;
    }
});
$('.decidir-input-bank-file').on('change', function(){
    var ipt = $(this)[0];
    var ipt2 = $(ipt).next()
    .find('.decidir-input-bank-logo-name');
    ipt2.css('background-image', "none");
    decidirReadFdata(ipt, function(d, f){
        ipt2.val(d.name);
        ipt2.css('background-image', "url("+f+")");
    });
});
</script>
