package mainModule.model.gameData.sheetData.lang
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;
	/**
	 * 语言包配置文件 
	 * @author Edward
	 * 
	 */	
	public class LangSheetItem extends BaseSheetItem implements ILangSheetItem
	{
		private var _name:String;
		private var _desc:String;
		
		public function LangSheetItem()
		{
			super();
		}

		/**
		 * 描述 
		 */
		public function get desc():String
		{
			return _desc;
		}

		/**
		 * @private
		 */
		public function set desc(value:String):void
		{
			_desc = value;
		}

		/**
		 * 名字 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

	}
}