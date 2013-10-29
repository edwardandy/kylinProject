package mainModule.controller.gameInitSteps
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	
	import mainModule.model.preLoadData.interfaces.IPreLoadCfgModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;

	/**
	 * 加载游戏预加载资源配置文件
	 * @author Edward
	 * 
	 */	
	public class GameInitLoadPreloadCfgCmd extends KylinCommand
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
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
			loadService.addCfgFileItem(id).addComplete(onGameCfgLoaded);
		}
		
		private function onGameCfgLoaded(asset:AssetInfo):void
		{
			_preLoadCfg.initData(asset.content);
			
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitLoadFonts));
			
			directCommandMap.release(this);
		}
	}
}