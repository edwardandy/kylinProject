package release.module.kylinFightModule.model.interfaces
{
	import flash.display.Shape;
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
		 * 道路形状层，用于测试某个点是否在怪物逃跑路线上 
		 */		
		function get roadHitTestShape():Shape;
		/**
		 * 地表层 
		 */
		function get groundLayer():Sprite;
	}
}