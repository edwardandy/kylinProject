package mainModule.model.gameData.sheetData.subwave
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ISubwaveSheetDataModel;

	/**
	 * 关卡出怪小波次数值表 
	 * @author Edward
	 * 
	 */
	public class SubwaveSheetDataModel extends BaseSheetDataModel implements ISubwaveSheetDataModel
	{
		public function SubwaveSheetDataModel()
		{
			super();
			sheetName = "subwaveSheetData";
			sheetClass = SubwaveSheetItem;
		}
		
		public function getSubwaveSheetById(id:uint):SubwaveSheetItem
		{
			return genSheetElement(id) as SubwaveSheetItem;
		}
	}
}