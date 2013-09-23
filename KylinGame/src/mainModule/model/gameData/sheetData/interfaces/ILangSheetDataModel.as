package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.lang.LangSheetItem;

	/**
	 * 语言包数据 
	 * @author Edward
	 * 
	 */	
	public interface ILangSheetDataModel
	{
		/**
		 * 通过id获得名字和描述信息 
		 * @param id
		 * @return 
		 * 
		 */		
		function getLangSheetById(id:uint):LangSheetItem;
	}
}