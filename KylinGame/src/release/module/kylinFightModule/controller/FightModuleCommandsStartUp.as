package release.module.kylinFightModule.controller
{
	import org.robotlegs.core.ICommandMap;
	
	import release.module.kylinFightModule.controller.fightInitSteps.FightFillVirtualDataCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.controller.fightInitSteps.FightLoadMapCfgCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightLoadMapImgCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightStartupCmd;

	public final class FightModuleCommandsStartUp
	{
		public function FightModuleCommandsStartUp(cmdMap:ICommandMap)
		{
			cmdMap.mapEvent(FightInitStepsEvent.FightFillVirtualData,FightFillVirtualDataCmd,FightInitStepsEvent,true);
			cmdMap.mapEvent(FightInitStepsEvent.FightStartup,FightStartupCmd,FightInitStepsEvent,true);
			cmdMap.mapEvent(FightInitStepsEvent.FightLoadMapImg,FightLoadMapImgCmd,FightInitStepsEvent,true);
			cmdMap.mapEvent(FightInitStepsEvent.FightLoadMapCfg,FightLoadMapCfgCmd,FightInitStepsEvent,true);
		}
	}
}