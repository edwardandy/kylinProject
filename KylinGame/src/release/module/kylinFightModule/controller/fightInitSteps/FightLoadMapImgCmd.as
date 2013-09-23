package release.module.kylinFightModule.controller.fightInitSteps
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.model.gameData.dynamicData.interfaces.IFightDynamicDataModel;
	
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	/**
	 * 加载战斗背景地图资源
	 */	
	public class FightLoadMapImgCmd extends KylinCommand
	{
		[Inject]
		public var loadMgr:ILoadMgr;
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
			var item:ImageItem = loadMgr.addMapImgItem(fightData.tollgateMainId.toString());
			if(item.isLoaded)
			{
				initMapBg(item.content);
				return;	
			}
			item.addEventListener(Event.COMPLETE,onLoadCmp);
		}
		
		private function onLoadCmp(e:Event):void
		{
			var item:ImageItem = e.currentTarget as ImageItem;
			initMapBg(item.content);
		}
		
		private function initMapBg(img:DisplayObject):void
		{
			viewLayers.groundLayer.addChild(img);
			
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightLoadMapCfg));
		}
	}
}