package mainModule.model.gameData.dynamicData.item
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItem;
	/**
	 * 道具动态项 
	 * @author Edward
	 * 
	 */
	public interface IItemDynamicItem extends IBaseDynamicItem
	{
		/**
		 * 道具数量 
		 */
		function get num():int;
		/**
		 * 道具模板id 
		 */
		function get itemId():uint;
	}
}