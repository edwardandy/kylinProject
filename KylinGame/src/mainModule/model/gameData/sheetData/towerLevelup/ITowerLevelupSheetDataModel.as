package mainModule.model.gameData.sheetData.towerLevelup
{
	/**
	 * 塔升级的数据，包括cd，数值成长， 消耗
	 * @author Edward
	 * 
	 */
	public interface ITowerLevelupSheetDataModel
	{
		/**
		 * 通过等级获得塔升级数据 
		 * @param lvl
		 * @return 
		 * 
		 */		
		function getTowerLevelupSheetByLvl(lvl:int):ITowerLevelupSheetItem;
	}
}