package release.module.kylinFightModule.utili
{
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.model.roads.MapLineVO;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public final class RoadLineVOHelperUtil
	{
		public static function creatLineVOsByMiddleLinePoints(points:Vector.<PointVO>):Vector.<MapLineVO>
		{
			var results:Array = GameMathUtil.caculateTwoParallelLinesByMiddleLine(points, GameFightConstant.ROAD_LINE_GAP);
			
			var line0:MapLineVO = new MapLineVO();
			line0.lineIndex = 0;
			line0.points = results[0];//left
			
			var line1:MapLineVO = new MapLineVO();
			line1.lineIndex = 1;//middle
			line1.points = points;
			
			var line2:MapLineVO = new MapLineVO();
			line2.lineIndex = 2;//right
			line2.points = results[1];
			
			return Vector.<MapLineVO>([line0, line1, line2]);
		}

		//null 返回不再该路上, index, Point, 计算出来的Index是靠近起点的index
		public static function caculatePointInfoOnRoadPathStepIndex(p:PointVO, lineVOs:Vector.<MapLineVO>):int
		{
			var centerP:PointVO;
			
			var left0P:PointVO;
			var left1P:PointVO;
			var right0P:PointVO;
			var right1P:PointVO;
			
			var positionType:int = -1;
			var centerL:Vector.<PointVO> = lineVOs[1].points;
			var leftL:Vector.<PointVO> = lineVOs[0].points;
			var rightL:Vector.<PointVO> = lineVOs[2].points;
			
			var n:uint = centerL.length - 1;
			for(var i:uint = 0; i < n; i++)
			{
				left0P = leftL[i];
				left1P = leftL[i + 1];
				
				right0P = rightL[i];
				right1P = rightL[i + 1];
				
				positionType = GameMathUtil.judgePointInQuadrangle(p, left0P, left1P, right1P, right0P);
				
				if(positionType >= 0)
				{
					return i;
				}
			}
			
			return -1;
		}
	}
}