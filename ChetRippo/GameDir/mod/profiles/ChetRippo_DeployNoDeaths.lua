local this={
	description="ChetRippo_DeployNoDeaths",
	profile={
		crDeployBasicParamVOdeadRateMax=0,--{ -1.#INF-1.#INF } -- deadRateMax -- The highest percentage of losses from all deployed soldiers and assets you will suffer. A 50% means if you deploy 100 men you will be guaranteed to lose 50 of them at worst. Set to 0 along with MIN to never suffer losses.
		crDeployBasicParamVOdeadRateMin=0,--{ -1.#INF-1.#INF } -- deadRateMin -- The fewest percentage of losses from all deployed soldiers and assets you will suffer. A 3% means if you deploy 100 men you will be guaranteed to lose at least 3 of them, if not more.
		crVODeployBasicParamsEnable=1,--{ 0-1 } -- Override Deploy Basic Params Enable -- Do you want to tweak base deployment settings?
	}
}
return this