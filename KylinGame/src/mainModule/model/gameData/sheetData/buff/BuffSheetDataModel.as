package mainModule.model.gameData.sheetData.buff
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * buff数值表 
	 * @author Edward
	 * 
	 */	
	public class BuffSheetDataModel extends BaseSheetDataModel implements IBuffSheetDataModel
	{
		public function BuffSheetDataModel()
		{
			super();
			sheetName = "buffSheetData";
			sheetClass = BuffSheetItem;
		}
		
		public function getBuffSheetById(id:uint):IBuffSheetItem
		{
			return genSheetElement(id) as IBuffSheetItem;
		}
	}
}