package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms
{
	public final class OrganismBehaviorState
	{
		//活动状态
		public static const IDLE:int = 1;
		//2,3,4 状态下是可能有敌人的
		public static const NEAR_FIHGTTING:int = 2;
		public static const FAR_FIHGTTING:int = 3;

		public static const MOVING_TO_ENEMY_NEAR_BY:int = 4;//移动到近身，准备近战
		public static const BE_FINED_AND_LOCKED_BY_ENEMY:int = 5;
		public static const ENEMY_ESCAPING:int = 7;
		
		public static const MOVE_TO_APPOINTED_POINT:int = 6;//移动到指定的点（分主动和被动）
		//瞬移
		//public static const TELEPORT_MOVE:int = 8;
		
		/**
		 * 使用技能
		 */
		public static const USE_SKILL:int = 8;
		/**
		 * 格挡攻击
		 */
		public static const BLOCK:int = 9;
		/**
		 * 弹射
		 */
		public static const LAUNCH:int = 10;
		/**
		 * 被召唤
		 */
		public static const BE_SUMMON:int = 11;
		/**
		 * 寒冰之心分裂
		 */
		public static const ICE_SPLIT:int = 12;
		/**
		 * 寒冰之心还原
		 */
		public static const ICE_RESTORE:int = 13;
		/**
		 * 寒冰之心等待还原
		 */
		public static const ICE_WAIT:int = 14;
		/**
		 * 恶狼先锋被网住
		 */
		public static const STUN:int = 15;
		/**
		 * 比蒙巨兽发怒
		 */
		public static const BEASTANGRY:int = 16;
		
		public static const APPEAR:int = 17;//出现
		
		//pvp
		public static const PVP_GOTO_STARTPT:int = 51;
		public static const PVP_GOTO_ENDPT:int = 52;
		
		//非活动状态>= 1000
		public static const RESURRECTION:int = 1000;//复活
		public static const DYING:int = 1001;
		public static const BORN:int = 1002;
		public static const SOLDIER_STAY_AT_HOME:int = 1003;

		public static const DISAPPEAR:int = 1004;//消失
		
	}
}