local this={
	description="ChetRippo_DeployFaster",
	profile={
		crDeployBasicParamVOmissionListRefreshTimeMinute=15,--{ -1.#INF-1.#INF } -- missionListRefreshTimeMinute -- The time it takes for the deployment list to re-roll a new set of deployments.
		crDeployMissionParamsVOtimeMinuteMax=20,--{ -1.#INF-1.#INF } -- timeMinuteMax -- The upper bound of a deployment's duration, rescaled from their original duraiton, not including random offsets.
		crDeployMissionParamsVOtimeMinuteMin=2,--{ -1.#INF-1.#INF } -- timeMinuteMin -- The lower bound of a deployment's duration, rescaled from their original duraiton, not including random offsets.
		crDeployMissionParamsVOtimeMinuteRandomMax=15,--{ -1.#INF-1.#INF } -- timeMinuteRandomMax -- The upper bound of random time to get added to each deployment time, when they are rolled.
		crDeployMissionParamsVOtimeMinuteRandomMin=1,--{ -1.#INF-1.#INF } -- timeMinuteRandomMin -- The lower bound of random time to get added to each deployment time, when they are rolled.
		crVODeployBasicParamsEnable=1,--{ 0-1 } -- Override Deploy Basic Params Enable -- Do you want to tweak base deployment settings?
		crVODeployMissionParamsEnable=1,--{ 0-1 } -- Override Deploy Mission Params Enable -- Do you want to tweak all deployments?
	}
}
return this