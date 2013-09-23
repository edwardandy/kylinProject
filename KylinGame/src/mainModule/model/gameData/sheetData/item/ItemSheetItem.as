package mainModule.model.gameData.sheetData.item
{
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;

	/**
	 * 道具数值表项 
	 * @author Edward
	 * 
	 */
	public class ItemSheetItem extends BaseDescSheetItem
	{
		/**
		 * 道具类型 1:消耗 , 2:宝箱, 3:材料 , 4:技能升级书 , 5:皮肤 , 6技能书
		 */
		public var type:uint;
		/**
		 * 是否可战斗中使用  0 不可以  1 可以
		 */
		public var fightUse:uint;
		/**
		 * 出售价格 0为不可出售 其他数字为出售价格
		 */
		public var salePrice:uint;
		/**
		 * 效果值 4:5代表 4为效果类型 5为具体数值 如果是宝箱就调取dropInfo
		 */
		public var effectValue:String;
		/**
		 * 效果类型
		 */
		public var effectType:uint;
		/**
		 * 是否商城可见 是否可以在商城买到 1是可以买到 0是不可以买到
		 */
		public var isShow:Boolean;
		/**
		 *是否热卖 
		 */
		public var isHot:Boolean;
		/**
		 * 购买所需金币
		 */
		public var buyPriceGold:uint;
		/**
		 * 宝石价格
		 */
		public var buyPriceMoney:uint;
		/**
		 * 叠加数量
		 */
		public var superpose:uint;
		/**
		 * 是否可合成
		 */
		public var isCombined:int;
		/**
		 * 合成个数
		 */
		public var needNum:int;
		/**
		 *使用积分 
		 * 使用时会奖励积分
		 */
		public var rewardScore:int;
		/**
		 *否是免费礼物 
		 */
		public var canFeed:Boolean;
		/**
		 * 等级(英雄技能书等级--英雄技能升级) 
		 */		
		public var level:uint;
		/**
		 * 来源id 
		 */		
		public var originDesc:int;
		/**
		 * 物品用途描述 
		 */
		public var usageDesc:String;
		/**
		 * 在商店里的标签 
		 */		
		public var label:int;
		/**
		 * 道具的icon，如果为0，则用自身id 
		 */		
		public var resourceId:uint;
		/**
		 * 是否可向好友索要:0不能1能 
		 */		
		public var canAskFor:int;
		/**
		 * 排序 
		 */		
		public var order:int;
		/**
		 * 是否可从战斗中获得:0不能1能
		 */		
		public var canGetItFight:int;
		/**
		 * 商城里可以购买的数量，购买后会变化 ,默认-1为无限制
		 */		
		public var limit:int = -1;
		
		public function ItemSheetItem()
		{
			super();
		}
	}
}