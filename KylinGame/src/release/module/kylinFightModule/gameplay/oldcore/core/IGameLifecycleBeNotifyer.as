package release.module.kylinFightModule.gameplay.oldcore.core
{
	//游戏生命周期的观察者
	public interface IGameLifecycleBeNotifyer
	{
		function onGameStart():void;
		function onGameEnd():void;
		
		function onGamePause():void;
		function onGameResume():void;
	}
}