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

<h3>1.1 Transfer of SYGON tokens</h3>
<p>
  <b><i>transfer</i></b> and <b><i>transferFrom</i></b><br/>
  As of ERC20, methods are used by any human or machine users that hold SYGON tokens.
<br/><br/>
  <b><i>transferAsTokenReleaseFromTotalSupply</i></b> <br/>
The SYGON token is put into circulation with this method, by the Instantiator. This special method of transfer is meant to  release amounts of SYGON tokens directly to contributors. So the token release is fully covered in contribution, every time. The token is never initially released for investment or speculation purposes but only to reward real contribution to building the SYGON technology and its products. However, contributors that receive SYGON tokens can further put them on the market. So any interested party can purchase it from the market and further get access to the SYGON technology products.<br/><br/>
  
Method INPUT<br/>
  <br/>
  <ul>
    <li>
      <b>Benefficiary</b><br/>
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
      <b>Expenditure Destination</b><br/>
      The identifier of the expenditure destination for the current transfer. For example, there are three current expenditure destinations: [0] DEV (Project Development), [1] PRO (Promotion), [2] OPR (Operational). DEV explicit, the rest of the destinations implicit. This means that for a particular transfer to DEV, amounts for PRO and OPR are calculated automatically based on the amount for DEV. All destinations together define the release structure (RS). For example, a strtucture like   RS{0:20,1:30,2:50} means that a transfer of 10000 SYGON tokens to DEV will generate a transfer of 15000 SYGONs to PRO and a transfer of 25000 SYGONs to OPR.<br/>
    </li>
    <li>
      <b>Installment Number</b><br/>
      The installment number of the current transfer for a particular Project ID + Expenditure Destination. This is to provide transparency, by tracking transfers along several milestones, along a roadmap of a project. For example, if the project targets the development of a software component, this approach matches with software development lifecycle, meaning that contribution is rewarded gradually for consecutive releases of a software component.<br/>
    </li>
  </ul>
  
  
  </p>
  
<h3>1.2 Fractionable</h3>
<p>
    The SYGON token is fractionable. Having 18 decimals, the smallest transferrable amount is 0.000000000000000001 SYGON tokens.
  </p>

<h3>1.3 Burnable</h3>
<p> The SYGON token can be burned. <br/>
The burn operation can only be applied to the released quantity of SYGON tokens. <br/>
The burn operation is limited to a maximum (TMBQ). <br/>
The burn operation is restricted for the Instantiator. <br/>
  </p>
