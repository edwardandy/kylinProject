package mainModule.model.gameData.sheetData.hero
{
	import mainModule.model.gameData.sheetData.BaseMoveFighterSheetItem;

	/**
	 * 英雄数值表项 
	 * @author Edward
	 * 
	 */	
	public class HeroSheetItem extends BaseMoveFighterSheetItem
	{
		/**
		 * 基础攻击成长值
		 */
		public var minAtkGrowth:int;
		/**
		 * 最大攻击成长值
		 */
		public var maxAtkGrowth:int;
		/**
		 * 血量成长值
		 */
		public var lifeGrowth:int;
		/**
		 * 激发潜能攻击力成长
		 */
		public var potencyAtkGrowth:int;
		/**
		 * 激发潜能生命力成长
		 */
		public var potencyLifeGrowth:int;
		/**
		 * 复活时间
		 */
		public var rebirthTime:uint;
		/**
		 * 品质
		 */
		public var quality:uint;
		/**
		 * 可以购买 :0不可买1可以
		 */		
		public var canBuy:uint;
		/**
		 * 购买所需价格
		 */		
		public var buyMoney:int;
		/**
		 * 购买所需荣誉 
		 */		
		public var needHonor:int;
		/**
		 * 属性描述id
		 */		
		public var attributeDesc:int;
		
		/**
		 * 英雄间的属性对比 0-8格
		 */		
		public var measurement:String;
		
		/**
		 * 是否已开放 
		 */
		public var isOpen:Boolean;
		
		/**
		 * 英雄数值表项 
		 * @author Edward
		 * 
		 */	
		public function HeroSheetItem()
		{
			super();
		}
	}
}