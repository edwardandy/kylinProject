package release.module.kylinFightModule.controller.fightInitSteps
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import release.module.kylinFightModule.service.fightResPreload.IFightResPreloadService;

	/**
	 * 预加载战斗动画资源
	 */
	public class FightPreLoadResCmd extends KylinCommand
	{
		[Inject]
		public var fightResPreLoader:IFightResPreloadService;
		
		public function FightPreLoadResCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			fightResPreLoader.preInitAllRes();
		}
	}
}