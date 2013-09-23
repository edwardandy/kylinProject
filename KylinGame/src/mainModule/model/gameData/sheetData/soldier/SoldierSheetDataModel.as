package mainModule.model.gameData.sheetData.soldier
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.hero.HeroSheetItem;
	import mainModule.model.gameData.sheetData.interfaces.ISoldierSheetDataModel;

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
		
		public function getSoldierSheetById(id:uint):SoldierSheetItem
		{
			return genSheetElement(id) as SoldierSheetItem;
		}
	}
}