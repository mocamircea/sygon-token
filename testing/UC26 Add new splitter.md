# UC26 Add new splitter
## <i>addSplitter</i>

Any user can add a new splitter. When creating a new splitter, only the primary and secondary entries are assigned at creation. The rest of the entries can 
later be configured with <i>configSplitter</i>.

### Preconditions
Restrictions: the sender can not be primary or secondary destination of splitter, primary and secondary addresses must be different, 
the provided weight for primary entry must be in the (0,100] range.

### Steps
Add new entry in splitter for primary destination with provided weight.

Add new entry in splitter for secondary destination with calculated weight.

Add new entries for 5 managed destinations with address 0, weight=0

### Postconditions
Returns true if the splitter is successfully created.
