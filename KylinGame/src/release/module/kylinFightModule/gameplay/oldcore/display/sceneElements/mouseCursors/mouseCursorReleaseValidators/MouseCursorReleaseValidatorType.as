package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators
{
	

//	0: 点技能就释放
//	1：地图任意位置都可以释放
//	2：只能在路上放
//	3：只能作用于单体怪物
//	4:  必须在路的中间位置释放
	
	public final class MouseCursorReleaseValidatorType
	{
		public static const NO_VALID:int = 0;//不需要验证
		public static const ANY:int = 1;//不需要验证
		
		public static const ONLY_ROAD:int = 2;
		public static const ONLY_ENEMY:int = 3;
		public static const ONLY_STRICT_ROAD:int = 4;
		
		public static const ONLY_IN_RANGE:int = 100;//兵营使用
	}
}