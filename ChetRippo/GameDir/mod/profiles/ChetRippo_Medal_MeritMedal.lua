local this={
	description="ChetRippo_Medal_MeritMedal",
	profile={
    crMedalEnable=1,--{ 0-1 } -- Enable Awarding Medals -- Turns all features on this page on. Can't use any of them without it!
		crMedalAwardMeritPointForStaff=1,--{ 0-1 } -- Merit: Award Merit Point For Staff -- Enable earning merit points for your DD staff.
		crMedalAwardMeritPointForStaffConditionSRank=1,--{ 0-1 } -- Merit Condition: Require S-Rank -- Sets the condition that you must achieve an S-Rank with your DD staff to earn Merit Points.
		crMedalAwardMeritPointForStaffConditionKillScore=1,--{ 0-1 } -- Merit Condition: Kill Score -- Sets the condition that you must have a Kill Score of above zero with your DD staff to earn Merit Points.
		crMedalAwardMeritPointForStaffConditionAlertScore=1,--{ 0-1 } -- Merit Condition: Alert Score -- Sets the condition that you must have an Alert Score of above zero with your DD staff to earn Merit Points.
	}
}
return this