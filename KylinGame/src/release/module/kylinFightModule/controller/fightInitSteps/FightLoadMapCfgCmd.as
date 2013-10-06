package release.module.kylinFightModule.controller.fightInitSteps
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.model.gameData.dynamicData.interfaces.IFightDynamicDataModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;

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
			
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightStartup));
		}
	}
}