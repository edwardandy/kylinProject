package mainModule.model.gameData.sheetData.soldier
{
	import mainModule.model.gameData.sheetData.BaseMoveFighterSheetItem;
	/**
	 * 士兵数值表项 
	 * @author Edward
	 * 
	 */	
	public class SoldierSheetItem extends BaseMoveFighterSheetItem implements ISoldierSheetItem
	{
		private var _rebirthTime:uint;
		private var _canSummon:Boolean;
		private var _resId:int;
		private var _descId:int;
		
		public function SoldierSheetItem()
		{
			super();
		}

		/**
		 * 名字和描述所使用的id 
		 */
		public function get descId():int
		{
			return _descId;
		}

		/**
		 * @private
		 */
		public function set descId(value:int):void
		{
			_descId = value;
		}

		/**
		 * 资源id 
		 */
		public function get resId():int
		{
			return _resId;
		}

		/**
		 * @private
		 */
		public function set resId(value:int):void
		{
			_resId = value;
		}

		/**
		 * 是否可召唤
		 */
		public function get canSummon():Boolean
		{
			return _canSummon;
		}

		/**
		 * @private
		 */
		public function set canSummon(value:Boolean):void
		{
			_canSummon = value;
		}

		/**
		 * 复活时间
		 */
		public function get rebirthTime():uint
		{
			return _rebirthTime;
		}

		/**
		 * @private
		 */
		public function set rebirthTime(value:uint):void
		{
			_rebirthTime = value;
		}

	}
}