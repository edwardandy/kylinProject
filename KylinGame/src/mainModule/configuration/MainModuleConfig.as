package mainModule.configuration
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.system.Security;
	
	import mainModule.controller.MainModuleCommandsStartUp;
	import mainModule.controller.gameInitSteps.GameInitStepEvent;
	import mainModule.model.MainModuleModelsStartUp;
	import mainModule.service.MainModuleServicesStartUp;
	import mainModule.startUp.MainModuleInjectStartUp;
	import mainModule.view.MainModuleViewMediaterStartUp;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.directCommandMap.api.IDirectCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	
	
	public class MainModuleConfig implements IConfig
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
		public function MainModuleConfig()
		{
		}
		
		public function configure():void
		{
			Security.allowDomain("*");
			MonsterDebugger.initialize(contextView.view);
			injector.map(Stage).toValue(contextView.view.stage);
			//command
			//directCommandMap.map(StartupApplicationCommand).map(GetFacebookFriendsCommand);
			
			//model
			
			//service
			//httpManager.initialize(GameConst.PATH_TO_PHP);
			//serviceFactory.registerService(GameStartService.NAME, GameStartService);
						
			new MainModuleModelsStartUp(this.injector);
			new MainModuleServicesStartUp(this.injector);
			new MainModuleInjectStartUp(this.injector);
			new MainModuleCommandsStartUp(this.eventCommandMap);
			new MainModuleViewMediaterStartUp(this.mediatorMap);
			
			//startup
			context.afterInitializing(startup);
		}
		
		private function startup():void
		{	
			dispatcher.dispatchEvent(new GameInitStepEvent(GameInitStepEvent.GameInitLoadResCfg));
		}
	}
}