package kylin.echo.edward.utilities.objectPool
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 对象池管理器 
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class PoolManager
	{
		/**
		 * 获取此类唯一实例 
		 * @return 
		 * 
		 */		
		public static function getInstance():PoolManager
		{
			if ( _instance == null )
			{
				_instance = new PoolManager();
			}
			
			return _instance;
		}
		
		public function PoolManager()
		{
			if ( _instance )
			{
				throw new Error( "Singleton Error" );
				return;
			}
			
			_instance = this;
			_allPools = new Dictionary();
		}
		
		/**
		 * 获取一个对象 
		 * @param clazz	对象类
		 * @param args	属性赋值
		 * @return 
		 * 
		 */		
		public function getObject( clazz:Class, args:Object=null ):Object
		{
			return getPoolByClass( clazz ).getObject( args );
		}
		
		/**
		 * 将一个对象放入池中 
		 * @param instace	对象实例
		 * @param clazz		对象类
		 * 
		 */		
		public function putObject( instace:Object, clazz:Class=null ):void
		{
			if ( clazz == null )
			{
				var className:String = getQualifiedClassName( instace );
				clazz = Class(getDefinitionByName( className ));
			}
			
			getPoolByClass( clazz ).putObject( instace );
		}
		
		/**
		 * 创建一个池 
		 * @param clazz	类
		 * @param limit	尺寸限制
		 * @param initFun	第一次初始化函数
		 * @param createFun	属性初始化函数
		 * @param clearFun	清理函数
		 * 
		 */		
		public function createPool( clazz:Class, limit:int=0, initFun:Function=null, createFun:Function=null, clearFun:Function=null ):void
		{
			_allPools[clazz] = new ObjectPool( clazz, limit, initFun, createFun, clearFun );
		}
		
		/**
		 * 是否是相应的池 
		 * @param clazz
		 * @return 
		 * 
		 */		
		public function hasPool( clazz:Class ):Boolean
		{
			return _allPools[clazz] != null;
		}
		
		//-----------------------------------------------------
		//私有函数
		//-----------------------------------------------------
		
		/**
		 * 根据类获取对象池 
		 * @param clazz
		 * @return 
		 * 
		 */		
		private function getPoolByClass( clazz:Class ):ObjectPool
		{
			if ( _allPools[clazz] == null )
			{
				createPool( clazz );
			}
			
			return _allPools[clazz] as ObjectPool;
		}
		
		//-----------------------------------------------------
		//私有变量
		//-----------------------------------------------------
		
		/**
		 * 此类唯一实例 
		 */		
		protected static var _instance:PoolManager = null;
		
		/**
		 * 所有的对象池 
		 */		
		protected var _allPools:Dictionary = null;
	}
}