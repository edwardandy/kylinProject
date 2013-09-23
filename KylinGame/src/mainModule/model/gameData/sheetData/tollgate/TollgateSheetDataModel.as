package mainModule.model.gameData.sheetData.tollgate
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ITollgateSheetDataModel;

	/**
	 * 关卡数值表 
	 * @author Edward
	 * 
	 */
	public class TollgateSheetDataModel extends BaseSheetDataModel implements ITollgateSheetDataModel
	{
		public function TollgateSheetDataModel()
		{
			super();
			sheetName = "tollgateSheetData";
			sheetClass = TollgateSheetItem;
		}
		
		public function getTollgateSheetById(id:uint):TollgateSheetItem
		{
			return genSheetElement(id) as TollgateSheetItem;
		}
	}
}