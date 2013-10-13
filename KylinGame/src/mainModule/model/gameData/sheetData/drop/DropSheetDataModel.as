package mainModule.model.gameData.sheetData.drop
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IDropSheetDataModel;

	/**
	 * 掉落包数值表 
	 * @author Edward
	 * 
	 */	
	public class DropSheetDataModel extends BaseSheetDataModel implements IDropSheetDataModel
	{
		public function DropSheetDataModel()
		{
			super();
			sheetName = "dropSheetItem";
			sheetClass = DropSheetItem;
		}
		/**
		 * @inheritDoc
		 */		
		public function getDropSheetById(id:uint):DropSheetItem
		{
			return genSheetElement(id) as DropSheetItem;
		}
	}
}