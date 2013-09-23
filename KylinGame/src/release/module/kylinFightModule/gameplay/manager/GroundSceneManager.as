package release.module.kylinFightModule.gameplay.manager
{
	import flash.display.Shape;
	import flash.display.Sprite;
		
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.manager.interfaces.IGroundSceneManager;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.roads.MapLineVO;
	import release.module.kylinFightModule.model.roads.MapRoadVO;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public class GroundSceneManager implements IGroundSceneManager
	{
		[Inject]
		public var mapRoad:IMapRoadModel;
		
		private var _roadSprite:Sprite;
		
		public function GroundSceneManager()
		{
		}
		
		public function initialize():void
		{
			genRoadShape();
		}
		
		public function destroy():void
		{
			_roadSprite = null;
		}

		public function isHitRoad(hitX:int,hitY:int):Boolean
		{
			return _roadSprite.hitTestPoint(hitX,hitY);
		}
		
		/**
		 * 生成路径范围图，用于检测鼠标是否点在路径区域内 
		 * 
		 */		
		private function genRoadShape():void
		{
			_roadSprite = new Sprite;
			var roadShape:Shape = new Shape;
			_roadSprite.addChild(roadShape);
			
			roadShape.graphics.clear();
			roadShape.graphics.lineStyle(GameFightConstant.ROAD_WIDTH, 0x0);
			var line:MapLineVO;
			var cnt:int = mapRoad.roadCount;
			for(var i:int=0;i<cnt;++i)
			{
				var road:MapRoadVO = mapRoad.getMapRoad(i);
				line = road.lineVOs[1];
				roadShape.graphics.moveTo(line.points[0].x, line.points[0].y);
				
				for each(var point:PointVO in line.points)
					roadShape.graphics.lineTo(point.x, point.y);
			}
			roadShape.graphics.endFill();
		}
	}
}