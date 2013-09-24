package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.model.preLoadData.interfaces.IPreLoadCfgModel;

	/**
	 * 加载游戏预加载资源配置文件
	 * @author Edward
	 * 
	 */	
	public class GameInitLoadPreloadCfgCmd extends KylinCommand
	{
		[Inject]
		public var loadMgr:ILoadMgr;
		[Inject]
		public var _preLoadCfg:IPreLoadCfgModel;
		
		public function GameInitLoadPreloadCfgCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			loadCfg("preload_config");
			
			directCommandMap.detain(this);
		}
		
		private function loadCfg(id:String):void
		{
			var _loadConfig:XMLItem = loadMgr.addCfgFileItem(id) as XMLItem;
			_loadConfig.addEventListener(Event.COMPLETE,onGameCfgLoaded);
		}
		
		private function onGameCfgLoaded(e:Event):void
		{
			var _loadConfig:XMLItem = e.currentTarget as XMLItem;
			_loadConfig.removeEventListener(Event.COMPLETE,onGameCfgLoaded);
			
			_preLoadCfg.initData(_loadConfig.content);
			
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitLoadFonts));
			
			directCommandMap.release(this);
		}
	}
}