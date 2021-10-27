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

<div class="alert alert-danger">
    <strong>{l s='An error occurred while processing your payment. Please check your data' mod='decidir'}.</strong>
    {if ($data->res)}
        {if ($data->res->validation_errors)}
        <ul>
            {foreach from=$data->res->validation_errors item="error"}
                {if $error->code == 'invalid_param'}
                    {if $error->param == 'payment_method_id'}
                    <li>{l s='Payment method invalid. Make sure your card and number are correct' mod='decidir'}.</li>
                    {elseif $error->param == 'bin'}
                    <li>{l s='Credit card invalid. Make sure your card number is correct' mod='decidir'}.</li>
                    {else}
                    <li><b>{l s='Code' mod='decidir'}:</b> {$error->code} | <b>{l s='Detail' mod='decidir'}:</b> {$error->param}</li>
                    {/if}
                {else}
                <li><b>{l s='Code' mod='decidir'}:</b> {$error->code} | <b>{l s='Detail' mod='decidir'}:</b> {$error->param}</li>
                {/if}
            {/foreach}
        </ul>
        {/if}
    {/if}
    <p style="margin-top: 20px;"><a class="btn btn-danger" href="javascript:history.back()">{l s='Return' mod='decidir'}</a></p>
</div>
<script>
// Prevent form resend
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}
</script>
