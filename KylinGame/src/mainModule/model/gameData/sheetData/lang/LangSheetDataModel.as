package mainModule.model.gameData.sheetData.lang
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ILangSheetDataModel;

	/**
	 * 语言包数据 
	 * @author Edward
	 * 
	 */	
	public class LangSheetDataModel extends BaseSheetDataModel implements ILangSheetDataModel
	{
		public function LangSheetDataModel()
		{
			super();
			sheetName = "langSheetData";
			sheetClass = LangSheetItem;
		}
		
		public function getLangSheetById(id:uint):LangSheetItem
		{
			return genSheetElement(id) as LangSheetItem;
		}
	}
}