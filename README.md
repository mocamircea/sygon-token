# SYGON token

<p>
<b>Name:</b> SYGON <br/>
<b>Symbol:</b> SYGON <br/>
<b>Type:</b> ERC20<br/>
<b>Decimals:</b> 18 <br/>
<b>Total Initial Supply (TIS):</b> fixed, 7500000000. This is the maximum amount that can be released ever.<br/>
<b>Total Released Quantity (TRQ):</b> total amount ever released from TIS.<br/>
<b>Total Maximum Burnable Quantity (TMBQ):</b> fixed, 6750000000 (representing 90% of the total initial supply). <br/>
<b>Total Burned Quantity (TBQ):</b> total amount of tokens burned so far. Burn applies to TRQ only.<br/>
<b>Total Circulating Supply (TCS):</b> total token supply that was released and was not burned yet. TCS=TRQ-TBQ <br/>
  <b>Total Remaining Supply to be Released (TRSR):</b> total remaining token supply that can still be distributed from initial supply. TRSR=TIS-TRQ<br/>
</p>
<hr/>


<h2>Features</h2>
<p>Fungible, Fractionable, Burnable </p>

<h3>1 Transfer of SYGON tokens</h3>
<p>
  <b><i>transfer</i></b> and <b><i>transferFrom</i></b><br/>
  As of ERC20, methods are used by any human or machine users that hold SYGON tokens.
<br/><br/>
  <b><i>transferAsTokenRelease</i></b> <br/>
The SYGON token is put into circulation with this method, by the Creator. This special method of transfer is meant to  release amounts of SYGON tokens directly to contributors. So the token release is fully covered in contribution, every time. The token is never initially released for investment or speculation purposes but only to reward real contribution to building the SYGON technology and its products. However, contributors that receive SYGON tokens can further put them on the market. So any interested party can purchase it from the market and further get access to the SYGON technology products.<br/><br/>
  
Method INPUT<br/>
  <br/>
  <ul>
    <li>
      <b>Beneficiary</b><br/>
      The address of the contributor to receive the Amount.<br/>
    </li>
    <li>
      <b>Amount</b><br/>
      The amount of SYGON tokens being released from TRSR as reward for the delivered and validated contribution.<br/>
    </li>
    <li>
      <b>Project ID</b><br/>
      The identifier of the project being developed within the SYGON technology/ product.<br/>
    </li>
    <li>
      <b>Installment ID</b><br/>
      The installment ID of the current transfer for a particular Project ID. This is to provide transparency, by tracking transfers according to several milestones, along a roadmap of a project. For example, if the project targets the development of a software component, this approach matches with software development lifecycle, meaning that contribution is rewarded gradually for consecutive releases of a software component.<br/>
    </li>
  </ul>
  <h4>Expenditure Destinations</h4>
   There are three precisely defined expenditure destinations: [0] DEV (Project Development), [1] PRO (Promotion), [2] OPR (Operational). While DEV is explicit, the rest of the destinations are implicit. This means that a particular amount to transfer defaultly targets DEV. Consequently, amounts for PRO and OPR are calculated automatically based on their weights and the transfer amount for DEV. 
   <br/><br/> All destinations together define the release structure (RS). For example, a strtucture like   RS{0:20,1:30,2:50} means that a transfer of 10000 SYGON tokens is performed to DEV, which will further generate a transfer of 15000 SYGONs to PRO and a transfer of 25000 SYGONs to OPR.
   <br/><br/> Also, there are [3] ED3 and [4] ED4, with an initial weight of 0 (zero). These two destinations are left for future implementations.
   <br/><br/> <b>Changing Destinations</b> Only changing the address and weight of destinations [1-4] are allowed, and they are restricted for the Creator. Changing destinations emit specific events.
   <br/><br/> <b>Reading Destinations</b> Destinations can be accessed through a valid destination name ("DEV", "PRO", "OPR", "ED3", "ED4"). Accessible values for: destination ID, address and weight.
   <br/><br/>
    <table>
  <tr><td>ID</td><td>Name</td><td>Address</td><td>Weight</td></tr>
  <tr><td>0</td><td>DEV</td><td>Parameter for transfer as token release</td><td>100 (unmutable)</td></tr>
  <tr><td>1</td><td>PRO</td><td>At instantiation (mutable by Creator)</td><td>150 (mutable by Creator)</td></tr>
  <tr><td>2</td><td>OPR</td><td>At instantiation (mutable by Creator)</td><td>250 (mutable by Creator)</td></tr>
  <tr><td>3</td><td>ED3</td><td>0 (mutable by Creator)</td><td>0 (mutable by Creator)</td></tr>
  <tr><td>4</td><td>ED4</td><td>0 (mutable by Creator)</td><td>0 (mutable by Creator)</td></tr>
    </table>
    
    <b><i>transferSplit</i></b><br/><br/>
    This is a special method of token transfer. The function is internal and it is called automatically, when 
    the target address of a transfer is identified as a splitted address. This mechanism is called splitter.<br/><br/>
    If an address that is registered as splitter, any amount received by the address is "forwarded" as transfers to other target addresses, according to a predefined split schema.
  </p>
  
<h3>2 Fractionable</h3>
<p>
    The SYGON token is fractionable. Having 18 decimals, the smallest transferrable amount is 0.000000000000000001 SYGON tokens.
  </p>

<h3>3 Burnable</h3>
<p> The SYGON token can be burned. <br/>
The burn operation can only be applied to the released quantity of SYGON tokens. <br/>
The burn operation is limited to a maximum (TMBQ). <br/>
The burn operation is restricted for the Creator, so that the total supply is not affectable.<br/>
</p>
