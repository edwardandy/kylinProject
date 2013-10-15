package mainModule.model.gameData.sheetData.drop
{
	/**
	 * 掉落包数值表 
	 * @author Edward
	 * 
	 */	
	public interface IDropSheetDataModel
	{
		/**
		 * 获取掉落数值项 
		 * @param id 掉落包id
		 * @return 
		 * 
		 */		
		function getDropSheetById(id:uint):IDropSheetItem;
	}
}