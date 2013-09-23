package release.module.kylinFightModule
{
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	
	import kylin.echo.edward.framwork.KylinContext;
	
	import org.robotlegs.core.IInjector;
	
	import release.module.kylinFightModule.controller.FightModuleCommandsStartUp;
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.gameplay.main.MainFightScene;
	import release.module.kylinFightModule.model.FightModuleModelsStartUp;
	
	public class KylinFightContext extends KylinContext
	{
		public function KylinFightContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, parentInjector:IInjector=null, applicationDomain:ApplicationDomain=null)
		{
			super(contextView, autoStartup, parentInjector, applicationDomain);
		}
		
		override public function startup():void
		{
			injector.mapSingleton(MainFightScene);

			
			new FightModuleCommandsStartUp(commandMap);
			new FightModuleModelsStartUp(injector);
			eventDispatcher;
			moduleDispatcher;
			
			
			super.startup();
			
			dispatchEvent(new FightInitStepsEvent(FightInitStepsEvent.FightFillVirtualData));
		}
		
		override public function shutdown():void
		{
			super.shutdown();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}