package release.module.kylinFightModule.service.interfaces
{
	/**
	 * 战斗前预加载资源，包括怪物，英雄，技能，法术等的动画
	 * @author Edward
	 * 
	 */
	public interface IFightResPreloadService
	{
		/**
		 * 预加载所有资源 
		 */	
		function preInitAllRes():void;
	}
}