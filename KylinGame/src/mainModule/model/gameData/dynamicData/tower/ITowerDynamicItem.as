package mainModule.model.gameData.dynamicData.tower
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItem;

	/**
	 * 防御塔动态项 
	 * @author Edward
	 * 
	 */
	public interface ITowerDynamicItem extends IBaseDynamicItem
	{
		/**
		 * 防御塔解锁的技能id数组 
		 * @return 
		 * 
		 */		
		function get arrSkills():Array;
	}
}