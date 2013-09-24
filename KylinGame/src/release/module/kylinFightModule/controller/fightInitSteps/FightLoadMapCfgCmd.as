package release.module.kylinFightModule.controller.fightInitSteps
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.model.gameData.dynamicData.interfaces.IFightDynamicDataModel;
	
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;

	/**
	 * 加载战斗地图配置
	 */
	public class FightLoadMapCfgCmd extends KylinCommand
	{
		[Inject]
		public var loadMgr:ILoadMgr;
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
			var item:XMLItem = loadMgr.addMapXmlItem(fightData.tollgateId.toString());
			if(item.isLoaded)
			{
				parseCfg(item.content);
				return;	
			}
			item.addEventListener(Event.COMPLETE,onLoadCmp);
		}
		
		private function onLoadCmp(e:Event):void
		{
			var item:XMLItem = e.currentTarget as XMLItem;
			parseCfg(item.content);
		}
		
		private function parseCfg(data:XML):void
		{
			roadData.updateData(data);
			
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightStartup));
		}
	}
}