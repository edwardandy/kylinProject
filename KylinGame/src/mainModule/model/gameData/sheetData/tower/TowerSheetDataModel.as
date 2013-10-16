package mainModule.model.gameData.sheetData.tower
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

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
		
		public function getTowerSheetById(id:uint):ITowerSheetItem
		{
			return genSheetElement(id) as ITowerSheetItem;
		}
	}
}