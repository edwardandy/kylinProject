package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.resPath.ResPathParam;
	
	import mainModule.extensions.flashVars.FlashVars;

	/**
	 * 开始加载资源配置文件，游戏开始最优先加载 
	 */
	public class GameInitLoadResCfgCmd extends KylinCommand
	{
		[Inject]
		public var _flashVars:FlashVars;
		
		public function GameInitLoadResCfgCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			directCommandMap.detain(this);
			loadResCfg("ver_config/config");
		}
		
		private function loadResCfg(url:String):void
		{
			var request:URLRequest = new URLRequest(genUrl(url,".xml"));
			var load:URLLoader = new URLLoader();
			load.addEventListener(Event.COMPLETE,onLoadCfgCmp);
			load.load(request);
		}
		
		private function genUrl(subPath:String,suffix:String):String
		{
			if(_flashVars.FLASH_PATH)
				subPath = _flashVars.FLASH_PATH + subPath;
			if(_flashVars.RES_VER>0)
				subPath += "_"+_flashVars.RES_VER;
			subPath += suffix;
			return subPath;
		}
		
		private function onLoadCfgCmp(e:Event):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE,onLoadCfgCmp);
			
			injector.map(ResPathParam).toValue(new ResPathParam(new XML(loader.data),_flashVars.FLASH_PATH,_flashVars.LAN))
			
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitLoadGameCfg));
			
			directCommandMap.release(this);
		}
		
		
	}
}