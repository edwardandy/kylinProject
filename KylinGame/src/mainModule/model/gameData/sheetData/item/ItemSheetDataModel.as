package mainModule.model.gameData.sheetData.item
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IItemSheetDataModel;
	
	public class ItemSheetDataModel extends BaseSheetDataModel implements IItemSheetDataModel
	{
		public function ItemSheetDataModel()
		{
			super();
			sheetName = "itemSheetData";
			sheetClass = ItemSheetItem;
		}
		
		/**
		 * 通过道具id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getItemSheetById(id:uint):ItemSheetItem
		{
			return genSheetElement(id) as ItemSheetItem;
		}
	}
}