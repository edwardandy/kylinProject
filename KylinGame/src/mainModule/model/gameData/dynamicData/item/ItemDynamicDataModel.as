package mainModule.model.gameData.dynamicData.item
{
	import mainModule.controller.gameData.GameDataUpdateEvent;
	import mainModule.model.gameData.dynamicData.BaseDynamicItemsModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;

	/**
	 * 道具动态数据 
	 * @author Edward
	 * 
	 */	
	public class ItemDynamicDataModel extends BaseDynamicItemsModel implements IItemDynamicDataModel
	{
		public function ItemDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.ItemData;
			updateEventType = GameDataUpdateEvent.GameDataUpdate_ItemData;
			itemClazz = ItemDynamicItem;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAllItemData():Vector.<IItemDynamicItem>
		{
			return Vector.<IItemDynamicItem>(getAllItems());
		}
		/**
		 * @inheritDoc
		 */
		public function getItemCountById(itemId:uint):int
		{
			var cnt:int;
			for each(var item:IItemDynamicItem in _vecItems)
			{
				if(itemId == item.itemId)
					cnt += item.num;
			}
			return cnt;
		}
	}
}