package mainModule.model.gameData.sheetData.towerLevelup
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 塔升级的数据，包括cd，数值成长， 消耗
	 * @author Edward
	 * 
	 */	
	public class TowerLevelupSheetDataModel extends BaseSheetDataModel implements ITowerLevelupSheetDataModel
	{
		public function TowerLevelupSheetDataModel()
		{
			super();
			sheetName = "towerLevelupSheetData";
			sheetClass = TowerLevelupSheetItem;
		}
		/**
		 * @inheritDoc 
		 */		
		public function getTowerLevelupSheetByLvl(lvl:int):ITowerLevelupSheetItem
		{
			return genSheetElement(lvl) as ITowerLevelupSheetItem;
		}
	}
}