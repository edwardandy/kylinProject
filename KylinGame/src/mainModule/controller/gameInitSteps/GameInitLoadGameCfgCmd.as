package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;

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
		public var loadService:ILoadAssetsServices;
		
		public function GameInitLoadGameCfgCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			loadGameCfg("game_config");
			
			directCommandMap.detain(this);
		}
		
		private function loadGameCfg(id:String):void
		{
			loadService.addCfgFileItem(id).addComplete(onGameCfgLoaded);
		}
		
		private function onGameCfgLoaded(info:AssetInfo):void
		{
			gameCfgModel.gameCfg = info.content;
						
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitSetupGameCfg));
			
			directCommandMap.release(this);
		}
	}
}