package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;

	/**
	 * 加载游戏主配置文件 
	 * @author Edward
	 * 
	 */	
	public class GameInitLoadGameCfgCmd extends KylinCommand
	{
		[Inject]
		public var gameCfgModel:IGameCfgModel;
		
		[Inject]
		public var loadMgr:ILoadMgr;
		
		public function GameInitLoadGameCfgCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			loadGameCfg("game_config");
			
			commandMap.detain(this);
		}
		
		private function loadGameCfg(id:String):void
		{
			var _loadConfig:XMLItem = loadMgr.addCfgFileItem(id) as XMLItem;
			_loadConfig.addEventListener(Event.COMPLETE,onGameCfgLoaded);
		}
		
		private function onGameCfgLoaded(e:Event):void
		{
			var _loadConfig:XMLItem = e.currentTarget as XMLItem;
			_loadConfig.removeEventListener(Event.COMPLETE,onGameCfgLoaded);
			
			gameCfgModel.gameCfg = _loadConfig.content;
						
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitSetupGameCfg));
			
			commandMap.release(this);
		}
	}
}