package mainModule.model.gameData.sheetData.wave
{
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;

	/**
	 * 出怪大波次数值表项 
	 * @author Edward
	 * 
	 */
	public class WaveSheetItem extends BaseDescSheetItem
	{
		private var _arrSubWaves:Array;
		/**
		 * 波次时长 
		 */		
		public var time:uint;
		public function WaveSheetItem()
		{
			super();
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