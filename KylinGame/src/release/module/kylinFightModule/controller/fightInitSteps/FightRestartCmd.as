package release.module.kylinFightModule.controller.fightInitSteps
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;

	/**
	 * 重新开始战斗 
	 * @author Edward
	 * 
	 */	
	public class FightRestartCmd extends KylinCommand
	{
		public function FightRestartCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			dispatch(new FightStateEvent(FightStateEvent.FightEnd));
			dispatch(new FightStateEvent(FightStateEvent.FightStart));
		}
	}
}