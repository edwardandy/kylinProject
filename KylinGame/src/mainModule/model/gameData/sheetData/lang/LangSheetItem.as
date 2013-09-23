package mainModule.model.gameData.sheetData.lang
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;
	/**
	 * 语言包配置文件 
	 * @author Edward
	 * 
	 */	
	public class LangSheetItem extends BaseSheetItem
	{
		/**
		 * 名字 
		 */		
		public var name:String;
		/**
		 * 描述 
		 */		
		public var desc:String;
		
		public function LangSheetItem()
		{
			super();
		}
	}
}