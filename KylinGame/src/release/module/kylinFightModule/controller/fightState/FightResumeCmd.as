package release.module.kylinFightModule.controller.fightState
{
	import io.smash.time.TimeManager;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import release.module.kylinFightModule.model.state.FightState;
	import release.module.kylinFightModule.model.state.IFightLifecycleGroup;

	/**
	 * 战斗继续 
	 * @author Edward
	 * 
	 */	
	public class FightResumeCmd extends KylinCommand
	{
		[Inject]
		public var fightLifecycleGroup:IFightLifecycleGroup;
		[Inject]
		public var fightState:FightState;
		[Inject]
		public var timeMgr:TimeManager;
		[Inject]
		public var globalTemp:GlobalTemp;
		
		public function FightResumeCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			if(globalTemp.bForcePause || FightState.PauseFight != fightState.state)
				return;
			
			super.execute();
			fightLifecycleGroup.onFightResume();
			timeMgr.start();
			fightState.state = FightState.RunningFight;
		}
	}
}