package mainModule.model.gameData.sheetData.towerLevelup
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 塔升级的数据，包括cd，数值成长， 消耗
	 * @author Edward
	 * 
	 */	
	public class TowerLevelupSheetDataModel extends BaseSheetDataModel
	{
		public function TowerLevelupSheetDataModel()
		{
			super();
			sheetName = "towerLevelupSheetData";
			sheetClass = TowerLevelupSheetItem;
		}
		/**
		 * 通过等级获得塔升级数据 
		 * @param lvl
		 * @return 
		 * 
		 */		
		public function getTowerLevelupSheetByLvl(lvl:int):TowerLevelupSheetItem
		{
			return genSheetElement(lvl) as TowerLevelupSheetItem;
		}
	}
}