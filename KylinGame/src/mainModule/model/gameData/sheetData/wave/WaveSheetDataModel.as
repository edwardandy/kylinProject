package mainModule.model.gameData.sheetData.wave
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	/**
	 * 关卡出怪大波次数值表 
	 * @author Edward
	 * 
	 */
	public class WaveSheetDataModel extends BaseSheetDataModel implements IWaveSheetDataModel
	{
		public function WaveSheetDataModel()
		{
			super();
			sheetName = "waveSheetData";
			sheetClass = WaveSheetItem;
		}
		
		public function getWaveSheetById(id:uint):IWaveSheetItem
		{
			return genSheetElement(id) as IWaveSheetItem;
		}
	}
}