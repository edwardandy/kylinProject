package mainModule.model.gameData.sheetData.drop
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

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
		public function getDropSheetById(id:uint):IDropSheetItem
		{
			return genSheetElement(id) as IDropSheetItem;
		}
	}
}