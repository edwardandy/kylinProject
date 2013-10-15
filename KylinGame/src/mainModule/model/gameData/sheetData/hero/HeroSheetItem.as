package mainModule.model.gameData.sheetData.hero
{
	import mainModule.model.gameData.sheetData.BaseMoveFighterSheetItem;

	/**
	 * 英雄数值表项 
	 * @author Edward
	 * 
	 */	
	public class HeroSheetItem extends BaseMoveFighterSheetItem implements IHeroSheetItem
	{
		private var _minAtkGrowth:int;
		private var _maxAtkGrowth:int;
		private var _lifeGrowth:int;
		private var _potencyAtkGrowth:int;
		private var _potencyLifeGrowth:int;
		private var _rebirthTime:uint;
		private var _quality:uint;
		private var _canBuy:uint;
		private var _buyMoney:int;
		private var _needHonor:int;
		private var _attributeDesc:int;
		private var _measurement:String;
		private var _isOpen:Boolean;
		
		/**
		 * 英雄数值表项 
		 * @author Edward
		 * 
		 */	
		public function HeroSheetItem()
		{
			super();
		}

		/**
		 * 是否已开放 
		 */
		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		/**
		 * @private
		 */
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
		}

		/**
		 * 英雄间的属性对比 0-8格
		 */
		public function get measurement():String
		{
			return _measurement;
		}

		/**
		 * @private
		 */
		public function set measurement(value:String):void
		{
			_measurement = value;
		}

		/**
		 * 属性描述id
		 */
		public function get attributeDesc():int
		{
			return _attributeDesc;
		}

		/**
		 * @private
		 */
		public function set attributeDesc(value:int):void
		{
			_attributeDesc = value;
		}

		/**
		 * 购买所需荣誉 
		 */
		public function get needHonor():int
		{
			return _needHonor;
		}

		/**
		 * @private
		 */
		public function set needHonor(value:int):void
		{
			_needHonor = value;
		}

		/**
		 * 购买所需价格
		 */
		public function get buyMoney():int
		{
			return _buyMoney;
		}

		/**
		 * @private
		 */
		public function set buyMoney(value:int):void
		{
			_buyMoney = value;
		}

		/**
		 * 可以购买 :0不可买1可以
		 */
		public function get canBuy():uint
		{
			return _canBuy;
		}

		/**
		 * @private
		 */
		public function set canBuy(value:uint):void
		{
			_canBuy = value;
		}

		/**
		 * 品质
		 */
		public function get quality():uint
		{
			return _quality;
		}

		/**
		 * @private
		 */
		public function set quality(value:uint):void
		{
			_quality = value;
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

		/**
		 * 激发潜能生命力成长
		 */
		public function get potencyLifeGrowth():int
		{
			return _potencyLifeGrowth;
		}

		/**
		 * @private
		 */
		public function set potencyLifeGrowth(value:int):void
		{
			_potencyLifeGrowth = value;
		}

		/**
		 * 激发潜能攻击力成长
		 */
		public function get potencyAtkGrowth():int
		{
			return _potencyAtkGrowth;
		}

		/**
		 * @private
		 */
		public function set potencyAtkGrowth(value:int):void
		{
			_potencyAtkGrowth = value;
		}

		/**
		 * 血量成长值
		 */
		public function get lifeGrowth():int
		{
			return _lifeGrowth;
		}

		/**
		 * @private
		 */
		public function set lifeGrowth(value:int):void
		{
			_lifeGrowth = value;
		}

		/**
		 * 最大攻击成长值
		 */
		public function get maxAtkGrowth():int
		{
			return _maxAtkGrowth;
		}

		/**
		 * @private
		 */
		public function set maxAtkGrowth(value:int):void
		{
			_maxAtkGrowth = value;
		}

		/**
		 * 基础攻击成长值
		 */
		public function get minAtkGrowth():int
		{
			return _minAtkGrowth;
		}

		/**
		 * @private
		 */
		public function set minAtkGrowth(value:int):void
		{
			_minAtkGrowth = value;
		}

	}
}