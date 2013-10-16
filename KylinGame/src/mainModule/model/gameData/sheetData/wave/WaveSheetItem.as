package mainModule.model.gameData.sheetData.wave
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;

	/**
	 * 出怪大波次数值表项 
	 * @author Edward
	 * 
	 */
	public class WaveSheetItem extends BaseSheetItem implements IWaveSheetItem
	{
		private var _arrSubWaves:Array;
		private var _time:uint;
		public function WaveSheetItem()
		{
			super();
		}
		
		/**
		 * 波次时长 
		 */
		public function get time():uint
		{
			return _time;
		}

		/**
		 * @private
		 */
		public function set time(value:uint):void
		{
			_time = value;
		}

		public function set subWaves(sub:String):void
		{
			if(!sub)
				return;
			_arrSubWaves = sub.split(",");
		}
		/**
		 * 子波次配置id列表 
		 * @return 
		 * 
		 */		
		public function get arrSubWaves():Array
		{
			return _arrSubWaves;
		}
	}
}