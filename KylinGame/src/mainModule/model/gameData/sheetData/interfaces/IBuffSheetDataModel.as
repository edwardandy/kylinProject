package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.buff.BuffSheetItem;

	/**
	 * buff数值表 
	 * @author Edward
	 * 
	 */	
	public interface IBuffSheetDataModel
	{
		/**
		 * 通过buff id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getBuffSheetById(id:uint):BuffSheetItem;
	}
}