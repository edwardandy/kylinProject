package mainModule
{	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import mainModule.configuration.MainModuleConfig;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	
	/**
	 * 游戏主模块 
	 * @author Edward
	 * 
	 */	
	[SWF(width="760",height="650",frameRate="30",backgroundColor="0xcccccc")] 
	public class wrapper extends Sprite
	{
		/**
		 * 	主模块框架入口
		 */		
		private var _context:IContext;
		
		public function wrapper()
		{		
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			
			_context = new Context()
				.install( MVCSBundle)
				.configure(MainModuleConfig)
				.configure( new ContextView(this) );
			
			//_cb();
			//loadModule();
			//loadTestRes();
			//loadUiComponent();
			//loadTest2Res();
		}
		
		private function loadModule():void
		{
			var load:URLLoader = new URLLoader;
			var url:URLRequest = new URLRequest("release/configfile/game_config.xml");
			//var context:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
			load.load(url);
			load.addEventListener(Event.COMPLETE,onTestModuleCmp);
		}
		
		private function onTestModuleCmp(e:Event):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.data;
			//addChild(loadInfo.content);	
		}
		
		
		private function loadUiComponent():void
		{
			var load:Loader = new Loader;
			var url:URLRequest = new URLRequest("release/module/TestModule/uiComponent.swf");
			var context:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			load.load(url,context);
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onUiComponentCmp);
		}
		
		private function onUiComponentCmp(e:Event):void
		{
			var loadInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loadInfo.removeEventListener(Event.COMPLETE,onUiComponentCmp);
			loadTestRes();
			//loadTest2Res();
		}
		
		private function loadTestRes():void
		{
			var load:Loader = new Loader;
			var url:URLRequest = new URLRequest("release/module/TestModule/test.swf");
			var context:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
			load.load(url,context);
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onTestResCmp);
			load.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onTestResProgress);
			addChild(load);
		}
		
		private function onTestResProgress(e:ProgressEvent):void
		{
			trace("test Progress");
		}
		
		private function onTestResCmp(e:Event):void
		{
			trace("test loaded");
			var loadInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			addChild(loadInfo.content);	
			loadTest2Res();
		}
		
		private function loadTest2Res():void
		{
			var load:Loader = new Loader;
			var url:URLRequest = new URLRequest("release/module/TestModule/test2.swf");
			var context:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
			load.load(url,context);
			//load.contentLoaderInfo.addEventListener(Event.COMPLETE,onTestResCmp);
			//load.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onTestResProgress);
			addChild(load);
		}
	}
}