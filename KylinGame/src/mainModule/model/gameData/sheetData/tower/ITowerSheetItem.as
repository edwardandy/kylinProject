package mainModule.model.gameData.sheetData.tower
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseFighterSheetItem;
	/**
	 * 塔数值表项  
	 * @author Edward
	 * 
	 */	
	public interface ITowerSheetItem extends IBaseFighterSheetItem
	{
		/**
		 * 解锁后的冷却时间 
		 */
		function get coolTime():int;
		/**
		 * 战斗内的升级价格
		 */
		function get buyGold():uint;
		/**
		 * 士兵配置
		 */
		function get soldierId():int;
		/**
		 * 前置塔
		 */
		function get preTowerId():uint;
		/**
		 * 塔的进阶等级(非动态升级等级)
		 */
		function get level():int;
		/**
		 * 1兵营
		 * 2箭塔
		 * 3魔法塔
		 * 4炮塔
		 */
		function get type():int;
		/**
		 * 后置 塔ID
		 * "111004:111005:111006"
		 */
		function get nextTowerIds():Array;
		/**
		 * 解锁消耗材料(包括金币或钻石)
		 * [[888888,100],[133059,10]]
		 */
		function get vecUpgradeCostItems():Vector.<Array>;
	}
}