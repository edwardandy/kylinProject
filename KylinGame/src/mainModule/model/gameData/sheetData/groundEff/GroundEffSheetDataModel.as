package mainModule.model.gameData.sheetData.groundEff
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 地表特效配置表数据 
	 * @author Edward
	 * 
	 */	
	public class GroundEffSheetDataModel extends BaseSheetDataModel implements IGroundEffSheetDataModel
	{
		public function GroundEffSheetDataModel()
		{
			super();
			sheetName = "groundEffectSheetData";
			sheetClass = GroundEffSheetItem;
		}
		
		public function getGroundEffSheetById(id:uint):IGroundEffSheetItem
		{
			return genSheetElement(id) as IGroundEffSheetItem;
		}
	}
}