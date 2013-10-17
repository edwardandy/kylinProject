package kylin.echo.edward.utilities.objectPool
{
	/**
	 * 对象池 
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class ObjectPool
	{
		public function ObjectPool( clazz:Class, limit:uint=0, initFun:Function=null, createFun:Function=null, clearFun:Function=null )
		{
			_clazz = clazz;
			_limit = limit;
			_initFun = initFun;
			_createFun = createFun;
			_clearFun = clearFun;
			
			_usingItems = new Array();
			_freeItems = new Array();
		}
		
		/**
		 * 获取一个实例 
		 * @param args	可能的初始属性
		 * @return 
		 * 
		 */		
		public function getObject( args:Object=null ):Object
		{
			var obj:Object = null;
			
			if ( _freeItems.length > 0 )
			{
				obj = _freeItems.pop();
				_usingItems.push( obj );
			}
			else
			{
				if ( _limit == 0 || _usingItems.length < _limit )
				{
					obj = new _clazz();
					if ( obj is IPoolObject )
					{
						IPoolObject(obj).create();
					}
					
					if ( obj && _initFun != null )
					{
						_initFun( obj );
					}
				}
				else
				{
					throw new Error( "Pool full error!" );
				}
			}
			
			if ( obj is IPoolObject )
			{
				IPoolObject(obj).beforeGet();
			}
			
			if ( obj && _createFun != null )
			{
				_createFun( obj );
			}
			
			if ( args )
			{
				for ( var key:String in args )
				{
					if ( obj.hasOwnProperty( key ) )
					{
						obj[key] = args[key];
					}
				}
			}
			
			return obj;
		}
		
		/**
		 * 放一个实例入池 
		 * @param obj
		 * 
		 */		
		public function putObject( obj:Object ):void
		{
			if ( _clearFun != null )
			{
				_clearFun( obj );
			}
			
			if ( obj is IPoolObject )
			{
				IPoolObject(obj).beforePut();
			}
			
			_usingItems.splice( _usingItems.indexOf( obj ), 1 );
			_freeItems.push( obj );
		}
		
		//-----------------------------------------------------
		//私有变量
		//-----------------------------------------------------
		
		private var _clazz:Class = null;
		
		private var _limit:int = 0;
		
		private var _initFun:Function = null;
		
		private var _createFun:Function = null;
		
		private var _clearFun:Function = null;
		
		private var _usingItems:Array = null;
		
		private var _freeItems:Array = null;
	}
}