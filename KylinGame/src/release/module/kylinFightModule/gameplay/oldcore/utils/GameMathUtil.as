package release.module.kylinFightModule.gameplay.oldcore.utils
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IPositionUnit;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.LineVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.display.Sprite;
	import flash.geom.Point;

    public final class GameMathUtil
    {
		public static const SMALLEST_NUMBER:Number = 0.0000000000001;
		public static const DOUBLE_PI:Number = Math.PI * 2;//360
		public static const HALF_PI:Number = Math.PI * 0.5;//90
		public static const QUARTER_PI:Number = HALF_PI * 0.5;//45
		
		//游戏中需要划分的角度等份数
		private static const GAME_DIRECT_PORTION:uint = 8;
		//游戏中需要划分的角度等份角度
		private static const PORTION_ANGLE:Number = DOUBLE_PI / GAME_DIRECT_PORTION;
		private static const HALF_PORTION_ANGLE:Number = PORTION_ANGLE * 0.5;
		
		//临时数据，以供复用
		private static var _tempPoint0:Point = new Point();
		private static var _tempPoint1:Point = new Point();
		private static var _tempPoint2:Point = new Point();
		
		//2点之间的距离
		public static function distance(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			_tempPoint0.x = x0;
			_tempPoint0.y = y0;
			_tempPoint1.x = x1;
			_tempPoint1.y = y1;
			return Point.distance(_tempPoint0, _tempPoint1);
		}
		
		//通过一条线算两条平行线
		//[0(left)->Vector.<PointVO>, 1(left)->Vector.<PointVO>]
		public static function caculateTwoParallelLinesByMiddleLine(middleLine:Vector.<PointVO>, distance:Number):Array
		{
			var leftLine:Vector.<PointVO> = new Vector.<PointVO>();
			var rightLine:Vector.<PointVO> = new Vector.<PointVO>();
			var result:Array = [leftLine, rightLine];
			
			var lastDirectionRadian:Number;
			var currentPoint:PointVO = null;
			var nextPoint:PointVO = null;
			var twoParallelLine:Array = null;
			
			var n:uint = middleLine.length;
			for(var i:uint = 0; i < n; i++)
			{
				currentPoint = middleLine[i];
				
				if(i != n - 1)
				{
					nextPoint = middleLine[i + 1];
					lastDirectionRadian = caculateDirectionRadianByTwoPoint(currentPoint, nextPoint);
				}
				
				twoParallelLine = caculateTwoEqualDistanceLRPointByCenterPointAndDirection(currentPoint, lastDirectionRadian, distance);
				leftLine.push(twoParallelLine[0]);//left
				rightLine.push(twoParallelLine[1]);//right
			}

			return result;
		}
		
		//朝向方向中心点为centerPoint的左右距离为distance的两点的坐标
		public static function caculateTwoEqualDistanceLRPointByCenterPointAndDirection(centerPoint:PointVO , 
																directionRadian:Number, distance:Number, 
																needIntValue:Boolean = true):Array//[0-> left Point， 1-> right Point]
		{
			//将目标坐标系定为源坐标系， 朝向为X轴
			var leftPoint:PointVO = new PointVO(0, -distance);
			var rightPoint:PointVO = new PointVO(0, distance);
			
			leftPoint = caculateSourceAxeLocalPointInNewAxePoint(centerPoint.x, centerPoint.y, directionRadian, leftPoint.x, leftPoint.y, needIntValue);
			rightPoint = caculateSourceAxeLocalPointInNewAxePoint(centerPoint.x, centerPoint.y, directionRadian, rightPoint.x, rightPoint.y, needIntValue);
			
			return [leftPoint, rightPoint];
		}
		
		//朝向方向中心点为centerPoint的前后距离为distance的两点的坐标
		public static function caculateTwoEqualDistanceTBPointByCenterPointAndDirection(centerPoint:PointVO , 
																					  directionRadian:Number, distance:Number, 
																					  needIntValue:Boolean = true):Array//[0-> top Point， 1-> bottom Point]
		{
			//将目标坐标系定为源坐标系
			var topPoint:PointVO = new PointVO(distance, 0);
			var bottomPoint:PointVO = new PointVO(-distance, 0);
			
			topPoint = caculateSourceAxeLocalPointInNewAxePoint(centerPoint.x, centerPoint.y, directionRadian, topPoint.x, topPoint.y, needIntValue);
			bottomPoint = caculateSourceAxeLocalPointInNewAxePoint(centerPoint.x, centerPoint.y, directionRadian, bottomPoint.x, bottomPoint.y, needIntValue);
			
			return [topPoint, bottomPoint];
		}
		
//		//主意值这里是将目标对象的坐标系定为源坐标系，将真实的Flash定为目标坐标系的，求的是在目标坐标系下的点的坐标
//		//主意源坐标系的是以X轴方向，来计算坐标旋转朝向的
		public static function caculateSourceAxeLocalPointInNewAxePoint(sourceAxeInNewAxePointX:Number, sourceAxeInNewAxePointY:Number,
												   sourceAxeDirectionRadianInNewAxe:Number, //sourceAxe的X轴在新坐标系中的角度
												   sourceAxeLocalPointX:Number, sourceAxeLocalPointY:Number,
												   needIntValue:Boolean = true):PointVO
		{
			var resultInNewAxePoint:PointVO = new PointVO();
			
			var sinValue:Number = GameMathUtil.sin(sourceAxeDirectionRadianInNewAxe);
			var cosVlaue:Number = GameMathUtil.cos(sourceAxeDirectionRadianInNewAxe);

			resultInNewAxePoint.x = cosVlaue * sourceAxeLocalPointX - sinValue * sourceAxeLocalPointY + sourceAxeInNewAxePointX;
			resultInNewAxePoint.y = cosVlaue * sourceAxeLocalPointY + sinValue * sourceAxeLocalPointX + sourceAxeInNewAxePointY;
			
			if(needIntValue)
			{
				resultInNewAxePoint.x = int(resultInNewAxePoint.x);
				resultInNewAxePoint.y = int(resultInNewAxePoint.y);
			}
			
			return resultInNewAxePoint;
		}
		
		//已知点p，求该点与p0,p1线垂直的线的交点坐标
		public static function caculatePerpendicularPoint(p:PointVO, p0:PointVO, p1:PointVO):PointVO
		{
			if(p1.x == p0.x) return new PointVO(p1.x, p.y);
			
			var k0:Number = (p1.y - p0.y) / (p1.x - p0.x);
			var k1:Number = 1 / k0;
			
			return caculateCrossingPointByTwoLine(p, k1, p0, k0);
		}
		
		//计算两条直线的焦点，可能没有
		public static function caculateCrossingPointByTwoLine(p0:PointVO, p0K:Number, p1:PointVO, p1K:Number):PointVO
		{
			if(p0K == p1K) return null;
			
//			y=a0x+b0,y=a1x+b1
			var b0:Number;
			var b1:Number;
			var x:Number;
			var y:Number;
			
			if(p0K == Infinity)
			{
				x = p0.x;
				b1 = p1.y - p1.x * p1K;
				y = p1K * x + b1;
			}
			else if(p1K == Infinity)
			{
				x = p1.x;
				b0 = p0.y - p0.x * p0K;
				y = p0K * x + b0;
			}
			else
			{
				b0 = p0.y - p0.x * p0K;
				b1 = p1.y - p1.x * p1K;
				
				x = (b1 - b0) / (p1K - p0K);
				y = p0K * (b1 - b0) / (p1K - p0K) + b0;
			}
			
			return new PointVO(x, y);
		}
		
		//通过2点计算角度
		public static function caculateDirectionRadianByTwoPoint(startPoint:PointVO, endPoint:PointVO):Number
		{
			return caculateDirectionRadianByTwoPoint2(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
		}
		
		//通过2点计算角度
		public static function caculateDirectionRadianByTwoPoint2(startX:Number, startY:Number, endX:Number, endY:Number):Number
		{
			return GameMathUtil.adjustRadianBetween0And2PI(Math.atan2(endY - startY, endX - startX));
		}
		/**
		 * 计算2条直线的夹角度数
		 */
		public static function caculateDegreeByTwoLine(startPoint1:PointVO,endPoint1:PointVO,startPoint2:PointVO,endPoint2:PointVO):Number
		{
			return caculateDegreeByTwoLine2(startPoint1.x,startPoint1.y,endPoint1.x,endPoint1.y,startPoint2.x,startPoint2.y,endPoint2.x,endPoint2.y);
		}
		
		public static function caculateDegreeByTwoLine2(startX1:Number,startY1:Number,endX1:Number,endY1:Number,startX2:Number,startY2:Number,endX2:Number,endY2:Number):Number
		{
			return adjustRadianBetween0And360(radianToDegree(Math.atan2(endY2 - startY2,endX2 - startX2) - Math.atan2(endY1 - startY1,endX1 - startX1))/*caculateRadianByTwoLine2(startX1,startY1,endX1,endY1,startX2,startY2,endX2,endY2)*/);
		}
		
		public static function caculateRadianByTwoLine2(startX1:Number,startY1:Number,endX1:Number,endY1:Number,startX2:Number,startY2:Number,endX2:Number,endY2:Number):Number
		{
			return adjustRadianBetween0And2PI(Math.atan2(endY2 - startY2,endX2 - startX2) - Math.atan2(endY1 - startY1,endX1 - startX1));
		}
		
		//计算圆上面的点
		public static function caculatePointOnCircle(circleCenterX:Number, circleCenterY:Number, radian:Number, radius:Number,bDegree:Boolean = false):PointVO
		{
			if(bDegree)
				radian = degreeToRadian(radian);
			var point:PointVO = new PointVO();
			point.x = circleCenterX + cos(radian) * radius;
			point.y = circleCenterY + sin(radian) * radius;
			return point;
		}
		
		//计算椭圆上的点
		public static function caculatePointOnEllipse(circleCenterX:Number, circleCenterY:Number, radian:Number, radiusX:Number, radiusY:Number):PointVO
		{
			var point:PointVO = new PointVO();
			point.x = circleCenterX + cos(radian) * radiusX;
			point.y = circleCenterY + sin(radian) * radiusY;
			return point;
		}
		
		//angle       0度， 30度， 60度， 120度， 150度   180度，  210度， 330度共8个位置
		//angleIndex   0     1     2       4       5      6        7        11
		//但是最总还是按照椭圆算的
		public static function caculateTargetPointOnOnEllipse(ellipseCenterX:Number, ellipseCenterY:Number, ellipseRadian:Number,
															  targetX:Number, targetY:Number):PointVO
		{
			var angleWithThisToAttacker:Number = GameMathUtil.radianToDegree(
				GameMathUtil.adjustRadianBetween0And2PI(
					GameMathUtil.caculateDirectionRadianByTwoPoint2(ellipseCenterX, ellipseCenterY, targetX, targetY)));
			
			var angleIndex:int = int(angleWithThisToAttacker / 30);
			switch(angleIndex)
			{
				case 3:
					angleIndex = 4;
					break;
				
				case 8:
				case 9:
					angleIndex = 7;
					break;

				case 10:
					angleIndex = 11;
					break;
			}
			
			var resultRadian:Number = GameMathUtil.degreeToRadian(angleIndex * 30);
			var result:PointVO = GameMathUtil.caculatePointOnEllipse(ellipseCenterX, ellipseCenterY, resultRadian, ellipseRadian, ellipseRadian * GameFightConstant.Y_X_RATIO);
			
			if(result.x<40)
				result.x = 40;
			else if(result.x>GameFightConstant.SCENE_MAP_WIDTH-40)
				result.x = GameFightConstant.SCENE_MAP_WIDTH-40;
			if(result.y<40)
				result.y = 40;
			else if(result.y>GameFightConstant.SCENE_MAP_HEIGHT-40)
				result.y = GameFightConstant.SCENE_MAP_HEIGHT-40;
			
			return result;
		}
		
		//按照ActionScript中角度的方向分成portion等份返回index(从0-7) , 其中一个index是一个区间范围
		public static function toSpecialAngleIndexByAngle(radian:Number):int
		{
			radian = adjustRadianBetween0And2PI(radian);
			
			//这里先转化为16的区间等分， 比如: 
			// 0,15 ->  0
			// 1, 2 ->  1
			// 3, 4 ->  2
			// 5, 6 ->  3
			// 7, 8 ->  4
			// 9,10 ->  5
			//11, 12 -> 6
			//13, 14-> 7
			var index:uint = uint(radian / HALF_PORTION_ANGLE);
			if(index == 15 || index == 0) return 0;
			
			index = Math.ceil(index / 2);
			return index;
		}

		//朝向上-1中间0下面1
		public static function caculateVerticalDirectionByAngleIndex(angleIndex:int):int
		{
			if(angleIndex == 0 || angleIndex == 4) return 0;
			if(angleIndex == 1 || angleIndex == 2 || angleIndex == 3) return 1;
			else return -1;
		}
		
		//-1左0中间1右
		public static function caculateHorizontalDirectionByAngleIndex(angleIndex:int):int
		{
			if(angleIndex == 2 || angleIndex == 6) return 0;
			if(angleIndex == 0 || angleIndex == 1 || angleIndex == 7) return 1;
			else return -1;
		}
		
		//弧度转角度
		public static function radianToDegree(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}
		
		//角度转弧度
		public static function degreeToRadian(degree:Number):Number
		{
			return degree * Math.PI / 180;
		}
		
		public static function cos(radian:Number):Number
		{
			return adjustSmallNumber(Math.cos(radian));
		}
		
		public static function sin(radian:Number):Number
		{
			return adjustSmallNumber(Math.sin(radian));
		}
		
		public static function adjustSmallNumber(value:Number):Number
		{
			return Math.abs(value) < SMALLEST_NUMBER ? 0 : value;
		}

		//将角度调整到0-2PI之间
		public static function adjustRadianBetween0And2PI(radian:Number):Number
		{
			radian %= DOUBLE_PI;
			if(radian < 0) radian += DOUBLE_PI;
			return radian;
		}
		
		//将角度调整到0-360之间
		public static function adjustRadianBetween0And360(degree:Number):Number
		{
			degree %= 360;
			if(degree < 0) degree += 360;
			return degree;
		}
		
		public static function adjustProgressValue(value:Number):Number
		{
			if(value < 0) value = 0;
			else if(value > 1) value = 1;
			
			return value;
		}
		
		//判断点在椭圆内
		public static function containsPointInEllipseSearchArea(ellipseCenterX:Number, ellipseCenterY:Number, radius:Number, 
																targetX:Number, targetY:Number,yRatio:Number = 0.7 ):Boolean
		{
			var tx:Number = targetX - ellipseCenterX;
			var ty:Number = (targetY - ellipseCenterY) / yRatio;
			
			if(tx * tx + ty * ty < radius*radius)
			{
				return true;
			}
			
			return false;
		}
		
		//点是否在4边形封闭区域的关系
		//1 在内 -1 在外 0 在上, 这里的点排序是顺时针方向
		public static function judgePointInQuadrangle(p:PointVO, p0:PointVO, p1:PointVO, p2:PointVO, p3:PointVO):int
		{
			var p_p0_p1Type:int = caculatePointAndLinePositionType(p, p0, p1);
			if(p_p0_p1Type == 0) return 0;
			else if(p_p0_p1Type == -1) return -1
			
			var p_p1_p2Type:int = caculatePointAndLinePositionType(p, p1, p2);
			if(p_p1_p2Type == 0) return 0;
			else if(p_p1_p2Type == -1) return -1
			
			var p_p2_p3Type:int = caculatePointAndLinePositionType(p, p2, p3);
			if(p_p2_p3Type == 0) return 0;
			else if(p_p2_p3Type == -1) return -1
				
			var p_p3_p0Type:int = caculatePointAndLinePositionType(p, p3, p0);
			if(p_p3_p0Type == 0) return 0;
			else if(p_p3_p0Type == -1) return -1

			return 1;
		}
		
		//点和直线的关系
		//1 顺时 -1 逆时 0 在上
		public static function caculatePointAndLinePositionType(p:PointVO, p0:PointVO, p1:PointVO):int
		{
			var dotMatrix:Number = (p.x - p0.x) * (p1.y - p0.y) - (p1.x - p0.x) * (p.y - p0.y);
			if(dotMatrix > 0) return -1;
			else if(dotMatrix < 0) return 1;
			return 0;
		}
		
//		public static function caculateReversedPathPointsByCurrentPathPointsAndPathStepIndex(points:Vector.<PointVO>, pathStepIndex:int):Vector.<PointVO>
//		{
//			var results:Vector.<PointVO> = points.slice(0, pathStepIndex + 1);
//			return results.reverse();
//		}
		
		//贝塞尔曲线根据经过曲线的点求，真实的控制点
		public static function adjustBezierCurveThroughControllPointToActualControllPoint(startPoint:PointVO, 
																						  throughControllPoint:PointVO, endPoint:PointVO):void
		{
			throughControllPoint.x = throughControllPoint.x * 2 - (startPoint.x + endPoint.x) * 0.5;
			throughControllPoint.y = throughControllPoint.y * 2 - (startPoint.y + endPoint.y) * 0.5
		}
		
		public static function interpolateTwoPoints(p0:PointVO, p1:PointVO, f:Number):Point
		{
			_tempPoint0.x = p0.x;
			_tempPoint0.y = p0.y;
			_tempPoint1.x = p1.x;
			_tempPoint1.y = p1.y;
			
			return Point.interpolate(_tempPoint0, _tempPoint1, f);
		}
		
		public static function frameMoveSpeedToSeconMoveSpeed(frameMoveSpeed:Number):Number
		{
			return frameMoveSpeed * GameFightConstant.GAME_FRAME_RATE
		}

		public static function secondSpeedToFrameMoveSpeed(secondMoveSpeed:Number):Number
		{
			return secondMoveSpeed / GameFightConstant.GAME_FRAME_RATE;
		}
		
		public static function caculateFrameCountByTime(time:uint/*毫秒*/):uint
		{
			return Math.ceil(time / GameFightConstant.GAME_PER_FRAME_TIME);
		}
		
		//给定导航点路径计，算长度为Length的，导航点的位置 [positiveDirectionCurrentPathIndex, PointVO]
		public static function caculateLengthPositionByPathPoint(length:Number, 
												   currentPosition:PointVO, 
												   pathPoints:Vector.<PointVO>,
												   positiveDirectionCurrentPathIndex:int,
												   isPositiveDirection:Boolean = true):Array
		{
			if(length == 0 || 
				pathPoints == null || 
				pathPoints.length == 0) return [positiveDirectionCurrentPathIndex, new PointVO(currentPosition.x, currentPosition.y)];
			
			var currentPositionPoint:Point = _tempPoint0;
			currentPositionPoint.x = currentPosition.x;
			currentPositionPoint.y = currentPosition.y;

			var result:Point = null;
			
			var targetPathPositionPoint:Point = _tempPoint2;
			var predictionMoveDistance:Number = length;
			var toTargetPointDistance:Number = 0;
			
			if(isPositiveDirection)
			{
				var n:uint = pathPoints.length;
				var i:int = positiveDirectionCurrentPathIndex;
				
				for(; i < n; i++)
				{
					targetPathPositionPoint.x = pathPoints[i].x;
					targetPathPositionPoint.y = pathPoints[i].y;
					
					toTargetPointDistance = adjustSmallNumber(Point.distance(currentPositionPoint, targetPathPositionPoint));
					
					if(predictionMoveDistance <= toTargetPointDistance)
					{
						result = Point.interpolate(targetPathPositionPoint, currentPositionPoint, predictionMoveDistance / toTargetPointDistance); 
						return [j, new PointVO(result.x, result.y)];
					}
					
					predictionMoveDistance -= toTargetPointDistance;
					currentPositionPoint.x = targetPathPositionPoint.x;
					currentPositionPoint.y = targetPathPositionPoint.y;
				}
				
				//一直到终点都没走完
				return [n - 1, new PointVO(targetPathPositionPoint.x, targetPathPositionPoint.y)];
			}
			else
			{
				var j:int = positiveDirectionCurrentPathIndex--;
				for(j; j >= 0; j--)
				{
					targetPathPositionPoint.x = pathPoints[j].x;
					targetPathPositionPoint.y = pathPoints[j].y;
					
					toTargetPointDistance = adjustSmallNumber(Point.distance(currentPositionPoint, targetPathPositionPoint));
					
					if(predictionMoveDistance <= toTargetPointDistance)
					{
						result = Point.interpolate(targetPathPositionPoint, currentPositionPoint, predictionMoveDistance / toTargetPointDistance); 
						return [j + 1, new PointVO(result.x, result.y)];
					}
					
					predictionMoveDistance -= toTargetPointDistance;
					currentPositionPoint.x = targetPathPositionPoint.x;
					currentPositionPoint.y = targetPathPositionPoint.y;
				}
				
				//一直到终点都没走完
				return [1, new PointVO(targetPathPositionPoint.x, targetPathPositionPoint.y)];
			}
		}
		
		
		/**
		 * min <= result <= max
		 */
		public static function randomUintBetween(min:uint, max:uint):uint
		{
			if(min >= max) return max;
			
			var randdomValue:Number = Math.random();
			//if(1 - randdomValue < 0.01) randdomValue = 1;

			return min + randdomValue * (max - min + 1);
		}
		
		public static function randomFromValues(values:Array):Object
		{
			if(values == null || values.length == 0) return null;
			
			var n:uint = values.length;
			var radomIndex:int = int(Math.random() * n);
			return values[radomIndex];
		}
		
		public static function randomIndexByLength(length:uint):int
		{
			if(length == 0) return -1;
			
			return Math.random() * length;
		}

		//根据给定的概率，计算发生的结果值
		public static function randomTrueByProbability(probability:Number/*0-1*/):Boolean
		{
			if(probability == 0) return false;
			else if(probability >= 1) return true;
			
			return Math.random() <= probability;
		}
		
		private static var _tempPt:Point = new Point;
		public static function convertStagePtToGame(stageX:Number,stageY:Number,sp:Sprite = null):PointVO
		{
			if(!sp)
				return new PointVO(stageX,stageY);
			_tempPt.x = stageX;
			_tempPt.y = stageY;
			_tempPt = sp.globalToLocal(_tempPt);
			return new PointVO(_tempPt.x,_tempPt.y);
		}
		
		public static function convertStagePtToGame2(stageX:Number,stageY:Number,sp:Sprite = null):Point
		{
			if(!sp)
				return new Point(stageX,stageY);
			_tempPt.x = stageX;
			_tempPt.y = stageY;
			_tempPt = sp.globalToLocal(_tempPt);
			return new Point(_tempPt.x,_tempPt.y);
		}
    }
}