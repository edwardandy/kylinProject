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
		/**
		 * 兵营 
		 */		
		public static const TowerType_Barrack:int = 1;
		/**
		 * 箭塔 
		 */		
		public static const TowerType_Arrow:int = 2;
		/**
		 * 魔法塔 
		 */		
		public static const TowerType_Magic:int = 3;
		/**
		 * 炮塔 
		 */		
		public static const TowerType_Cannon:int = 4;
		
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