package release.module.kylinFightModule.gameplay.oldcore.core
{
	//游戏生命周期的观察者
	public interface IFightLifecycle extends IDisposeObject
	{
		/**
		 * 进入战斗模块 
		 * 
		 */		
		function onFightStart():void;
		/**
		 * 战斗结束 
		 * 
		 */		
		function onFightEnd():void;
		/**
		 * 战斗暂停 
		 * 
		 */		
		function onFightPause():void;
		/**
		 * 战斗继续 
		 * 
		 */		
		function onFightResume():void;
	}
}