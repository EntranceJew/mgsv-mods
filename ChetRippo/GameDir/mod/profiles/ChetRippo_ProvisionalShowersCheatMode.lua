local this={
	description="ChetRippo_ProvisionalShowersCheatMode",
	profile={
		crHygieneDumpsterEnable=1,--{ 0-1 } -- Dumpsters Make You Stinky -- Do you want to get dirty, and keep Ocelot away from you?
		crHygieneProvisionalShowerEnable=1,--{ 0-1 } -- Toilets Are Showers -- Do you want to get clean when you're on the john?
		crHygieneProvisionalShowerReduceDeployTime=72,--{ 0-72 } -- Deployment Reduction Time -- How much each shower reduces your time deployed (in in-game hours).
		crHygieneProvisionalShowerWallMinutesBetweenUses=0,--{ 0-60 } -- Wall Minutes Between Uses -- How many minutes (irl, regardless of time scale) between uses of a toilet as a provisional shower.
	}
}
return this