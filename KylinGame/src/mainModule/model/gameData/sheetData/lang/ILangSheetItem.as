package mainModule.model.gameData.sheetData.lang
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;
	/**
	 * 语言包配置文件 
	 * @author Edward
	 * 
	 */
	public interface ILangSheetItem extends IBaseSheetItem
	{
		/**
		 * 描述 
		 */
		function get desc():String;
		/**
		 * 名字 
		 */
		function get name():String;
	}
}