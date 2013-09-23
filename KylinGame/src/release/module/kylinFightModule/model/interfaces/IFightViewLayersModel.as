package release.module.kylinFightModule.model.interfaces
{
	import flash.display.Sprite;
	
	
	import kylin.echo.edward.gameplay.IKylinGameManager;

	/**
	 * 战斗模块显示层次 
	 * @author Edward
	 * 
	 */	
	public interface IFightViewLayersModel extends IKylinGameManager
	{
		/**
		 * 显示顶层 
		 */
		function get topLayer():Sprite;
		/**
		 * 显示中间层 
		 */
		function get middleLayer():Sprite;	
		/**
		 * 显示下层 
		 */
		function get bottomLayer():Sprite;	
		/**
		 * 地表层 
		 */
		function get groundLayer():Sprite;
	}
}