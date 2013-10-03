package release.module.kylinFightModule.controller
{
	
	import release.module.kylinFightModule.controller.fightInitSteps.FightFillVirtualDataCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.controller.fightInitSteps.FightLoadMapCfgCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightLoadMapImgCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightStartupCmd;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	public final class FightModuleCommandsStartUp
	{
		public function FightModuleCommandsStartUp(cmdMap:IEventCommandMap)
		{
			cmdMap.map(FightInitStepsEvent.FightFillVirtualData,FightInitStepsEvent).toCommand(FightFillVirtualDataCmd).once();
			cmdMap.map(FightInitStepsEvent.FightStartup,FightInitStepsEvent).toCommand(FightStartupCmd).once();
			cmdMap.map(FightInitStepsEvent.FightLoadMapImg,FightInitStepsEvent).toCommand(FightLoadMapImgCmd).once();
			cmdMap.map(FightInitStepsEvent.FightLoadMapCfg,FightInitStepsEvent).toCommand(FightLoadMapCfgCmd).once();
		}
	}
}