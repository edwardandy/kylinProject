package mainModule.model.gameData.dynamicData.user
{
	import mainModule.model.gameData.dynamicData.BaseDynamicDataModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;

	/**
	 * 用户动态信息数据 
	 * @author Edward
	 * 
	 */	
	public class UserDynamicDataModel extends BaseDynamicDataModel implements IUserDynamicDataModel
	{
		private var _continuouslyLoginDays:int = 0;
		private var _todayLoginTimes:int = 0;		
		private var _firstName:String = "";	
		private var _fullName:String = "";
		private var _sex:int;
		private var _platformId:String;
		private var _lastEnegyRecoverTime:uint;
		private var _vipLevel:uint;	
		private var _exp:uint = 0;
		private var _level:int = 1;
		private var _honor:uint = 0;
		private var _diamonds:uint;
		private var _energy:uint;	
		private var _golds:uint;
		private var _bagNum:uint;
		
		public function UserDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.UserData;
			updateEventType = "";
		}
		/**
		 * vip等级
		 */
		public function get vipLevel():uint
		{
			return _vipLevel;
		}

		/**
		 * @private
		 */
		public function set vipLevel(value:uint):void
		{
			_vipLevel = value;
		}

		/**
		 * 能量上一次恢复时间
		 */
		public function get lastEnegyRecoverTime():uint
		{
			return _lastEnegyRecoverTime;
		}

		/**
		 * @private
		 */
		public function set lastEnegyRecoverTime(value:uint):void
		{
			_lastEnegyRecoverTime = value;
		}

		/**
		 * 平台id
		 */
		public function get platformId():String
		{
			return _platformId;
		}

		/**
		 * @private
		 */
		public function set platformId(value:String):void
		{
			_platformId = value;
		}

		/**
		 * 性别 1是女 2是男
		 */
		public function get sex():int
		{
			return _sex;
		}

		/**
		 * @private
		 */
		public function set sex(value:int):void
		{
			_sex = value;
		}

		/**
		 * 全名
		 */
		public function get fullName():String
		{
			return _fullName;
		}

		/**
		 * @private
		 */
		public function set fullName(value:String):void
		{
			_fullName = value;
		}

		/**
		 * 名字
		 */
		public function get firstName():String
		{
			return _firstName;
		}

		/**
		 * @private
		 */
		public function set firstName(value:String):void
		{
			_firstName = value;
		}

		/**
		 * 当天登录次数 
		 */
		public function get todayLoginTimes():int
		{
			return _todayLoginTimes;
		}

		/**
		 * @private
		 */
		public function set todayLoginTimes(value:int):void
		{
			_todayLoginTimes = value;
		}

		/**
		 * 连续登录的天数 
		 */
		public function get continuouslyLoginDays():int
		{
			return _continuouslyLoginDays;
		}

		/**
		 * @private
		 */
		public function set continuouslyLoginDays(value:int):void
		{
			_continuouslyLoginDays = value;
		}

		/**
		 * 等级 
		 */
		public function get level():int
		{
			return _level;
		}
		/**
		 * 玩家经验 
		 */	
		public function get exp():uint
		{
			return _exp;
		}
		public function set exp( value:uint ):void
		{
			if (value == _exp)
				return;
			_exp = value;
			//todo update level
		}
		/**
		 * 玩家当前荣誉 
		 */		
		public function get honor():uint
		{
			return _honor;
		}
		public function set honor( value:uint ):void
		{
			if(value == _honor)
				return;
			_honor = value;
		}
		/**
		 * 背包格子数量
		 */
		public function get bagNum():int 
		{
			return _bagNum;
		}
		
		public function set bagNum(value:int):void 
		{
			_bagNum = value;
		}
		/**
		 * 用户平台币数
		 */
		public function get diamonds():uint
		{
			return _diamonds;
		}
		/**
		 * @private
		 */
		public function set diamonds(value:uint):void
		{
			if ( _diamonds == value )
				return;
			_diamonds = value;
		}
		/**
		 * 用户金币数
		 */
		public function get golds():uint
		{
			return _golds;
		}
		/**
		 * @private
		 */
		public function set golds(value:uint):void
		{
			if ( value == _golds )
				return;
			_golds = value;
		}
		/**
		 * 用户当前能量值
		 */
		public function get energy():uint
		{
			return _energy;
		}
		/**
		 * @private
		 */
		public function set energy(value:uint):void
		{
			_energy = value;
		}
	}
}