package 
{
	/**
	 * 模块接口，用于向主程序模块传递参数 
	 * @author Edward
	 * 
	 */	
	public interface ITdModule
	{
		/**
		 * 向模块传递参数 
		 * @param param 模块参数
		 * 
		 */		
		function SetModuleParam(param:Object):void;
	}
}