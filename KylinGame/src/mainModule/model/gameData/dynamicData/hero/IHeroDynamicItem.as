package mainModule.model.gameData.dynamicData.hero
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItem;

	/**
	 * 每个英雄的动态数据项 
	 * @author Edward
	 * 
	 */
	public interface IHeroDynamicItem extends IBaseDynamicItem
	{
		/**
		 * 当前经验
		 */
		function get exp():uint;
		/**
		 * 等级
		 */
		function get level():uint;	
		/**
		 * 已激活的天赋列表: id1,id2,id3 
		 */
		function get arrTalents():Array;
	}
}