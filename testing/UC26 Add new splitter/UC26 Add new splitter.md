# UC26 Add new splitter
## <i>addSplitter</i>

Any user can add a new splitter. When creating a new splitter, only the primary and secondary entries are required. The rest of the entries can be further configured with the <i>configSplitter</i> function.

### Preconditions
#### Input parameters
1. Address of primary destination
2. Weight for primary destination
3. Address of secondary destination

#### Restrictions
1. The sender is
    1. Not the primary destination
    2. Not the secondary destination of splitter
2. The primary and secondary destinations are different
3. Provided weight value is in the (0,100) range.

### Steps
Add new entry in <i>splitters</i> for primary destination, with provided weight.

Add new entry in <i>splitter</i> for secondary destination, with calculated weight.

Add empty entries for 5 managed destinations with address 0 and weight=0.

### Postconditions
Returns true if the splitter is successfully created.
