package mainModule.model.gameData.sheetData.item
{
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;

	/**
	 * 道具数值表项 
	 * @author Edward
	 * 
	 */
	public class ItemSheetItem extends BaseDescSheetItem implements IItemSheetItem
	{
		private var _type:uint;
		private var _fightUse:Boolean;
		private var _salePrice:uint;
		private var _effectValue:String;
		private var _effectType:uint;
		private var _isShow:Boolean;
		private var _isHot:Boolean;
		private var _buyPriceGold:uint;
		private var _buyPriceMoney:uint;
		private var _superpose:uint;
		private var _isCombined:int;
		private var _needNum:int;
		private var _rewardScore:int;
		private var _canFeed:Boolean;
		private var _level:uint;
		private var _originDesc:int;
		private var _usageDesc:String;
		private var _label:int;
		private var _resId:uint;
		private var _canAskFor:int;
		private var _order:int;
		private var _canGetItFight:int;
		private var _limit:int = -1;
		
		public function ItemSheetItem()
		{
			super();
		}

		/**
		 * 商城里可以购买的数量，购买后会变化 ,默认-1为无限制
		 */
		public function get limit():int
		{
			return _limit;
		}

		/**
		 * @private
		 */
		public function set limit(value:int):void
		{
			_limit = value;
		}

		/**
		 * 是否可从战斗中获得:0不能1能
		 */
		public function get canGetItFight():int
		{
			return _canGetItFight;
		}

		/**
		 * @private
		 */
		public function set canGetItFight(value:int):void
		{
			_canGetItFight = value;
		}

		/**
		 * 排序 
		 */
		public function get order():int
		{
			return _order;
		}

		/**
		 * @private
		 */
		public function set order(value:int):void
		{
			_order = value;
		}

		/**
		 * 是否可向好友索要:0不能1能 
		 */
		public function get canAskFor():int
		{
			return _canAskFor;
		}

		/**
		 * @private
		 */
		public function set canAskFor(value:int):void
		{
			_canAskFor = value;
		}

		/**
		 * 道具的icon，如果为0，则用自身id 
		 */
		public function get resId():uint
		{
			return _resId;
		}

		/**
		 * @private
		 */
		public function set resId(value:uint):void
		{
			_resId = value;
		}

		/**
		 * 在商店里的标签 
		 */
		public function get label():int
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:int):void
		{
			_label = value;
		}

		/**
		 * 物品用途描述 
		 */
		public function get usageDesc():String
		{
			return _usageDesc;
		}

		/**
		 * @private
		 */
		public function set usageDesc(value:String):void
		{
			_usageDesc = value;
		}

		/**
		 * 来源id 
		 */
		public function get originDesc():int
		{
			return _originDesc;
		}

		/**
		 * @private
		 */
		public function set originDesc(value:int):void
		{
			_originDesc = value;
		}

		/**
		 * 等级(英雄技能书等级--英雄技能升级) 
		 */
		public function get level():uint
		{
			return _level;
		}

		/**
		 * @private
		 */
		public function set level(value:uint):void
		{
			_level = value;
		}

		/**
		 *否是免费礼物 
		 */
		public function get canFeed():Boolean
		{
			return _canFeed;
		}

		/**
		 * @private
		 */
		public function set canFeed(value:Boolean):void
		{
			_canFeed = value;
		}

		/**
		 *使用积分 
		 * 使用时会奖励积分
		 */
		public function get rewardScore():int
		{
			return _rewardScore;
		}

		/**
		 * @private
		 */
		public function set rewardScore(value:int):void
		{
			_rewardScore = value;
		}

		/**
		 * 合成个数
		 */
		public function get needNum():int
		{
			return _needNum;
		}

		/**
		 * @private
		 */
		public function set needNum(value:int):void
		{
			_needNum = value;
		}

		/**
		 * 是否可合成
		 */
		public function get isCombined():int
		{
			return _isCombined;
		}

		/**
		 * @private
		 */
		public function set isCombined(value:int):void
		{
			_isCombined = value;
		}

		/**
		 * 叠加数量
		 */
		public function get superpose():uint
		{
			return _superpose;
		}

		/**
		 * @private
		 */
		public function set superpose(value:uint):void
		{
			_superpose = value;
		}

		/**
		 * 宝石价格
		 */
		public function get buyPriceMoney():uint
		{
			return _buyPriceMoney;
		}

		/**
		 * @private
		 */
		public function set buyPriceMoney(value:uint):void
		{
			_buyPriceMoney = value;
		}

		/**
		 * 购买所需金币
		 */
		public function get buyPriceGold():uint
		{
			return _buyPriceGold;
		}

		/**
		 * @private
		 */
		public function set buyPriceGold(value:uint):void
		{
			_buyPriceGold = value;
		}

		/**
		 *是否热卖 
		 */
		public function get isHot():Boolean
		{
			return _isHot;
		}

		/**
		 * @private
		 */
		public function set isHot(value:Boolean):void
		{
			_isHot = value;
		}

		/**
		 * 是否商城可见 是否可以在商城买到 1是可以买到 0是不可以买到
		 */
		public function get isShow():Boolean
		{
			return _isShow;
		}

		/**
		 * @private
		 */
		public function set isShow(value:Boolean):void
		{
			_isShow = value;
		}

		/**
		 * 效果类型
		 */
		public function get effectType():uint
		{
			return _effectType;
		}

		/**
		 * @private
		 */
		public function set effectType(value:uint):void
		{
			_effectType = value;
		}

		/**
		 * 效果值 4:5代表 4为效果类型 5为具体数值 如果是宝箱就调取dropInfo
		 */
		public function get effectValue():String
		{
			return _effectValue;
		}

		/**
		 * @private
		 */
		public function set effectValue(value:String):void
		{
			_effectValue = value;
		}

		/**
		 * 出售价格 0为不可出售 其他数字为出售价格
		 */
		public function get salePrice():uint
		{
			return _salePrice;
		}

		/**
		 * @private
		 */
		public function set salePrice(value:uint):void
		{
			_salePrice = value;
		}

		/**
		 * 是否可战斗中使用  0 不可以  1 可以
		 */
		public function get fightUse():Boolean
		{
			return _fightUse;
		}

		/**
		 * @private
		 */
		public function set fightUse(value:Boolean):void
		{
			_fightUse = value;
		}

		/**
		 * 道具类型 1:消耗 , 2:宝箱, 3:材料 , 4:技能升级书 , 5:皮肤 , 6技能书
		 */
		public function get type():uint
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:uint):void
		{
			_type = value;
		}

	}
}