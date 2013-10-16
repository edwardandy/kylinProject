package mainModule.model.gameData.sheetData.tower
{

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
		function getTowerSheetById(id:uint):ITowerSheetItem;
	}
}