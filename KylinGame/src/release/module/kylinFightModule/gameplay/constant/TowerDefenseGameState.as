package release.module.kylinFightModule.gameplay.constant
{
	public final class TowerDefenseGameState
	{
		public static const GAME_UNREADY:int = -1;//游戏未初始化状态
		public static const GAME_READY:int = 1;//游戏准备好了，可以开始游戏了
		public static const GAME_RUNNING:int = 2;//游戏运行中
		public static const GAME_PAUSED:int = 3;//游戏暂停中
		public static const GAME_OVER:int = 4;//游戏结束了
	}
}