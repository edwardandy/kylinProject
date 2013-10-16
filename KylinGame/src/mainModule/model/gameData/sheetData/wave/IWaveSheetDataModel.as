package mainModule.model.gameData.sheetData.wave
{

	/**
	 * 关卡出怪大波次数值表 
	 * @author Edward
	 * 
	 */
	public interface IWaveSheetDataModel
	{
		/**
		 * 通过大波次id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getWaveSheetById(id:uint):IWaveSheetItem;
	}
}