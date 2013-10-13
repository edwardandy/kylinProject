package release.module.kylinFightModule.gameplay.constant.Skill
{
	public final class SkillSpecialType
	{
		/**
		 * 非特殊技能
		 */
		public static const NOT_SPECIAL:int = 0;
		/**
		 * 普通攻击时会附带buff
		 */
		public static const ATTACH_BUFF_ON_NORMAL_ATK:int = 1;
		/**
		 * 只要cd时间一到就必定使用
		 */
		public static const SHOULD_USE_ON_CD_READY:int = 2;
	}
}