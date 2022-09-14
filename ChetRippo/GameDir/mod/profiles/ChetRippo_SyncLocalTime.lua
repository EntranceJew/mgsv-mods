local this={
	description="ChetRippo_SyncLocalTime",
	profile={
		clockTimeScale=1,
		crMiscSyncLocalTime=1,--{ 0-1 } -- Time: Sync Local Time -- If you want the timescale to match your computer's time. You should set timescale=1 in IH to prevent any strange behavior. May make some cutscenes look weird, plese report any problems.
		crMiscSyncLocalTimeOffset=0,--{ -23-23 } -- Time: Local Time Hour Offset -- If the game is too bright based on local time, offset it forward or backwards. Also changes the resultant in-game time, not just light levels.
	}
}
return this