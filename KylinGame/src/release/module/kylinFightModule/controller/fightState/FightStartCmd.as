package release.module.kylinFightModule.controller.fightState
{
	import io.smash.time.TimeManager;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import release.module.kylinFightModule.model.state.FightState;
	import release.module.kylinFightModule.model.state.IFightLifecycleGroup;

	/**
	 * 战斗开始(包括重新开始) 
	 * @author Edward
	 * 
	 */	
	public class FightStartCmd extends KylinCommand
	{
		[Inject]
		public var fightLifecycleGroup:IFightLifecycleGroup;
		[Inject]
		public var fightState:FightState;
		[Inject]
		public var timeMgr:TimeManager;
		
		public function FightStartCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			fightState.state = FightState.StartFight;
			fightLifecycleGroup.onFightStart();
			timeMgr.initialize();
			fightState.state = FightState.RunningFight;
		}
	}
}