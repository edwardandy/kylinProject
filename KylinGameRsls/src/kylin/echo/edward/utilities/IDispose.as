package kylin.echo.edward.utilities
{
	/**
	 * 回收前释放资源 
	 * @author Edward
	 * 
	 */	
	public interface IDispose
	{
		/**
		 * 执行回收操作，释放资源 
		 * 
		 */		
		function dispose():void;
	}
}