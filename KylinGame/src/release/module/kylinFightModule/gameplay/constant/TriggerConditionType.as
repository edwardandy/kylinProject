package release.module.kylinFightModule.gameplay.constant
{
	public final class TriggerConditionType
	{
		/**
		 * 无触发条件
		 */
		public static const NOT_TRIGGER:int = 0;
		/**
		 * 死亡后触发
		 */
		public static const AFTER_DIE:int = 1;
		/**
		 * 被攻击之前触发
		 */
		public static const BEFORE_UNDER_ATTACK:int = 2;
		/**
		 * 死亡之前触发
		 */
		public static const BEFORE_DIE:int = 3;
		/**
		 * 普通攻击目标之前触发
		 */
		public static const BEFORE_ATTACK:int = 4;
		/**
		 * buff开始和结束时分别触发
		 */
		public static const BUFFER_START_END:int = 5;
		/**
		 * 生命值或最大生命值发生变化时
		 */
		public static const LIFE_OR_MAXLIFE_CHANGED:int = 6;
		/**
		 * 被攻击之后触发
		 */
		public static const AFTER_UNDER_ATTACK:int = 7;
		/**
		 * 杀死一个目标或者被塔攻击了之后触发(狂暴冲锋)
		 */
		public static const KILL_TARGET_OR_ATTACKED_BY_TOWER:int = 8;
		/**
		 * 有地精靠近时(恶狼先锋的喂食技能)
		 */
		public static const GOBLIN_CLOSED:int = 9;
		/**
		 * 寒冰之心的寒冰盾，5秒内没有收到攻击的时候
		 */
		public static const NOT_UNDER_ATTACK_IN_FIVE_SEC:int = 10;
		/**
		 * 杀死一个敌人(衰老撕咬)
		 */
		public static const KILL_TARGET:int = 11;
		/**
		 * 死亡后复活前
		 */
		public static const AFTER_DIE_BEFORE_REBIRTH:int = 12;
		/**
		 * 触发格挡后
		 */
		public static const AFTER_BLOCK:int = 13;
		/**
		 * 使用技能之后
		 */
		public static const AFTER_USE_SKILL:int = 14;
	}
}