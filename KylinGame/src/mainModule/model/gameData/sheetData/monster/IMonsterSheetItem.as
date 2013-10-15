package mainModule.model.gameData.sheetData.monster
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;
	/**
	 * 怪物数值表项 
	 * @author Edward
	 * 
	 */
	public interface IMonsterSheetItem extends IBaseSheetItem
	{
		/**
		 * 使用的资源id 
		 */
		function get resId():int;
		/**
		 * 是否可召唤
		 */
		function get canSummon():Boolean;
		/**
		 * 击杀后积分
		 */
		function get deadScore():uint;
		/**
		 * 英雄击杀额外积分
		 */
		function get heroKillScore():uint;
	/**
		 * 被英雄击杀奖励额外货物
		 */
		function get heroRewardGoods():uint;
		/**
		 * 击杀奖励货物
		 */
		function get rewardGoods():uint;
		/**
		 * 击杀奖励经验
		 */
		function get rewardExp():uint;
		/**
		 * 伤害关卡生命
		 */
		function get killLife():uint;
		/**
		 * 是否boss
		 */
		function get isBoss():Boolean;
		/**
		 * 怪物的第一个特点的描述的语言包ID 
		 */
		function get arrFeatureLanIds():Array;
	}
}