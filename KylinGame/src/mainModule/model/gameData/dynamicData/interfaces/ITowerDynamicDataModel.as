package mainModule.model.gameData.dynamicData.interfaces
{
	import mainModule.model.gameData.dynamicData.tower.TowerDynamicItem;

	/**
	 * 塔的动态数据 
	 * @author Edward
	 * 
	 */
	public interface ITowerDynamicDataModel
	{
		/**
		 * 获得指定塔的动态项 
		 * @param id 塔的模板id
		 * @return 
		 * 
		 */		
		function getTowerDataById(id:uint):TowerDynamicItem;
		/**
		 * 获得指定类型的塔的等级 
		 * @param iType 
		 * @return 
		 * 
		 */		
		function getTowerLevelByType(iType:int):int;
	}
}