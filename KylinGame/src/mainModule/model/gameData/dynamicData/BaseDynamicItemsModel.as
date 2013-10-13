package mainModule.model.gameData.dynamicData
{
	/**
	 * 具有一组动态项的数据，比如一组英雄数据
	 * {dynamicItems=>{180001=>{id=>180001,,,}...},,,} 
	 * @author Edward
	 * 
	 */	
	public class BaseDynamicItemsModel extends BaseDynamicDataModel
	{
		protected var _vecItems:Vector.<BaseDynamicItem>;
		/**
		 * 动态数据项的类型 
		 */		
		protected var itemClazz:Class;
		
		public function BaseDynamicItemsModel()
		{
			super();
			_vecItems = new Vector.<BaseDynamicItem>;
		}
		
		public function set dynamicItems(items:Object):void
		{
			if(!items)
				return;
			var item:BaseDynamicItem;
			for(var id:* in items)
			{
				item = getItemById(id);
				if(!item)
				{
					item = new itemClazz;
					_vecItems.push(item);
					item.beFilled(items[id]);
					onItemAdd(item);
				}
				else
					item.beFilled(items[id]);
			}	
		}
		/**
		 *  通过id获取动态项
		 * @param id
		 * @return 
		 * 
		 */		
		public function getItemById(id:uint):BaseDynamicItem
		{
			for each(var item:BaseDynamicItem in _vecItems)
			{
				if(id == item.id)
					return item;
			}
			return null;
		}
		/**
		 * 获取所有动态项 
		 * @return 动态项数组
		 * 
		 */		
		protected function getAllItems():Vector.<BaseDynamicItem>
		{
			return _vecItems;
		}
		/**
		 * 数据项被添加 
		 * @param item
		 * 
		 */		
		protected function onItemAdd(item:BaseDynamicItem):void
		{
			
		}
		/**
		 * 数据项被移除
		 * @param item
		 * 
		 */
		protected function onItemRemove(item:BaseDynamicItem):void
		{
			
		}
	}
}