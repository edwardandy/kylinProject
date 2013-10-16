package mainModule.model.gameData.sheetData.subwave
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;

	/**
	 * 出怪小波次数值表项 
	 * @author Edward
	 * 
	 */
	public class SubwaveSheetItem extends BaseSheetItem implements ISubwaveSheetItem
	{
		private var _roadType:int;
		private var _times:int;
		private var _interval:int;
		private var _startTime:int;
		private var _roadIndex:int;
		private var _monsterTypeId:uint;
		private var _monsterCount:int;
		
		public function SubwaveSheetItem()
		{
			super();
		}

		/**
		 * 出怪总数量 
		 */
		public function get monsterCount():int
		{
			return _monsterCount;
		}

		/**
		 * @private
		 */
		public function set monsterCount(value:int):void
		{
			_monsterCount = value;
		}

		/**
		 * 出怪的怪物id 
		 */
		public function get monsterTypeId():uint
		{
			return _monsterTypeId;
		}

		/**
		 * @private
		 */
		public function set monsterTypeId(value:uint):void
		{
			_monsterTypeId = value;
		}

		/**
		 * 有多少条路就给多少个编号
		 * 从零开始算 
		 */
		public function get roadIndex():int
		{
			return _roadIndex;
		}

		/**
		 * @private
		 */
		public function set roadIndex(value:int):void
		{
			_roadIndex = value;
		}

		/**
		 * 小波次在大波次上的出怪时间截点 
		 */
		public function get startTime():int
		{
			return _startTime;
		}

		/**
		 * @private
		 */
		public function set startTime(value:int):void
		{
			_startTime = value;
		}

		/**
		 * 小波次内怪物的平均间隔时间
		 * 必须被小波次时长整除
		 */
		public function get interval():int
		{
			return _interval;
		}

		/**
		 * @private
		 */
		public function set interval(value:int):void
		{
			_interval = value;
		}

		/**
		 * 出场次数
		 * monsterCount/times 必须是1到3之前的实数 
		 */
		public function get times():int
		{
			return _times;
		}

		/**
		 * @private
		 */
		public function set times(value:int):void
		{
			_times = value;
		}

		/**
		 * 跑道类型
		 *  0=随机
		 *	1=只在中间出现
		 */
		public function get roadType():int
		{
			return _roadType;
		}

		/**
		 * @private
		 */
		public function set roadType(value:int):void
		{
			_roadType = value;
		}

	}
}