package mainModule.model.gameData.sheetData.tower
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ITowerSheetDataModel;

	/**
	 * 塔数值表 
	 * @author Edward
	 * 
	 */	
	public class TowerSheetDataModel extends BaseSheetDataModel implements ITowerSheetDataModel
	{
		public function TowerSheetDataModel()
		{
			super();
			sheetName = "towerSheetData";
			sheetClass = TowerSheetItem;
		}
		
		public function getTowerSheetById(id:uint):TowerSheetItem
		{
			return genSheetElement(id) as TowerSheetItem;
		}
	}
}