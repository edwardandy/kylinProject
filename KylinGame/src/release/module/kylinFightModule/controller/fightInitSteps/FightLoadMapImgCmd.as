package release.module.kylinFightModule.controller.fightInitSteps
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.model.gameData.dynamicData.interfaces.IFightDynamicDataModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	/**
	 * 加载战斗背景地图资源
	 */	
	public class FightLoadMapImgCmd extends KylinCommand
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var viewLayers:IFightViewLayersModel;
		
		public function FightLoadMapImgCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			loadService.addMapImgItem(fightData.tollgateMainId.toString()).addComplete(initMapBg);
		}
		
		private function initMapBg(asset:AssetInfo):void
		{
			viewLayers.groundLayer.addChild(asset.content as DisplayObject);
			
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightLoadMapCfg));
		}
	}
}