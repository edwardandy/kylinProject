package mainModule.model.gameData.sheetData
{
	/**
	 * 可移动的战斗单位 
	 * @author Edward
	 * 
	 */	
	public class BaseMoveFighterSheetItem extends BaseFighterSheetItem
	{
		private var _life:uint;
		private var _physicDef:int;
		private var _magicDef:int;
		private var _moveSpd:uint;
		private var _type:int;
		
		public function BaseMoveFighterSheetItem()
		{
			super();
		}

		/**
		 * 单位类型 1:陆地 2:空中飞行单位
		 */
		public function get type():int
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:int):void
		{
			_type = value;
		}

		/**
		 * 移动速度
		 */
		public function get moveSpd():uint
		{
			return _moveSpd;
		}

		/**
		 * @private
		 */
		public function set moveSpd(value:uint):void
		{
			_moveSpd = value;
		}

		/**
		 *法术防御力 
		 */
		public function get magicDef():int
		{
			return _magicDef;
		}

		/**
		 * @private
		 */
		public function set magicDef(value:int):void
		{
			_magicDef = value;
		}

		/**
		 *物理防御力 
		 */
		public function get physicDef():int
		{
			return _physicDef;
		}

		/**
		 * @private
		 */
		public function set physicDef(value:int):void
		{
			_physicDef = value;
		}

		/**
		 * 血量
		 */
		public function get life():uint
		{
			return _life;
		}

		/**
		 * @private
		 */
		public function set life(value:uint):void
		{
			_life = value;
		}

	}
}