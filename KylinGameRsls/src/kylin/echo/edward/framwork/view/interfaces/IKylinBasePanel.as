package kylin.echo.edward.framwork.view.interfaces
{
	import flash.system.ApplicationDomain;

	public interface IKylinBasePanel
	{
		/**
		 *  显示面板
		 * @param param 显示参数
		 * 
		 */		
		function appear(param:Object = null):void;
		/**
		 *  关闭面板
		 * @param param 关闭参数
		 * 
		 */		
		function disappear(param:Object = null):void;
		/**
		 *  显示面板动画结束
		 * @param param 显示参数
		 * 
		 */		
		function afterAppear(param:Object = null):void;
		/**
		 *  关闭面板动画结束
		 * @param param 关闭参数
		 * 
		 */		
		function afterDisappear(param:Object = null):void;
		/**
		 * 设置面板资源的应用域 
		 * @param value
		 * 
		 */		
		function set resDomain(value:ApplicationDomain):void;
		/**
		 * 对应的面板id 
		 */
		function get panelId():String;
		/**
		 * @private
		 */
		function set panelId(value:String):void;
	}
}