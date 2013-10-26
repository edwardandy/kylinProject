package mainModule.model.gameData.dynamicData.item
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItemsModel;
	/**
	 * 道具动态数据 
	 * @author Edward
	 * 
	 */
	public interface IItemDynamicDataModel extends IBaseDynamicItemsModel
	{
		/**
		 * 获取所有道具动态数据 
		 * @return 
		 * 
		 */		
		function getAllItemData():Vector.<IItemDynamicItem>;
		/**
		 * 通过id获取道具数量 
		 * @param itemId
		 * @return 
		 * 
		 */		
		function getItemCountById(itemId:uint):int;
	}
}