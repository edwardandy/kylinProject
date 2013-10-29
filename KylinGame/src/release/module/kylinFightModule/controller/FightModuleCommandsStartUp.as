package release.module.kylinFightModule.controller
{
	
	import mainModule.controller.netCmds.httpCmds.HttpEvent;
	
	import release.module.kylinFightModule.controller.fightInitSteps.FightGameOverCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.controller.fightInitSteps.FightLoadMapCfgCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightLoadMapImgCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightPreLoadResCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightRequestDataCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightRestartCmd;
	import release.module.kylinFightModule.controller.fightInitSteps.FightStartupCmd;
	import release.module.kylinFightModule.controller.fightState.FightEndCmd;
	import release.module.kylinFightModule.controller.fightState.FightPauseCmd;
	import release.module.kylinFightModule.controller.fightState.FightQuitCmd;
	import release.module.kylinFightModule.controller.fightState.FightResumeCmd;
	import release.module.kylinFightModule.controller.fightState.FightStartCmd;
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	public final class FightModuleCommandsStartUp
	{
		public function FightModuleCommandsStartUp(cmdMap:IEventCommandMap)
		{
			cmdMap.map(HttpEvent.FightRequestData,HttpEvent).toCommand(FightRequestDataCmd);
			
			cmdMap.map(FightInitStepsEvent.FightStartup,FightInitStepsEvent).toCommand(FightStartupCmd).once();
			cmdMap.map(FightInitStepsEvent.FightLoadMapImg,FightInitStepsEvent).toCommand(FightLoadMapImgCmd).once();
			cmdMap.map(FightInitStepsEvent.FightLoadMapCfg,FightInitStepsEvent).toCommand(FightLoadMapCfgCmd).once();
			cmdMap.map(FightInitStepsEvent.FightGameOver,FightInitStepsEvent).toCommand(FightGameOverCmd).once();
			cmdMap.map(FightInitStepsEvent.FightPreLoadRes,FightInitStepsEvent).toCommand(FightPreLoadResCmd).once();
			cmdMap.map(FightInitStepsEvent.FightRestart,FightInitStepsEvent).toCommand(FightRestartCmd);
			
			cmdMap.map(FightStateEvent.FightStart,FightStateEvent).toCommand(FightStartCmd);
			cmdMap.map(FightStateEvent.FightEnd,FightStateEvent).toCommand(FightEndCmd);
			cmdMap.map(FightStateEvent.FightPause,FightStateEvent).toCommand(FightPauseCmd);
			cmdMap.map(FightStateEvent.FightResume,FightStateEvent).toCommand(FightResumeCmd);
			cmdMap.map(FightStateEvent.FightQuit,FightStateEvent).toCommand(FightQuitCmd).once();
		}
	}
}