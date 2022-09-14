local this={
	description="ChetRippo_DeployInstant",
	profile={
		crDeployMissionParamsVOtimeMinuteMax=0,--{ -1.#INF-1.#INF } -- timeMinuteMax -- The upper bound of a deployment's duration, rescaled from their original duraiton, not including random offsets.
		crDeployMissionParamsVOtimeMinuteMin=0,--{ -1.#INF-1.#INF } -- timeMinuteMin -- The lower bound of a deployment's duration, rescaled from their original duraiton, not including random offsets.
		crDeployMissionParamsVOtimeMinuteRandomMax=0,--{ -1.#INF-1.#INF } -- timeMinuteRandomMax -- The upper bound of random time to get added to each deployment time, when they are rolled.
		crDeployMissionParamsVOtimeMinuteRandomMin=0,--{ -1.#INF-1.#INF } -- timeMinuteRandomMin -- The lower bound of random time to get added to each deployment time, when they are rolled.
		crVODeployMissionParamsEnable=1,--{ 0-1 } -- Override Deploy Mission Params Enable -- Do you want to tweak all deployments?
	}
}
return this