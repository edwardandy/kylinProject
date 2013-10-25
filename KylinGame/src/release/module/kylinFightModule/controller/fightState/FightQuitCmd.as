package release.module.kylinFightModule.controller.fightState
{
	import io.smash.time.TimeManager;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.model.state.FightState;
	import release.module.kylinFightModule.model.state.IFightLifecycleGroup;

	/**
	 * 战斗完全结束，将退出战斗
	 */	
	public class FightQuitCmd extends KylinCommand
	{
		[Inject]
		public var fightLifecycleGroup:IFightLifecycleGroup;
		[Inject]
		public var fightState:FightState;
		[Inject]
		public var timeMgr:TimeManager;
		[Inject]
		public var filterMgr:GameFilterManager;
		
		public function FightQuitCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			fightState.state = FightState.QuitFight;
			fightLifecycleGroup.dispose();
			filterMgr.dispose();
			timeMgr.destroy();
		}
	}
}