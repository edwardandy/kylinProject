package release.module.kylinFightModule.controller.fightInitSteps
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	
	import release.module.kylinFightModule.gameplay.main.MainFightScene;

	/**
	 * 战斗前准备完毕，开始战斗 
	 * @author Edward
	 * 
	 */	
	public class FightStartupCmd extends KylinCommand
	{
		[Inject]
		public var mainFightScene:MainFightScene;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		
		public function FightStartupCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
		}
	}
}