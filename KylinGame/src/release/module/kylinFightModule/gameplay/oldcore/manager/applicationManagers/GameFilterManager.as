package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class GameFilterManager implements IDisposeObject
	{
		private static var _instance:GameFilterManager;
		
		public static function getInstance():GameFilterManager
		{
			return _instance ||= new GameFilterManager();
		}
		
		private var _defaultYellowGlowFilter:GlowFilter;
		private var _yellowGlowFilter2:GlowFilter;
		private var _blueGlowFilter:GlowFilter;
		
		private var _defaultRedGlowFilter:GlowFilter;
		private var _delfaultColorMatrixFilter:ColorMatrixFilter;
		private var _delfaultBlueColorMatrixFilter:ColorMatrixFilter;
		private var _defaultBlackStrokeFilter:GlowFilter;
		
		private var _cachedDefinedFilters:Array = [];
		
		
		public function GameFilterManager()
		{
			super();
		}
		
		//IDisposeObject Interface
		public function dispose():void
		{
			_defaultYellowGlowFilter = null;
			_defaultRedGlowFilter = null;
			_delfaultColorMatrixFilter = null;
			_cachedDefinedFilters = null;
			_blueGlowFilter = null;
			_instance = null;
		}
		
		 //黄色外发光效果 
		public function get yellowGlowFilter():GlowFilter
		{
			return _defaultYellowGlowFilter ||= new GlowFilter(0xd8be5a , 1 , 6 , 6 , 6);
		}
		
		public function get yellowGlowFilter2():GlowFilter
		{
			return _yellowGlowFilter2 ||= new GlowFilter(0xd8be5a , 1 , 12 , 12 , 6);
		}
		
		public function get blueGlowFilter():GlowFilter
		{
			return _blueGlowFilter ||= new GlowFilter( 0x00B4FF, 0.75, 12, 12, 2 );
		}
		
		//红色外发光效果 
		public function get redGlowFilter():GlowFilter
		{
			return _defaultRedGlowFilter ||= new GlowFilter(0xff0000 , 0.5 , 6 , 6 , 6);
		}
		
		//灰度效果 
		public function get colorNessMatrixFilter():ColorMatrixFilter
		{
			return _delfaultColorMatrixFilter ||= new ColorMatrixFilter([
				0.33,0.33,0.33,0,0,
				0.33,0.33,0.33,0,0,
				0.33,0.33,0.33,0,0,
				0,0,0,1,0
			]);
		}
		
		public function get colorBlueMatrixFilter():ColorMatrixFilter
		{
			return _delfaultBlueColorMatrixFilter ||= new ColorMatrixFilter([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,10,0,0,
				0,0,0,1,0
			]);
		}
		
		public function get blackStrokeFilter():GlowFilter
		{
			return _defaultBlackStrokeFilter ||= new GlowFilter(0x000000,1,2,2,16);
		}
		
		public function definedFilter(name:String, bitmapFilter:BitmapFilter):BitmapFilter
		{
			_cachedDefinedFilters[name] = bitmapFilter;
			return bitmapFilter;
		}
		
		public function deleteDefinedFilter(name:String):void
		{
			delete _cachedDefinedFilters[name];
		}
		
		public function getDefinedFilter(name:String):BitmapFilter
		{
			return _cachedDefinedFilters[name] as BitmapFilter;
		}
	}
}