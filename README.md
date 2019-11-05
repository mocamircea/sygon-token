# SYGON token

<p>
<b>Name:</b> SYGON <br/>
<b>Symbol:</b> SYGON <br/>
<b>Type:</b> ERC20<br/>
<b>Decimals:</b> 18 <br/>
<b>Total Initial Supply (TIS):</b> fixed, 7500000000. This is the maximum amount that can be released ever.<br/>
<b>Total Released Quantity (TRQ):</b> total amount ever released from TIS.<br/>
<b>Total Maximum Burnable Quantity (TMBQ):</b> fixed, 6000000000 (representing 80% of the total initial supply). <br/>
<b>Total Burned Quantity (TBQ):</b> total amount of tokens burned so far. Burn applies to TRQ only.<br/>
<b>Total Supply in Circulation (TSC):</b> total token supply that was released and was not burned yet. TSC=TRQ-TBQ <br/>
  <b>Total Remaining Supply to be Released (TRSR):</b> total remaining token supply that can still be distributed from initial supply. TRSR=TIS-TRQ<br/>
</p>

<h2>1 Features</h2>
<p>Fungible, Fractionable, Burnable </p>

<h3>1.1 Transfer</h3>
<p>
  <b><i>transfer</i></b> and <b><i>transferFrom</i></b> as of ERC20
<br/>
  <b><i>transferAsTokenReleaseFromTotalSupply</i></b> <br/>
The Instatiator transfers SYGON tokens as token release action from TIS.<br/>
Token release input: Beneficiary, Amount, Project ID, Expenditure Destination, Installment Number.<br/>
  </p>
  
<h3>1.2 Fractionable</h3>
<p>
The smallest transferrable quantity is 0.000000000000000001 SYGON tokens
  </p>

<h3>1.3 Burnable</h3>
<p> The SYGON token can be burned. <br/>
The burn operation can only be applied to the released quantity of SYGON tokens. <br/>
The burn operation is limited to a maximum (TMBQ). <br/>
The burn operation is restricted for the Instantiator. <br/>
  </p>
