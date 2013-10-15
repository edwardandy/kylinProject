package mainModule.model.gameData.sheetData.hero
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;
	/**
	 * 英雄数值表项 
	 * @author Edward
	 * 
	 */
	public interface IHeroSheetItem extends IBaseSheetItem
	{
		/**
		 * 是否已开放 
		 */
		function get isOpen():Boolean;
		/**
		 * 英雄间的属性对比 0-8格
		 */
		function get measurement():String;
		/**
		 * 属性描述id
		 */
		function get attributeDesc():int;
		/**
		 * 购买所需荣誉 
		 */
		function get needHonor():int;
		/**
		 * 购买所需价格
		 */
		function get buyMoney():int;
		/**
		 * 可以购买 :0不可买1可以
		 */
		function get canBuy():uint;
		/**
		 * 品质
		 */
		function get quality():uint;
		/**
		 * 复活时间
		 */
		function get rebirthTime():uint;
		/**
		 * 激发潜能生命力成长
		 */
		function get potencyLifeGrowth():int;
		/**
		 * 激发潜能攻击力成长
		 */
		function get potencyAtkGrowth():int;
		/**
		 * 血量成长值
		 */
		function get lifeGrowth():int;
		/**
		 * 最大攻击成长值
		 */
		function get maxAtkGrowth():int;
		/**
		 * 基础攻击成长值
		 */
		function get minAtkGrowth():int;
	}
}