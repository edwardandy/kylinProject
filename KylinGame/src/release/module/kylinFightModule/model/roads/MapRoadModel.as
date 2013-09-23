package release.module.kylinFightModule.model.roads
{			
	import kylin.echo.edward.framwork.model.KylinModel;
	
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.utili.RoadLineVOHelperUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 战斗地图路径数据 
	 * @author Edward
	 * 
	 */	
	public class MapRoadModel extends KylinModel implements IMapRoadModel
	{
		private var _vecRoads:Vector.<MapRoadVO>;	
		private var _ptRoadEnd:PointVO;
		
		public function MapRoadModel()
		{
			super();
		}
		
		public function get ptRoadEnd():PointVO
		{
			return _ptRoadEnd;
		}

		public function initialize():void
		{
		}
		
		public function destroy():void
		{
			if(_vecRoads)
			{
				for each(var road:MapRoadVO in _vecRoads)
					road.dispose();
			}
			_vecRoads = null;
			_ptRoadEnd = null;
		}

		public function getDisRatioByPosIndex(ix:int,iy:int,ptIdx:int,lineIdx:int,roadIdx:int,bRatio:Boolean = true):Number
		{
			if(!_vecRoads || roadIdx<0 || roadIdx>=_vecRoads.length)
				throw new Error("MapConfigDataVO::getDisRatioByPosIndex error roadIdx");
			
			return _vecRoads[roadIdx].lineVOs[lineIdx].getDisRatioByPtAndIndex(ix,iy,ptIdx,bRatio);
		}
		
		public function get roadCount():int
		{
			return _vecRoads?_vecRoads.length:0;
		}
	
		public function getMapRoad(idx:int):MapRoadVO
		{
			return _vecRoads[idx];
		}

		public function updateData(data:XML):void
		{
			destroy();
			_vecRoads = new Vector.<MapRoadVO>;
			_ptRoadEnd = new PointVO;
			
			var arrEndPoint:Array = String(data.@endPointMarkPosition).split("|");
			_ptRoadEnd.x = arrEndPoint[0];
			_ptRoadEnd.y = arrEndPoint[1];
			
			var roadXMLs:XMLList = data.roads.road;
			var roadVO:MapRoadVO;
			var roadPointVOs:Vector.<PointVO>;
			var roadPointXMLs:XMLList;
			var roadPointVO:PointVO ;
			for each(var roadXML:XML in roadXMLs)
			{
				roadVO = new MapRoadVO;
				_vecRoads.push(roadVO);
				
				roadPointVOs = new Vector.<PointVO>;
				roadPointXMLs = roadXML.p;
				
				for each(var roadPointXMl:XML in roadPointXMLs)
				{
					roadPointVO = new PointVO(roadPointXMl.@x, roadPointXMl.@y);
					roadPointVOs.push(roadPointVO);
				}
				
				roadVO.lineVOs = RoadLineVOHelperUtil.creatLineVOsByMiddleLinePoints(roadPointVOs);
			}
			
			genRoadDistances();
		}
		/**
		 * 初始化路线的距离数值 
		 * 
		 */		
		private function genRoadDistances():void
		{
			if(!_vecRoads || 0 == _vecRoads.length)
				return;
			
			for each(var road:MapRoadVO in _vecRoads)
			{
				for each(var line:MapLineVO in road.lineVOs)
				{
					line.genDistance();
				}
			}
		}
	}
}