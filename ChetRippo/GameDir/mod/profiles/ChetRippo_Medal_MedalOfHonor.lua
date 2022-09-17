local this={
	description="ChetRippo_Medal_MedalOfHonor",
	profile={
    crMedalEnable=1,--{ 0-1 } -- Enable Awarding Medals -- Turns all features on this page on. Can't use any of them without it!
    crMedalAwardHonorMedalForStaff=1,--{ 0-1 } -- Honor: Award Honor Medal For Staff -- Enable earning an Honor Medal for your DD staff.
    crMedalAwardHonorMedalForStaffConditionSRank=1,--{ 0-1 } -- Honor Condition: Require S-Rank -- Sets the condition that you must achieve an S-Rank with your DD staff to earn an Honor Medal.
		crMedalAwardHonorMedalForStaffConditionAlertScore=1,--{ 0-1 } -- Honor Condition: Alert Score -- Sets the condition that you must have an Alert Score of above zero with your DD staff to earn an Honor Medal.
		crMedalAwardHonorMedalForStaffConditionKillScore=1,--{ 0-1 } -- Honor Condition: Kill Score -- Sets the condition that you must have a Kill Score of above zero with your DD staff to earn an Honor Medal.
	}
}
return this