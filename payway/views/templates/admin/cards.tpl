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
            <span>{l s='Cards' mod='payway'}</span>
            <span class="badge">{count($data->cards)}</span>
            <span class="panel-heading-action">
                <a href="#" class="list-toolbar-btn decidir-new-card">
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
        <div class="table-responsive-row">
            <table class="table table-striped">
                <thead>
                    <tr class="nodrag nodrop">
                        <th>{l s='Name' mod='payway'}</th>
                        <th>{l s='ID SPS' mod='payway'}</th>
                        <th>{l s='ID NPS' mod='payway'}</th>
                        <th class="center fixed-width-xs">{l s='Logo' mod='payway'}</th>
                        <th class="center fixed-width-xs">{l s='Action' mod='payway'}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$data->cards item=card}
                    <tr class="decidir-row-card" data-id="{$card->id_card}">
                        <td>{$card->name|upper}</td>
                        <td>{$card->id_sps}</td>
                        <td>{$card->id_nps}</td>
                        <td class="center fixed-width-xs">
                            <div class="decidir-card-logo-view"
                            style="background-image: url('{$data->url}modules/decidir/views/images/cards/{$card->logo}?{uniqid()}')"></div>
                        </td>
                        <td class="center fixed-width-xs" style="white-space: nowrap;">
                            <button type="button" name="decidir-cfg-card"
                            value="{$card->id_card}" class="btn btn-sm btn-default">
                                <i class="icon icon-cog"></i>
                                <span>{l s='Edit' mod='payway'}</span>
                            </button>
                            <button type="submit" name="decidir-del-card"
                            value="{$card->id_card}" class="btn btn-sm btn-default">
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
    
    <!-- NEW CARD -->
    <div id="decidir-new-card" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">{l s='New card' mod='payway'}</h4>
                </div>
                <div class="modal-body form-wrapper">
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Name -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Name' mod='payway'}</label>
                                <input type="text" name="decidir-new-card-name" value="">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- SPS -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='ID SPS' mod='payway'}</label>
                                <input type="text" name="decidir-new-card-sps" value="">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- NPS -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='ID NPS' mod='payway'}</label>
                                <input type="text" name="decidir-new-card-nps" value="">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Logo -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Logo' mod='payway'}</label>
                                <input type="file"
                                class="decidir-input-card-file"
                                id="decidir-new-card-logo"
                                name="decidir-new-card-logo"
                                value="" style="display: none;">
                                <div class="input-group">
                                    <input type="text" class="decidir-input-card-logo-name" readonly="">
                                    <span class="input-group-btn">
                                        <label for="decidir-new-card-logo" name="submitAddAttachments" class="btn btn-default">
                                            <i class="icon-folder-open"></i>
                                            <span>{l s='Upload image' mod='payway'}</span>
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
                        <span>{l s='Close' mod='payway'}</span>
                    </button>
                    <button type="submit" name="decidir-add-card" value="1"
                    class="btn btn-primary pull-right">
                        <i class="icon-save"></i>
                        <span>{l s='Save' mod='payway'}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- EDIT CARDS -->
    {foreach from=$data->cards item=card}
    <div id="decidir-modal-card-{$card->id_card}" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">{l s='Edit card' mod='payway'}</h4>
                </div>
                <div class="modal-body form-wrapper">
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Name -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Name' mod='payway'}</label>
                                <input type="text" name="decidir-upd-card-name-{$card->id_card}" value="{$card->name|escape:'html'}">
                            </div>
                        </div>
                    </div>
                            
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- SPS -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='ID SPS' mod='payway'}</label>
                                <input type="text" name="decidir-upd-card-sps-{$card->id_card}" value="{$card->id_sps|escape:'html'}">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- NPS -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='ID NPS' mod='payway'}</label>
                                <input type="text" name="decidir-upd-card-nps-{$card->id_card}" value="{$card->id_nps|escape:'html'}">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Logo -->
                            <div class="form-group decidir-col-form-group">
                                <label>{l s='Logo' mod='payway'}</label>
                                <input type="file"
                                class="decidir-input-card-file"
                                id="decidir-upd-card-logo-{$card->id_card}"
                                name="decidir-upd-card-logo-{$card->id_card}"
                                value="" style="display: none;">
                                <div class="input-group">
                                    <input type="text" class="decidir-input-card-logo-name" readonly=""
                                    style="background-image: url('{$data->url}modules/decidir/views/images/cards/{$card->logo}?{uniqid()}')">
                                    <span class="input-group-btn">
                                        <label for="decidir-upd-card-logo-{$card->id_card}"
                                        name="submitAddAttachments" class="btn btn-default">
                                            <i class="icon-folder-open"></i>
                                            <span>{l s='Upload image' mod='payway'}</span>
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
                        <span>{l s='Close' mod='payway'}</span>
                    </button>
                    <button type="submit" name="decidir-upd-card" value="{$card->id_card}"
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
<style>
.decidir-card-logo-view {
    height: 20px;
    width: 50px;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    background-color: #fff;
    border: 1px solid #ccc;
}
.decidir-input-card-logo-name {
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
$('.decidir-new-card').on('click', function(){
    var mdl = $('#decidir-new-card');
    mdl.modal('show');
});
$('[name="decidir-cfg-card"]').on('click', function(){
    var cid = $(this).val()
    var mdl = $('#decidir-modal-card-'+cid);
    mdl.modal('show');
});
$('[name="decidir-del-card"]').on('click', function(e){
    if (!confirm("{l s='Delete card?' mod='payway'}")) {
        return false;
    }
});
$('.decidir-input-card-file').on('change', function(){
    var ipt = $(this)[0];
    var ipt2 = $(ipt).next()
    .find('.decidir-input-card-logo-name');
    ipt2.css('background-image', "none");
    decidirReadFdata(ipt, function(d, f){
        ipt2.val(d.name);
        ipt2.css('background-image', "url("+f+")");
    });
});
</script>
