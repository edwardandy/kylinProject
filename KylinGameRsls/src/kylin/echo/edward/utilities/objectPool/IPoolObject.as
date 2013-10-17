package kylin.echo.edward.utilities.objectPool
{
	public interface IPoolObject
	{
		/**
		 * 所有属性初始化(每个实例一次) 
		 * 
		 */		
		function create():void;
		
		/**
		 * 对象从池中取出时调用 
		 * 
		 */		
		function beforeGet():void;
		
		/**
		 * 对象放入池中时调用
		 * 
		 */		
		function beforePut():void;
	}
}