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

The SYGON token implements the SynergyCrowds business model, with a strong focus on monetizing the contribution of sygons to producing knowledge with a decentralzied approach.
<br/>
<h2>Features</h2>
<p>The SYGON token is: fungible, fractionable and burnable.</p>

<h3>1 Transfers</h3>

<h4>1.1 <i>transfer</i> and <i>transferFrom</i></h4>
<p>
  As of ERC20, methods are used by any human or machine users that hold SYGON tokens.<br/>
  Additional functionality checks if the transfers target <b>aliases</b> or <b>splitters</b>, performing the transfer accordingly.
<br/><br/>
  <b>Aliases</b><br/>
  Aliases are Ethereum addresses that receive a special treatment in relationship with the SYGON token. Any amount sent to an alias address is directed automatically to a unique address (defined by <i>addrAliasTarget</i>). Aliases are created by the operational entity (SynergyCrowds company) for users. The alias is called <i>Feed address</i> in the SynergyCrowds platform, being allocated to accounts when upgraded to Level 2.
</p>

  <h4>1.2 <i>transferAsTokenRelease</i></h4>
  <p>
The SYGON token is put into circulation with this method, by the Creator. This special method of transfer is meant to  release amounts of SYGON tokens directly to contributors. So the token release is fully covered in contribution, every time. The token is never initially released for investment or speculation purposes but only to reward real contribution to building the SYGON technology and its products. However, contributors that receive SYGON tokens can further put them on the market. So any interested party can purchase it from the market and further get access to the SYGON technology products.
  
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
      The installment ID of the current transfer for a particular Project ID. This is to provide transparency, by tracking transfers according to several milestones, along a roadmap of a project. For example, if the project targets the development of a software component, this approach matches with software development lifecycle, meaning that contribution is rewarded gradually for consecutive releases of a software component.<br/>
    </li>
  </ul>
  <h5>Expenditure Destinations</h5>
   There are three precisely defined expenditure destinations: [0] DEV (Project Development), [1] PRO (Promotion), [2] OPR (Operational). While DEV is explicit, the rest of the destinations are implicit. This means that a particular amount to transfer defaultly targets DEV. Consequently, amounts for PRO and OPR are calculated automatically based on their weights and the transfer amount for DEV. 
   <br/><br/> All destinations together define the release structure (RS). For example, a strtucture like   RS{0:20,1:30,2:50} means that a transfer of 10000 SYGON tokens is performed to DEV, which will further generate a transfer of 15000 SYGONs to PRO and a transfer of 25000 SYGONs to OPR.
   <br/><br/> Also, there are [3] ED3 and [4] ED4, with an initial weight of 0 (zero). These two destinations are left for future implementations.
   <br/><br/> <b>Changing Destinations</b> Only changing the address and weight of destinations [1-4] are allowed, and they are restricted for the Creator. Changing destinations emit specific events.
   <br/><br/> <b>Reading Destinations</b> Destinations can be accessed through a valid destination name ("DEV", "PRO", "OPR", "ED3", "ED4"). The following attributes are available: destination ID, address and weight.
   <br/><br/>
    <table>
  <tr><td>ID</td><td>Name</td><td>Address</td><td>Weight</td></tr>
  <tr><td>0</td><td>DEV</td><td>Parameter for transfer as token release</td><td>100 (unmutable)</td></tr>
  <tr><td>1</td><td>PRO</td><td>At instantiation (mutable by Creator)</td><td>150 (mutable by Creator)</td></tr>
  <tr><td>2</td><td>OPR</td><td>At instantiation (mutable by Creator)</td><td>250 (mutable by Creator)</td></tr>
  <tr><td>3</td><td>ED3</td><td>0 (mutable by Creator)</td><td>0 (mutable by Creator)</td></tr>
  <tr><td>4</td><td>ED4</td><td>0 (mutable by Creator)</td><td>0 (mutable by Creator)</td></tr>
    </table>
    
  </p>
  
  <h4>1.3 <i>transferSplit</i></h4>
  <p>
    This is a special method of token transfer. The function is internal and it is called automatically, when 
    the target address of a transfer is identified as a splitted address. This mechanism is called splitter.<br/><br/>
    If an address that is registered as splitter, any amount received by the address is "forwarded" as transfers to other target addresses, according to a predefined split schema.<br/><br/>
  
  <b>Splitters</b><br/>
  A splitter associates an address with a split schema. A split schema defines a set of transfer destinations with weights. This mechanism allows at least two contributors to get monetized for their contributions.<br/><br/>
  The contributor that creates the splitter is called primary and the second one is called secondary contributor. The secondary contributor can furhter configure the splitter by managing other 5 contributors at choice. <br/><br/>
  
  Any amount of tokens sent to a splitter is automatically distributed among the destinations defined in the split schema.<br/></br>
  Split schema <br/>
  <table>
  <tr><td>Primary</td><td>Secondary</td><td>Managed1</td><td>Managed2</td><td>Managed3</td><td>Managed4</td><td>Managed5</td></tr>
  <tr><td>0</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td></tr>
  </table>
  <br/><br>
  Example:<br/>
  If an application A generates a revenue of 100 tokens, then the contributors of the application A get rewarded through a splitter. The splitter is created by user U1, with a secondary user U2. U2 further adds U3 and U4 to the splitter. Split weights (WSplit) are: WSplit(U1)=30, WSplit(U2)=45, WSplit(U3)=35, WSplit(U4)=20. Any amount of tokens transferred to their splitter will lead to transfers from <i>addrAliasTarget</i> to split destination addresses in the following amounts: U1=30, U2=31.5, U3=24.5 and U4=14. <br/><br/>
  In this way, the monetization of the knowledge produced and delivered by the SYGON technology is transparently distributed among all contributors. The SynergyCrowds company, as an operational entity of the products, has an absolutely equal position with other contributors in terms of receiving revenues.<br/><br/>
  Any address in a split schema can be changed with a new one by its owner.<br/><br/>
  The operating entity can distribute revenues exclusively throught splitters.<br/><br/>
  <b>Configuring a splitter</b><br/><br/>
  The primary contributor can change any destination address and weight in the splitter. The secondary contributor can change the address and weight of the 5 managed destinations.<br/>
  Restriction: successfully transferring to a splitter requires that its weights must be configured correctly, namely the sum of the weights of the last 6 destinations must be 100.
  </p>
  
  <h4>1.4 <i>transferFromAliasTarget</i></h4>
  <p>
    This is a special method of token transfer ensuring that all amounts received to addrAliasTarget are transferred to splitters only. No other destination is possible. This mechanism guarantees to the contributors that all monetization of the delivered knowledge is distributed among them and it is verifiable.<br/>
  Transfers from <i>addrAliasTarget</i> can be performed either directly or delegated.
  </p>
<h3>2 Fractionable</h3>
<p>
    The SYGON token is fractionable. Having 18 decimals, the smallest transferrable amount is 0.000000000000000001 SYGON tokens.
  </p>



<h3>3 Burn</h3>
<p> The SYGON token can be burned by any token holder. However, a fraction of the collected fees are periodicaly burned (see chapter 4 - Fees).</p>
<p>The burn operation can only be applied to the released quantity of SYGON tokens. </p>
<p>The burn operation is limited to a maximum (TMBQ). </p>
<p>The burn operation is restricted for the Creator, so that the total supply is not affectable.</p>

<h3>4 Fees </h3>
  <p>
  Fees are applied to all token transfers, except the initial token release transfers.
  </p>
  <p>
  Fees are calculated based on the amount of transferred tokens and a specific factor applied to the amount. So the amount is framed to a value interval first, then the corresponding factor is applied.<br/>
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
  <p>The proportion to be burned is established through open vote by sygons and stored in <i>nBurnFromFeeQuota</i>. 
  </p>
