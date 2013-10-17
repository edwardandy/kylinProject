package release.module.kylinFightModule.gameplay.oldcore.core
{
	//游戏生命周期的观察者
	public interface IFightLifecycle
	{
		function onFightStart():void;
		function onFightEnd():void;
		
		function onFightPause():void;
		function onFightResume():void;
	}
}