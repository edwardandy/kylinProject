package release.module.kylinFightModule.configuration
{
	
	import flash.events.IEventDispatcher;
	import flash.system.Security;
	
	import io.smash.time.TimeManager;
	
	import release.module.kylinFightModule.controller.FightModuleCommandsStartUp;
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.gameplay.main.MainFightScene;
	import release.module.kylinFightModule.model.FightModuleModelsStartUp;
	import release.module.kylinFightModule.service.FightModuleServicesStartUp;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.directCommandMap.api.IDirectCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;

	public class KylinFightConfig implements IConfig
	{
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var context:IContext;
		
		[Inject] 
		public var eventCommandMap:IEventCommandMap;
		
		[Inject]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var directCommandMap:IDirectCommandMap;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var contextView:ContextView;
		
		[Inject] 
		public var viewProcessorMap:IViewProcessorMap;
		public function KylinFightConfig()
		{
		}
		
		public function configure():void
		{
			Security.allowDomain("*");
			
			//injector.map(MainFightScene).asSingleton();
			injector.map(TimeManager).asSingleton();
			
			new FightModuleCommandsStartUp(eventCommandMap);
			new FightModuleModelsStartUp(injector);
			new FightModuleServicesStartUp(injector);
			
			//startup
			context.afterInitializing(startup);
		}
		
		private function startup():void
		{	
			dispatcher.dispatchEvent(new FightInitStepsEvent(FightInitStepsEvent.FightFillVirtualData));
		}
	}
}