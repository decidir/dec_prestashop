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

<style>
{if $data->ver == 16}
.icon-AdminDecidir:before {
    content: "";
}
{/if}
.decidir-tab-panel {
    border-top-left-radius: 0!important;
}
.decidir-nobg {
    background: none!important;
}
.decidir-modal-xl {
    min-width: 90%;
    max-width: 1140px;
}
.decidir-col-form-group {
    margin-left: 0!important;
    margin-right: 0!important;
}
.decidir-input-icon input {
    padding-right: 20px;
}
.decidir-input-icon .icon {
    position: absolute;
    right: 0;
    margin-top: -23px;
    margin-right: 17px;
}
.decidir-ipt-sel {
    white-space: nowrap;
}
.decidir-ipt-sel input {
    width: 70%!important;
    display: inline-block!important;
}
.decidir-ipt-sel select {
    width: 30%!important;
    display: inline-block!important;
}
</style>

<script>
// Read file data from input
function decidirReadFdata(ipt, cb) {
    cb = cb || function(){};
    var files = ipt.files;
    Array.from(files).forEach(function(f){
        var size = f.size;
        var reader = new FileReader();
        reader.readAsDataURL(f);
        reader.onloadend = function() {
            data = reader.result;
            cb(f, data);
        };
    });
}
</script>
