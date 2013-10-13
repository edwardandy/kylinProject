package mainModule.model.gameData.dynamicData.hero
{
	import mainModule.controller.gameData.GameDataUpdateEvent;
	import mainModule.model.gameData.dynamicData.BaseDynamicItemsModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;
	import mainModule.model.gameData.dynamicData.interfaces.IHeroDynamicDataModel;

	/**
	 * 英雄动态数据 
	 * @author Edward
	 */	
	public class HeroDynamicDataModel extends BaseDynamicItemsModel implements IHeroDynamicDataModel
	{
		public function HeroDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.HeroData;
			updateEventType = GameDataUpdateEvent.GameDataUpdate_HeroData;
			itemClazz = HeroDynamicItem;
		}
		/**
		 * @inheritDoc
		 */		
		public function getHeroDataById(id:uint):HeroDynamicItem
		{
			return getItemById(id) as HeroDynamicItem;
		}
		/**
		 * @inheritDoc
		 */
		public function getAllHeroData():Vector.<HeroDynamicItem>
		{
			return Vector.<HeroDynamicItem>(getAllItems());
		}
	}
}