package release.module.kylinFightModule.gameplay.oldcore.core
{
	
	/**
	 *  游戏生命周期的观察者(如果是全局单例，需要添加到FightLifecycleGroup中去)
	 * @author Edward
	 * 
	 */	
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