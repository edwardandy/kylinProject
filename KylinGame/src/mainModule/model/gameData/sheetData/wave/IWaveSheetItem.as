package mainModule.model.gameData.sheetData.wave
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;
	/**
	 * 出怪大波次数值表项 
	 * @author Edward
	 * 
	 */
	public interface IWaveSheetItem extends IBaseSheetItem
	{
		/**
		 * 波次时长 
		 */
		function get time():uint;
		/**
		 * 子波次配置id列表 
		 * @return 
		 * 
		 */		
		function get arrSubWaves():Array;
	}
}