# UC26 Add new splitter
Add a new splitter. When creating a new splitter, only the primary and secondary entries are assigned. The rest of the entries can 
later be configured with <i>configSplitter</i>.

### Preconditions
Restrictions: the sender can not be primary or secondary destination of splitter, primary and secondary addresses must be different, 
weight of primary entry must be in (0,100] range.

### Steps
Add new entry in splitter for primary destination with provided weight.

Add new entry in splitter for secondary destination with calculated weight.

Add new entries for 5 managed destinations with address 0, weight=0

### Postconditions
Returns true if splitter is successfully created.
