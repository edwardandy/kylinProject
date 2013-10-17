package release.module.kylinFightModule.gameplay.oldcore.vo
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;

	public class GlobalTemp
	{
		/**
		 * 要用道具复活的英雄 
		 */		
		public static var rebirthHero:HeroElement = null;
		
		/**
		 * 启用模拟法术数据 
		 */		
		public static var enableMockMagicFlag:Boolean = false;
		
		/**
		 * 启用模拟道具数据 
		 */		
		public static var enableMockItemFlag:Boolean = false;
		
		/**
		 * 新手引导模拟头上关卡标志 
		 */		
		public static var newGuideMockTollgateFlag:Boolean = false;
		
		/**
		 * 启用出怪指示 
		 */		
		public static var enableMonsterMarchFlag:Boolean = false;
		
		/**
		 * 退出游戏返回到什么场景标志
		 * 1返回主场景，0返回地图 ,2返回无极幻境面板
		 */		
		public static var quitDestFlag:int = 0;
		
		public static var spiritHeroAttackAddition:Number = 0;
		public static var spiritTowerAttackAddition:Number = 0;

		/**
		 * 缓存计时点 
		 */		
		public static var tempTime:uint = 0;
		
		/**
		 * 战斗用时 
		 */		
		public static var useTime:uint = 0;
		public static var bForcePause:Boolean = false;
	}
}