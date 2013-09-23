package mainModule.model.gameData.sheetData
{
	import mainModule.model.gameData.sheetData.interfaces.ILangSheetDataModel;
	import mainModule.model.gameData.sheetData.lang.LangSheetItem;

	/**
	 * 名字和描述信息 
	 * @author Edward
	 * 
	 */	
	public class BaseDescSheetItem extends BaseSheetItem
	{
		[Inject]
		public var langData:ILangSheetDataModel;
		
		public function BaseDescSheetItem()
		{
			super();
		}
		
		public function getName(specialId:uint = 0):String
		{
			var item:LangSheetItem = langData.getLangSheetById(specialId?specialId:configId);
			if(item)
				return item.name;
			return "";
		}
		
		public function getDesc(specialId:uint = 0):String
		{
			var item:LangSheetItem = langData.getLangSheetById(specialId?specialId:configId);
			if(item)
				return item.desc;
			return "";
		}
	}
}