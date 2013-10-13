package release.module.kylinFightModule.gameplay.constant.newbie
{
	/**
	 * 新手引导触发条件
	 */
	public final class GuideStartCondition
	{
		/**
		 * 一旦进入战斗即触发
		 */
		public static const ENTERBATTLE:int = 0;
		/**
		 * 被动触发，比如其他引导结束即会触发本引导
		 */
		public static const PASSIVE:int = 1;
		/**
		 * 出怪波次的顺序触发
		 */
		public static const WAVEINDEX:int = 2;
	}
}