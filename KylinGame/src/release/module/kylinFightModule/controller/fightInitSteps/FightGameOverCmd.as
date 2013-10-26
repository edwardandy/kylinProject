package release.module.kylinFightModule.controller.fightInitSteps
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;

	/**
	 * 战斗结束，需要传递参数，true:胜利，false:失败
	 */	
	public class FightGameOverCmd extends KylinCommand
	{
		[Inject]
		public var event:FightInitStepsEvent;
		
		public function FightGameOverCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			dispatch(new FightStateEvent(FightStateEvent.FightEnd));
			dispatch(new FightStateEvent(FightStateEvent.FightQuit));
		}
	}
}