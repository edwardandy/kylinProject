package mainModule.model.gameData.dynamicData.hero
{
	import mainModule.controller.gameData.GameDataUpdateEvent;
	import mainModule.model.gameData.dynamicData.BaseDynamicDataModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;

	/**
	 * 英雄动态数据 
	 * @author Edward
	 * 
	 */	
	public class HeroDynamicDataModel extends BaseDynamicDataModel
	{
		public function HeroDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.HeroData;
			updateEventType = GameDataUpdateEvent.GameDataUpdate_HeroData;
		}
	}
}