package mainModule.model.gameData.sheetData.drop
{
	import flash.utils.Dictionary;
	
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;

	/**
	 * 掉落数值项 
	 * @author Edward
	 * 
	 */	
	public interface IDropSheetItem extends IBaseSheetItem
	{
		/**
		 * 掉落道具 
		 * @return itemId:num;itemId:num;...
		 * 
		 */		
		function get dicDropItems():Dictionary;
	}
}