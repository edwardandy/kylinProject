package release.module.kylinFightModule.model.roads
{	
	import utili.behavior.interfaces.IDispose;

	/**
	 * 地图上的每条路径 
	 * @author Edward
	 * 
	 */	
	public class MapRoadVO implements IDispose
	{
		private var _lineVOs:Vector.<MapLineVO>;
		
		public function MapRoadVO()
		{
			//_lineVOs = new Vector.<MapLineVO>;
		}
		
		/**
		 * 路线数组,每条路径有3条路线 
		 */
		public function get lineVOs():Vector.<MapLineVO>
		{
			return _lineVOs;
		}
		/**
		 * @private
		 */		
		public function set lineVOs(value:Vector.<MapLineVO>):void
		{
			_lineVOs = value;
		}

		public function dispose():void
		{
			if(_lineVOs)
			{
				for each(var line:MapLineVO in _lineVOs)
					line.dispose();
				_lineVOs.length = 0;
			}
			_lineVOs = null;
		}
	}
}