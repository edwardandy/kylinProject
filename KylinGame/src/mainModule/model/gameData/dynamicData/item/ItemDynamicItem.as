package mainModule.model.gameData.dynamicData.item
{
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;
	/**
	 * 道具动态项 
	 * @author Edward
	 * 
	 */	
	public class ItemDynamicItem extends BaseDynamicItem implements IItemDynamicItem
	{
		private var _itemId:uint;
		private var _num:int;
		
		public function ItemDynamicItem()
		{
			super();
		}

		/**
		 * 道具数量 
		 */
		public function get num():int
		{
			return _num;
		}

		/**
		 * @private
		 */
		public function set num(value:int):void
		{
			_num = value;
		}

		/**
		 * 道具模板id 
		 */
		public function get itemId():uint
		{
			return _itemId;
		}

		/**
		 * @private
		 */
		public function set itemId(value:uint):void
		{
			_itemId = value;
		}

	}
}