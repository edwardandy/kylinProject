package release.module.kylinFightModule.controller.fightState
{
	import io.smash.time.TimeManager;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import release.module.kylinFightModule.model.state.FightState;
	import release.module.kylinFightModule.model.state.IFightLifecycleGroup;

	/**
	 * 战斗暂停 
	 * @author Edward
	 * 
	 */	
	public class FightPauseCmd extends KylinCommand
	{
		[Inject]
		public var fightLifecycleGroup:IFightLifecycleGroup;
		[Inject]
		public var fightState:FightState;
		[Inject]
		public var timeMgr:TimeManager;
		
		public function FightPauseCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			fightState.state = FightState.PauseFight;
			timeMgr.stop();
			fightLifecycleGroup.onFightPause();
		}
	}
}