package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.item.ItemSheetItem;

	/**
	 * 道具数值表 
	 * @author Edward
	 * 
	 */	
	public interface IItemSheetDataModel
	{
		/**
		 * 通过道具id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getItemSheetById(id:uint):ItemSheetItem;
	}
}