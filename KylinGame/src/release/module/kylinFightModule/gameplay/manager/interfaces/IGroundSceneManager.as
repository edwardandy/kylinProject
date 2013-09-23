package release.module.kylinFightModule.gameplay.manager.interfaces
{
	import kylin.echo.edward.gameplay.IKylinGameManager;
	/**
	 * 场景元素管理器 
	 * @author Edward
	 * 
	 */	
	public interface IGroundSceneManager extends IKylinGameManager
	{
		/**
		 * 检测某个点是否在路径上,该点需要以战斗模块根显示对象为坐标系
		 * @param hitX
		 * @param hitY
		 * @return 
		 * 
		 */
		function isHitRoad(hitX:int,hitY:int):Boolean;
	}
}