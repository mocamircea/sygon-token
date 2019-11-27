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
<p>
The SYGON token implements the business model adopted by SynergyCrowds, with specific mechanisms for monetizing the contribution of sygons to producing knowledge in a decentralzied fashion.
</p>

<p>
  <b>Actors</b><br/><br/>
There are three types of actor that interact with the token: 1) the Creator, 2) the Initial Contributors and 3) Others. The <i>Creator</i> releases SYGON tokens (with a dedicated method) to the <i>Initial Contributors</i> for their contribution to developing the SYGON technology. <i>Others</i> are any other users, holding and transferring tokens for any purpose.
</p>

<br/>
<h1>Features</h1>
<p>The SYGON token is: fungible, fractionable and burnable.</p>

<h2>1 Transfers</h2>

<h3>1.1 <i>transfer</i> and <i>transferFrom</i></h3>
<p>
  As of ERC20, methods are used by any human or machine users to transfer SYGON tokens.<br/>
  The function checks if the the amount is transferred to an <b>alias</b> or a <b>splitter</b>, performing the transfer accordingly.
<br/><br/>
  <b>Aliases</b><br/>
  Aliases are Ethereum addresses that receive a special treatment in relationship with the SYGON token. Any amount transferred to an alias address is directed automatically to a unique address (defined by <i>addrAliasTarget</i>). <br/><br/>
  More specifically, aliases are created by the operational entity (SynergyCrowds company) for all users of the SYGON technology products. The concept of alias can be found under the name of <i>Feed address</i> in the SynergyCrowds platform. This is a unique address that is allocated to any account when successfully upgrading to Level 2.
</p>

  <h3>1.2 <i>transferAsTokenRelease</i></h3>
  <p>
The SYGON token is put into circulation with this method, by the Creator only. This special method of transfer is meant to  release amounts of SYGON tokens directly to Initial Contributors. So the token release is fully covered in contribution. The token is never initially released for investment or speculation purposes (with approaches like ICO / IEO) but only to reward real contributions to building the SYGON technology and its products. However, Initial Contributors will be able to further put tokens on the market by selling them to any other interested parties.
  
