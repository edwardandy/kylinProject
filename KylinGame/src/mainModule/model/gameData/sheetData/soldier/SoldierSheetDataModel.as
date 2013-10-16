package mainModule.model.gameData.sheetData.soldier
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 士兵或援兵或己方召唤生物数值表 
	 * @author Edward
	 * 
	 */	
	public class SoldierSheetDataModel extends BaseSheetDataModel implements ISoldierSheetDataModel
	{
		public function SoldierSheetDataModel()
		{
			super();
			sheetName = "soldierSheetData";
			sheetClass = SoldierSheetItem;
		}
		
		public function getSoldierSheetById(id:uint):ISoldierSheetItem
		{
			return genSheetElement(id) as ISoldierSheetItem;
		}
	}
}