package mainModule.model.gameData.sheetData.lang
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

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
		
		public function getLangSheetById(id:uint):ILangSheetItem
		{
			return genSheetElement(id) as ILangSheetItem;
		}
	}
}