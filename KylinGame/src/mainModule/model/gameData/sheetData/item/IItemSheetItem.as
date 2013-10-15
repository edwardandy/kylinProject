package mainModule.model.gameData.sheetData.item
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;
	/**
	 * 道具数值表项 
	 * @author Edward
	 * 
	 */
	public interface IItemSheetItem extends IBaseSheetItem
	{
		/**
		 * 商城里可以购买的数量，购买后会变化 ,默认-1为无限制
		 */
		function get limit():int;
		/**
		 * 是否可从战斗中获得:0不能1能
		 */
		function get canGetItFight():int;
		/**
		 * 排序 
		 */
		function get order():int;
		/**
		 * 是否可向好友索要:0不能1能 
		 */
		function get canAskFor():int;
		/**
		 * 道具的icon，如果为0，则用自身id 
		 */
		function get resId():uint;
		/**
		 * 在商店里的标签 
		 */
		function get label():int;
		/**
		 * 物品用途描述 
		 */
		function get usageDesc():String;
		/**
		 * 来源id 
		 */
		function get originDesc():int;
		/**
		 * 等级(英雄技能书等级--英雄技能升级) 
		 */
		function get level():uint;
		/**
		 *否是免费礼物 
		 */
		function get canFeed():Boolean;
		/**
		 *使用积分 
		 * 使用时会奖励积分
		 */
		function get rewardScore():int;
		/**
		 * 合成个数
		 */
		function get needNum():int;
		/**
		 * 是否可合成
		 */
		function get isCombined():int;
		/**
		 * 叠加数量
		 */
		function get superpose():uint;
		/**
		 * 宝石价格
		 */
		function get buyPriceMoney():uint;
		/**
		 * 购买所需金币
		 */
		function get buyPriceGold():uint;
		/**
		 *是否热卖 
		 */
		function get isHot():Boolean;
		/**
		 * 是否商城可见 是否可以在商城买到 1是可以买到 0是不可以买到
		 */
		function get isShow():Boolean;
		/**
		 * 效果类型
		 */
		function get effectType():uint;
		/**
		 * 效果值 4:5代表 4为效果类型 5为具体数值 如果是宝箱就调取dropInfo
		 */
		function get effectValue():String;
		/**
		 * 出售价格 0为不可出售 其他数字为出售价格
		 */
		function get salePrice():uint;
		/**
		 * 是否可战斗中使用  0 不可以  1 可以
		 */
		function get fightUse():uint;
		/**
		 * 道具类型 1:消耗 , 2:宝箱, 3:材料 , 4:技能升级书 , 5:皮肤 , 6技能书
		 */
		function get type():uint;
	}
}