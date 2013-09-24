package release.module.kylinFightModule
{
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	
	import release.module.kylinFightModule.controller.FightModuleCommandsStartUp;
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.gameplay.main.MainFightScene;
	import release.module.kylinFightModule.model.FightModuleModelsStartUp;
	
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.Context;
	
	public class KylinFightContext extends Context
	{
		public function KylinFightContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, parentInjector:IInjector=null, applicationDomain:ApplicationDomain=null)
		{
			//super(contextView, autoStartup, parentInjector, applicationDomain);
		}
		
		/*override public function startup():void
		{
			injector.mapSingleton(MainFightScene);

			
			new FightModuleCommandsStartUp(commandMap);
			new FightModuleModelsStartUp(injector);
			
			
			super.startup();
			
			dispatchEvent(new FightInitStepsEvent(FightInitStepsEvent.FightFillVirtualData));
		}*/
		
		/*override public function shutdown():void
		{
			super.shutdown();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}*/
	}
}