INPUT<br/>
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
      The installment ID of the current transfer for a particular Project ID. This is to provide transparency, by allowing anyone to track release transfers according to several milestones, along a roadmap of a project. For example, if the project targets the development of a software component, this approach matches with software development lifecycle, meaning that contribution is rewarded gradually for consecutive releases of a software component.<br/>
    </li>
  </ul>
  <h4>Expenditure Destinations</h4>
   There are five possible expenditure destinations from which three are explicitly defined: [0] DEV (Project Development), [1] PRO (Promotion), [2] OPR (Operational). While DEV destination is explicit, the rest of the destinations are implicit. This means that for a new release, the amount explicitely stated defaultly targets the DEV destination. Consequently, amounts for PRO and OPR destinations are calculated automatically based on their weights and the amount transferred to DEV. 
   
   <br/><br/> All destinations together define the <b>Release Structure</b> (RS). For example, a structure like   RS{0:20,1:30,2:50} means that a transfer of 10000 SYGON tokens is performed to DEV, and consequently, a transfer of 15000 SYGONs to PRO and a transfer of 25000 SYGONs to OPR destinations respectively.
   <br/><br/> Also, there are destinations [3] ED3 and [4] ED4, with an initial weight of 0 (zero). These two destinations are reserved for future implementations.
   <br/><br/> <b>Changing Destinations</b> Only changing the address and weight of destinations [1-4] are allowed to Creator. Changing destinations emits specific events.
   <br/><br/> <b>Reading Destinations</b> Details of any destination can be accessed through a valid name ("DEV", "PRO", "OPR", "ED3", "ED4"). The following attributes can be accessed: destination ID, address and weight.
   <br/><br/>
    <table>
  <tr><td>ID</td><td>Name</td><td>Address</td><td>Weight</td></tr>
  <tr><td>0</td><td>DEV</td><td>Parameter for transfer as token release</td><td>100 (unmutable)</td></tr>
  <tr><td>1</td><td>PRO</td><td>At creation (mutable by Creator)</td><td>150 (mutable by Creator)</td></tr>
  <tr><td>2</td><td>OPR</td><td>At creation (mutable by Creator)</td><td>250 (mutable by Creator)</td></tr>
  <tr><td>3</td><td>ED3</td><td>0 (mutable by Creator)</td><td>0 (mutable by Creator)</td></tr>
  <tr><td>4</td><td>ED4</td><td>0 (mutable by Creator)</td><td>0 (mutable by Creator)</td></tr>
    </table>
    
  </p>
  
  <h3>1.3 <i>transferSplit</i></h3>
  <p>
    This is a special method of token transfer. The function is internal and it is called automatically, when 
    the target address of a transfer is identified as splitter.<br/><br/>
    For an address registered as splitter, this mechanism allows that any amount received through as a transfer is "forwarded" as transfers to other target addresses, according to a predefined split schema.<br/><br/>
  
  <b>Splitters</b><br/>
  A splitter associates an address with a split schema. A split schema defines a set of transfer destinations with weights. This mechanism allows at least two contributors to receive rewards for their contributions.<br/><br/>
  The contributor that creates the splitter is called primary and the second one is called secondary contributor. The secondary contributor can furhter configure the splitter by managing other 5 contributors at choice. <br/><br/>
  Splitters are generally used for automatically sharing the monetization of products among their contributors. <br/><br/>
  
  Any amount of tokens sent to a splitter is automatically distributed among the destinations defined in the split schema.<br/></br>
  Split schema <br/>
  <table>
  <tr><td>Primary</td><td>Secondary</td><td>Managed1</td><td>Managed2</td><td>Managed3</td><td>Managed4</td><td>Managed5</td></tr>
  <tr><td>0</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td></tr>
  </table>
  <br/><br>
  Example:<br/>
  If an application A generates a revenue of 100 tokens, then the contributors of the application A get rewarded through a splitter. The splitter is created by user U1, with a secondary user U2. U2 further adds U3 and U4 (at entries 2 and 3 respectively) in the splitter. Split weights (WSplit) are: WSplit(U1)=30, WSplit(U2)=45, WSplit(U3)=35, WSplit(U4)=20. Any amount of tokens transferred to their splitter will lead to transfers from <i>addrAliasTarget</i> to split destination addresses in the following amounts: U1=30, U2=31.5, U3=24.5 and U4=14. <br/><br/>
  In this way, the monetization of the knowledge produced and delivered by the SYGON technology is transparently distributed among contributors only. The SynergyCrowds company, as an operational entity of the products, has an absolutely equal position with any other contributors, in terms of receiving revenues.<br/><br/>
  Any address in a split schema can be changed with a new one, by its owner.<br/><br/>
  The operating entity can distribute revenues exclusively throught splitters.<br/><br/>
  <b>Configuring a splitter</b><br/><br/>
  The primary contributor can change any destination address and weight in the splitter. The secondary contributor can change the address and weight of the 5 managed destinations.<br/>
  Restriction: successfully transferring to a splitter requires that its weights must be configured correctly, namely the sum of the weights of the last 6 destinations must be 100.
  </p>
  
  <h3>1.4 <i>transferFromAliasTarget</i></h3>
  <p>
    This is a special method of token transfer ensuring that all amounts received to addrAliasTarget are transferred to splitters only. No other destination is possible. This mechanism guarantees to the contributors that all monetization of the delivered knowledge is distributed among them and it is verifiable.<br/>
  Transfers from <i>addrAliasTarget</i> can be performed either directly or delegated.
  </p>
<h2>2 Fractionable</h2>
<p>
    The SYGON token is fractionable. Having 18 decimals, the smallest transferrable amount is 0.000000000000000001 SYGON tokens.
  </p>


<h2>3 Burn</h2>
<p>SYGON tokens can be burned by any token holder, from their balances. Also, a fraction of the collected fees are periodicaly burned (see chapter 4 - Fees).</p>
<p>The burn operation can only be applied to the released quantity of SYGON tokens. </p>
<p>The burn operation is limited to a maximum quantity (TMBQ). </p>
<p>The burn operation is forbidden for the Creator, so that the total supply is not affectable by this operation.</p>

<h2>4 Fees </h2>
  <p>
  Fees are applied to all token transfers, except the initial token release transfers.
  </p>
  <p>
  Fees are calculated based on the amount of transferred tokens and a specific factor applied to the amount.<br/>
  <table>
    <tr>
      <td><b>Amount interval</b></td><td><b>Fee</b></td>
    </tr>
    <tr>
      <td>(0,4000]</td><td>0.05%</td>
    </tr>
    <tr>
      <td>(4000,40000]</td><td>0.005%</td>
    </tr>
    <tr>
      <td> >40000</td><td>0.0005%</td>
    </tr>
    </table>
  </p>
  <p>
  Fees are collected at <i>addrFees</i> and they are periodically distributed - partially to the operator entity (the SynergyCrowds company) and partially burned. The collected fees can be distributed only by using the <i>distributeAndBurnFee</i> function.
  </p>
  <p>The proportion of token burn from the collected fees is established through open vote by sygons and stored in <i>nBurnFromFeeQuota</i>. 
  </p>
