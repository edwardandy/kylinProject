package mainModule
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	
	import mainModule.controller.MainModuleCommandsStartUp;
	import mainModule.controller.gameInitSteps.GameInitStepEvent;
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.MainModuleModelsStartUp;
	import mainModule.model.panelData.PanelNameConst;
	import mainModule.service.MainModuleServicesStartUp;
	import mainModule.startUp.MainModuleInjectStartUp;
	import mainModule.startUp.MainModuleParseFlashVar;
	import mainModule.view.MainModuleViewMediaterStartUp;
	
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.Context;
	
	

	/**
	 * 主模块框架入口 
	 * @author Edward
	 * 
	 */	
	public class MainModuleContext extends Context
	{		
		private var _loaderReadyCallback:Function;
		
		public function MainModuleContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, parentInjector:IInjector = null, applicationDomain:ApplicationDomain = null)
		{
			//super(contextView, autoStartup,parentInjector,applicationDomain);
		}
		/**
		 * 启动框架 
		 */		
		/*override */public function startup():void
		{
			//injector.mapValue(Stage,contextView.view.stage);

			new MainModuleModelsStartUp(this.injector);
			new MainModuleServicesStartUp(this.injector);
			new MainModuleInjectStartUp(this.injector);
			//new MainModuleCommandsStartUp(this.commandMap);
			//new MainModuleViewMediaterStartUp(this.mediatorMap);

			super.startup();
			
			Security.allowDomain("*");
			addEventListener(UIPanelEvent.UI_PanelOpened,onLoaderReady);
			dispatchEvent(new GameInitStepEvent(GameInitStepEvent.GameInitLoadResCfg));
		}
		/**
		 * 关闭框架 
		 */		
		/*override */public function shutdown():void
		{
			loaderReadyCallback = null;
			super.shutdown();
		}
		/**
		 * 解析flash变量 ,在contextView加到舞台上之前就要调用
		 * @param data
		 * 
		 */		
		public function parseFlashVars(data:Object):void
		{
			new MainModuleParseFlashVar(data,this.injector);
		}
		/**
		 * 设置加载面板准备好后通知外壳的回调，将会移除外壳 
		 * @param cb
		 * 
		 */		
		public function set loaderReadyCallback(cb:Function):void
		{
			_loaderReadyCallback = cb;
		}
		/**
		 * 加载面板准备好之后进行回调 
		 * @param e
		 * 
		 */		
		private function onLoaderReady(e:UIPanelEvent):void
		{
			if(PanelNameConst.LoadPanel == e.panelId)
			{
				removeEventListener(UIPanelEvent.UI_PanelOpened,onLoaderReady);
				
				if(null != _loaderReadyCallback)
					_loaderReadyCallback();
				loaderReadyCallback = null;
			}
		}
	}
}