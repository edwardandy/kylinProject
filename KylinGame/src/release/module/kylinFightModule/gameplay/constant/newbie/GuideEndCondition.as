package release.module.kylinFightModule.gameplay.constant.newbie
{
	/**
	 * 新手引导结束条件
	 */
	public final class GuideEndCondition
	{
		/**
		 * 点击自身窗口的关闭按钮后结束
		 */
		public static const SELFBTN:int = 0;
		/**
		 * 点击出怪点或怪物大波次开始后关闭
		 */
		public static const BIGWAVESTART:int = 1;
		/**
		 * 有塔被建造后
		 */
		public static const BUILDTOWER:int = 2;
		/**
		 * 使用关联对象之后，如道具或法术
		 */
		public static const USETARGER:int = 3;
	}
}