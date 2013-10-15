package mainModule.model.gameData.dynamicData.hero
{
	import mainModule.controller.gameData.GameDataUpdateEvent;
	import mainModule.model.gameData.dynamicData.BaseDynamicItemsModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;

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
		public function getHeroDataById(id:uint):IHeroDynamicItem
		{
			return getItemById(id) as IHeroDynamicItem;
			var i:IHeroDynamicItem;
		}
		/**
		 * @inheritDoc
		 */
		public function getAllHeroData():Vector.<IHeroDynamicItem>
		{
			return Vector.<IHeroDynamicItem>(getAllItems());
		}
	}
}