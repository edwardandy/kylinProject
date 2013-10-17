package release.module.kylinFightModule.controller.fightInitSteps
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;

	/**
	 * 加载战斗地图配置
	 */
	public class FightLoadMapCfgCmd extends KylinCommand
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var roadData:IMapRoadModel;
		[Inject]
		public var sceneModel:ISceneDataModel;
		
		public function FightLoadMapCfgCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			loadService.addMapXmlItem(fightData.tollgateId.toString()).addComplete(parseCfg);
		}
		
		private function parseCfg(asset:AssetInfo):void
		{
			roadData.updateData(asset.content as XML);
			sceneModel.updateSceneElements(asset.content as XML);
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightPreLoadRes));
		}
	}
}