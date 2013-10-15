package mainModule.model.gameData.dynamicData.interfaces
{
	/**
	 * 动态数据基础项，比如每个英雄的动态数据，每个法术的动态数据 
	 * @author Edward
	 * 
	 */	
	public interface IBaseDynamicItem
	{
		/**
		 * 数据项的唯一id 
		 */
		function get id():uint;
	}
}