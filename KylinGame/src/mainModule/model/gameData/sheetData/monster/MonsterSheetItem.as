package mainModule.model.gameData.sheetData.monster
{
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.BaseMoveFighterSheetItem;

	/**
	 * 怪物数值表项 
	 * @author Edward
	 * 
	 */	
	public class MonsterSheetItem extends BaseMoveFighterSheetItem implements IMonsterSheetItem
	{
		private var _isBoss:Boolean;
		private var _killLife:uint;
		private var _rewardExp:uint;
		private var _rewardGoods:uint;
		private var _heroRewardGoods:uint;
		private var _heroKillScore:uint;
		private var _deadScore:uint;
		private var _canSummon:Boolean;
		private var _resId:int;
		
		private var _arrFeatureLanIds:Array = [];
		
		/**
		 * 使用的资源id 
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
		 * 击杀后积分
		 */
		public function get deadScore():uint
		{
			return _deadScore;
		}

		/**
		 * @private
		 */
		public function set deadScore(value:uint):void
		{
			_deadScore = value;
		}

		/**
		 * 英雄击杀额外积分
		 */
		public function get heroKillScore():uint
		{
			return _heroKillScore;
		}

		/**
		 * @private
		 */
		public function set heroKillScore(value:uint):void
		{
			_heroKillScore = value;
		}

		/**
		 * 被英雄击杀奖励额外货物
		 */
		public function get heroRewardGoods():uint
		{
			return _heroRewardGoods;
		}

		/**
		 * @private
		 */
		public function set heroRewardGoods(value:uint):void
		{
			_heroRewardGoods = value;
		}

		/**
		 * 击杀奖励货物
		 */
		public function get rewardGoods():uint
		{
			return _rewardGoods;
		}

		/**
		 * @private
		 */
		public function set rewardGoods(value:uint):void
		{
			_rewardGoods = value;
		}

		/**
		 * 击杀奖励经验
		 */
		public function get rewardExp():uint
		{
			return _rewardExp;
		}

		/**
		 * @private
		 */
		public function set rewardExp(value:uint):void
		{
			_rewardExp = value;
		}

		/**
		 * 伤害关卡生命
		 */
		public function get killLife():uint
		{
			return _killLife;
		}

		/**
		 * @private
		 */
		public function set killLife(value:uint):void
		{
			_killLife = value;
		}

		/**
		 * 是否boss
		 */
		public function get isBoss():Boolean
		{
			return _isBoss;
		}

		/**
		 * @private
		 */
		public function set isBoss(value:Boolean):void
		{
			_isBoss = value;
		}

		/**
		 * 怪物的第一个特点的描述的语言包ID 
		 */
		public function get arrFeatureLanIds():Array
		{
			return _arrFeatureLanIds;
		}

		public function set featureLanIds(value:String):void
		{
			_arrFeatureLanIds.length = 0;
			if(!value)
				return;
			_arrFeatureLanIds = KylinStringUtil.splitStringArrayToIntArray(value);
		}
		
		public function MonsterSheetItem()
		{
			super();
		}
	}
}