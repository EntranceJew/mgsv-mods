# vars

Variables exist, but how do you save them? Should you save them? Are they just a blob of info?

Here is a handy reference for the types of variable storage available to you:

- `vars`: 
- `svars`:  
- `gvars`: **G**lobal **Var**iable**s**, may be of type `TppScriptVars`, save status dubious.
- `mvars`: **M**ission **Var**iable**s**, only active for the current mission.
- `igvars`:
- `_G`: Hail satan, this is just the global scope. Nothing in this place will be saved.

## vars

The game keeps data here, and some of the lua checks it, although keep in mind that specific values in here are of class `TppScriptVars`.

## gvars

I don't know how to distinguish these.
