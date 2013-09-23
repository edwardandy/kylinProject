package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.tower.TowerSheetItem;

	/**
	 * 塔数值表 
	 * @author Edward
	 * 
	 */	
	public interface ITowerSheetDataModel
	{
		/**
		 * 通过塔id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getTowerSheetById(id:uint):TowerSheetItem;
	}
}