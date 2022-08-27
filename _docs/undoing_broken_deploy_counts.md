# Undoing Broken Deploy Counts

I ran a function which trashed my deploy counts even after a re-launch. (That function being `TppMotherBaseManagement.ResetDeploySvars()`)

401k dumped their values and I compared theirs against mine for relevant values, below are the minimum related values I needed to execute to restore it.

## Code I Ran

```lua
vars.mbmIsVisitedFobDeployWelcomeMessage2 = 1
vars.mbmFobDeployCheckBoxes = { [0] = 0, 0, 1, 1, 0, 0, }
vars.mbmFobDeployGradeSelectorIndexes = { [0] = 0, 4, 3, 3, 0, 0, }
```

## Reference Info

```lua
-- entrancejew
vars.mbmIsVisitedFobDeployWelcomeMessage2 = 0
vars.mbmFobDeployCheckBoxes = { [0] = 0, 0, 0, 0, 0, 0, }
vars.mbmFobDeployGradeSelectorIndexes = { [0] = 0, 0, 0, 0, 0, 0, }
vars.mbmFobSvars = { [0] = 252027023, 12746833, 41100, 41100, }
```

```lua
-- 401k
vars.mbmIsVisitedFobDeployWelcomeMessage2 = 1
vars.mbmFobDeployCheckBoxes = { [0] = 0, 0, 1, 1, 0, 0, }
vars.mbmFobDeployGradeSelectorIndexes = { [0] = 0, 4, 3, 3, 0, 0, }
vars.mbmFobSvars = { [0] = 41835, 25207573, 41868, 41868, }
```
