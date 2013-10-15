package mainModule.model.gameData.sheetData.groundEff
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;

	/**
	 * 地表特效动态项 
	 * @author Edward
	 * 
	 */	
	public class GroundEffSheetItem extends BaseSheetItem implements IGroundEffSheetItem
	{
		private var _range:int;
		
		private var _mode:Array;
		private var _canAirFight:int;
		
		public function GroundEffSheetItem()
		{
			super();
		}

		/**
		 * 是否对空 0：只对地  1：对地对空 2:只对空
		 */
		public function get canAirFight():int
		{
			return _canAirFight;
		}

		/**
		 * @private
		 */
		public function set canAirFight(value:int):void
		{
			_canAirFight = value;
		}

		/**
		 * 影响范围
		 */
		public function get range():int
		{
			return _range;
		}

		/**
		 * @private
		 */
		public function set range(value:int):void
		{
			_range = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get modeFields():Array
		{
			return _mode;
		}
		
		public function set mode(str:String):void
		{
			_mode = str.split(",");
		}
	}
}