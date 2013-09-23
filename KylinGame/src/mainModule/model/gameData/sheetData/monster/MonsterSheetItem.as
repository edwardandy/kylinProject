package mainModule.model.gameData.sheetData.monster
{
	import mainModule.model.gameData.sheetData.BaseMoveFighterSheetItem;
	/**
	 * 怪物数值表项 
	 * @author Edward
	 * 
	 */	
	public class MonsterSheetItem extends BaseMoveFighterSheetItem
	{
		/**
		 * 是否boss
		 */
		public var isBoss:Boolean;
		/**
		 * 伤害关卡生命
		 */
		public var killLife:uint;
		/**
		 * 击杀奖励经验
		 */
		public var rewardExp:uint;
		/**
		 * 击杀奖励货物
		 */
		public var rewardGoods:uint;
		/**
		 * 被英雄击杀奖励额外货物
		 */
		public var heroRewardGoods:uint;
		/**
		 * 英雄击杀额外积分
		 */
		public var heroKillScore:uint;
		/**
		 * 击杀后积分
		 */
		public var deadScore:uint;
		/**
		 * 是否可召唤
		 */		
		public var canSummon:Boolean;
		/**
		 * 使用的资源id 
		 */		
		public var resId:int;
		/**
		 * 怪物的三个特点的描述的语言包ID 
		 */		
		public var feature1:int;
		public var feature2:int;
		public var feature3:int;
		
		public function MonsterSheetItem()
		{
			super();
		}
	}
}