package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.TrackMissile
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.BasicBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IPositionUnit;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.geom.Point;

	/**
	 * 跟踪导弹弹道
	 */
	public class TrackMissileTrajectory extends BasicBulletTrajectory
	{
		private static const ToTargetDuration:int = 500;
		private var _param:TrackMissileTrajectoryParam;
		private var _state:int = TrackMissileTrajectoryState.NotReady;
		private var _radian:Number;
		private var _oldDegree:Number;
		private var _curSpeed:Number;
		private var _curDirection:Number;
		
		private var _ptTemp1:PointVO = new PointVO;
		private var _ptTemp2:PointVO = new PointVO;
		
		private var _oldPointX:Number;
		private var _oldPointY:Number;
		
		public function TrackMissileTrajectory()
		{
			super();
		}
		
		override public function setUpBulletTrajectoryParameters(startPosition:PointVO, endPosition:PointVO, trajectoryParameters:Object = null):void
		{
			super.setUpBulletTrajectoryParameters(startPosition, endPosition, trajectoryParameters);
			_param = trajectoryParameters as TrackMissileTrajectoryParam;
			_param.turnY = myStartPoint.y - _param.turnY;
			_state = TrackMissileTrajectoryState.UpToTurnPoint;
		}
		
		override protected function caculateBulletTrajectoryByProgress(progress:Number):void
		{
			switch(_state)
			{
				case TrackMissileTrajectoryState.UpToTurnPoint:
				{
					onUpdateUpToTurnPoint();
				}
					break;
				case TrackMissileTrajectoryState.TurnLeft:
				{
					onUpdateTurnLeftOrRight(true);
				}
					break;
				case TrackMissileTrajectoryState.TurnRight:
				{
					onUpdateTurnLeftOrRight(false);
				}
					break;
				case TrackMissileTrajectoryState.FireToTarget:
				{
					onUpdateFireToTarget();
				}
					break;
			}
			
			if(GameMathUtil.adjustSmallNumber(bulletPositionX-_lastBulletPositionX)!=0 || GameMathUtil.adjustSmallNumber(bulletPositionY-_lastBulletPositionY)!=0)
			{
				_oldPointX = _lastBulletPositionX;
				_oldPointY = _lastBulletPositionY;
			}
		}
		/**
		 * 一开始直线向上飞
		 */
		private function onUpdateUpToTurnPoint():void
		{
			if(checkChangeToTurnLeftOrRight())
				return;
			bulletPositionY -= _param.speedPerFrame;	
			//checkChangeToTurnLeftOrRight();
		}
		
		private function checkChangeToTurnLeftOrRight():Boolean
		{
			if(bulletPositionY <= _param.turnY)
			{
				caculateTurnLeftOrRight();
				return true;
			}
			return false;
		}
		
		private function caculateTurnLeftOrRight():void
		{
			var degree:Number = 0;
			if(_param.target)
				degree = GameMathUtil.caculateDegreeByTwoLine2
				(_oldPointX,_oldPointY,bulletPositionX,bulletPositionY,bulletPositionX,bulletPositionY,_param.target.x,_param.target.y);
			else
			{
				degree = GameMathUtil.caculateDegreeByTwoLine2
					(_oldPointX,_oldPointY,bulletPositionX,bulletPositionY,bulletPositionX,bulletPositionY,_param.center.x,_param.center.y);
				if(degree>0)
					degree = 2;
				else
					degree = 360-2;
			}
			
			if(degree>=359 || degree<=1)
			{
				_state = TrackMissileTrajectoryState.FireToTarget;
				var disTarget:Number = GameMathUtil.distance(bulletPositionX,bulletPositionY,_param.target.x,_param.target.y);
				var expFrames:int = disTarget/_param.speedToTarget;
				var ptExpect:PointVO = _param.target.getPredictionPositionVOByTime(expFrames/GameFightConstant.GAME_FRAME_RATE*1000);
				var dis:Number = GameMathUtil.distance(bulletPositionX,bulletPositionY,ptExpect.x,ptExpect.y);
				_curSpeed = dis/expFrames; //GameMathUtil.caculateFrameCountByTime(ToTargetDuration);
				_curDirection = GameMathUtil.caculateDirectionRadianByTwoPoint2(bulletPositionX,bulletPositionY,ptExpect.x,ptExpect.y);
				//_curSpeed = _param.speedPerFrame;
				return;
			}
			_oldDegree = 0;
			if((degree<=180 && TrackMissileTrajectoryState.TurnLeft == _state) 
				|| (degree>180 && TrackMissileTrajectoryState.TurnRight == _state))
				return;
			var tanDegree:Number =GameMathUtil.adjustRadianBetween0And360(GameMathUtil.radianToDegree(Math.atan2(bulletPositionY-_oldPointY,bulletPositionX-_oldPointX)));
			tanDegree += degree<=180?-90:90;
			var ptCenter:PointVO = GameMathUtil.caculatePointOnCircle(bulletPositionX,bulletPositionY,tanDegree,_param.radius,true);
			_param.center.y = ptCenter.y;
			_param.center.x = ptCenter.x;
			_radian = GameMathUtil.adjustRadianBetween0And2PI(Math.atan2(bulletPositionY-ptCenter.y,bulletPositionX-ptCenter.x));
			_state = degree<=180?TrackMissileTrajectoryState.TurnLeft:TrackMissileTrajectoryState.TurnRight;
			
		}
		/**
		 * 向左或向右转圈
		 */
		private function onUpdateTurnLeftOrRight(bLeft:Boolean):void
		{
			if(checkChangeToStraightTarget())
				return;
			_radian += _param.speedPerFrame/_param.radius * (bLeft?-1:1);
			var pt:PointVO = GameMathUtil.caculatePointOnCircle(_param.center.x,_param.center.y,_radian,_param.radius);
			bulletPositionX = pt.x;
			bulletPositionY = pt.y;
		}
		
		private function checkChangeToStraightTarget():Boolean
		{
			if(!_param.target)
				return false;
			var disTarget:Number = GameMathUtil.distance(bulletPositionX,bulletPositionY,_param.target.x,_param.target.y);
			var expFrames:int = disTarget/_param.speedToTarget;
			var ptExpect:PointVO = _param.target.getPredictionPositionVOByTime(expFrames/GameFightConstant.GAME_FRAME_RATE*1000);
			
			var degree:Number = GameMathUtil.caculateDegreeByTwoLine2(bulletPositionX,bulletPositionY,ptExpect.x,ptExpect.y,bulletPositionX,bulletPositionY,_param.center.x,_param.center.y);
			
			var tempRad:Number = _radian + _param.speedPerFrame/_param.radius * (TrackMissileTrajectoryState.TurnLeft == _state?-1:1);
			var ptNext:PointVO = GameMathUtil.caculatePointOnCircle(_param.center.x,_param.center.y,tempRad,_param.radius);
			var degreeNext:Number = GameMathUtil.caculateDegreeByTwoLine2(ptNext.x,ptNext.y,ptExpect.x,ptExpect.y,ptNext.x,ptNext.y,_param.center.x,_param.center.y);
			
			var iDegree:int = int(degree);
			var iDegreeNext:int = int(degreeNext);
			//trace("degree:",iDegree)
			if((TrackMissileTrajectoryState.TurnLeft == _state && iDegree == 270)
				|| (TrackMissileTrajectoryState.TurnRight == _state && iDegree == 90)
				|| (/*_oldDegree>0 && */TrackMissileTrajectoryState.TurnLeft == _state && iDegree>270 && iDegreeNext<270) 
				|| (/*_oldDegree>0 && */TrackMissileTrajectoryState.TurnRight == _state && iDegree<90 && iDegreeNext>90) )
			{
				_state = TrackMissileTrajectoryState.FireToTarget;
				disTarget = GameMathUtil.distance(bulletPositionX,bulletPositionY,_param.target.x,_param.target.y);
				expFrames = disTarget/_param.speedToTarget;
				var dis:Number = GameMathUtil.distance(bulletPositionX,bulletPositionY,ptExpect.x,ptExpect.y);
				_curSpeed = dis/expFrames; //GameMathUtil.caculateFrameCountByTime(ToTargetDuration);
				_curDirection = GameMathUtil.caculateDirectionRadianByTwoPoint2(bulletPositionX,bulletPositionY,ptExpect.x,ptExpect.y);
				//_curSpeed = _param.speedPerFrame;
				return true;
			}
			//_oldDegree = iDegree;
			return false;
		}
		
		/**
		 * 直接飞向目标
		 */
		private function onUpdateFireToTarget():void
		{
			if(!_param.target)
			{
				caculateTurnLeftOrRight();
				return;
			}
			var dis:Number = GameMathUtil.distance(bulletPositionX,bulletPositionY,_param.target.x,_param.target.y);
			
			
			var ptResult:PointVO = GameMathUtil.caculatePointOnCircle(bulletPositionX, bulletPositionY,_curDirection,_curSpeed);
			bulletPositionX = ptResult.x;
			bulletPositionY = ptResult.y;	
			var disResult:Number = GameMathUtil.distance(ptResult.x,ptResult.y,_param.target.x,_param.target.y);
			if(disResult > dis)
			{
				bulletPositionX = _param.target.x;
				bulletPositionY = _param.target.y;
			}
			return;
			
			var tan:Number = GameMathUtil.caculateDirectionRadianByTwoPoint2(_oldPointX, _oldPointY, bulletPositionX, bulletPositionY);		
			var ptTarget:PointVO = /*new PointVO(_param.target.x,_param.target.y);*/ _param.target.getPredictionPositionVOByTime(dis/_curSpeed/GameFightConstant.GAME_FRAME_RATE);
			var targetTan:Number = GameMathUtil.caculateDirectionRadianByTwoPoint2(bulletPositionX,bulletPositionY,ptTarget.x,ptTarget.y);
			var delta:Number = GameMathUtil.adjustSmallNumber(tan - targetTan);
			/*var radian:Number = GameMathUtil.caculateRadianByTwoLine2
				(bulletPositionX,bulletPositionY,_param.target.x,_param.target.y,_oldPointX,_oldPointY,bulletPositionX,bulletPositionY);*/
			var temp:Number;
			var tempDelta:Number;
			if(delta>0 && delta<Math.PI)
			{
				temp = tan-GameMathUtil.degreeToRadian(1);
				tempDelta = GameMathUtil.adjustSmallNumber(temp - targetTan);
				if(tempDelta<=0)
					temp = targetTan;		
			}
			else if(delta == 0)
			{
				temp = targetTan;
			}
			else
			{
				temp = tan+GameMathUtil.degreeToRadian(1);
				if(temp>GameMathUtil.DOUBLE_PI)
					temp -= GameMathUtil.DOUBLE_PI;
				tempDelta = GameMathUtil.adjustSmallNumber(temp - targetTan);
				if(tempDelta>0 && tempDelta<Math.PI)
					temp = targetTan;
			}
			
			
			ptResult = GameMathUtil.caculatePointOnCircle(bulletPositionX, bulletPositionY,temp,_curSpeed);
			var resultTan:Number = GameMathUtil.caculateDirectionRadianByTwoPoint2(ptResult.x,ptResult.y,ptTarget.x,ptTarget.y);
			//trace("targetTan,resultTan",GameMathUtil.radianToDegree(temp),GameMathUtil.radianToDegree(resultTan));
			/*_ptTemp1.x = _param.target.x;
			_ptTemp1.y = _param.target.y;
			_ptTemp2.x = bulletPositionX;
			_ptTemp2.y = bulletPositionY;
			var distence:Number = GameMathUtil.distance(_ptTemp1.x,_ptTemp1.y,_ptTemp2.x,_ptTemp2.y);
			var ptResult:Point = GameMathUtil.interpolateTwoPoints(_ptTemp1,_ptTemp2,_param.speedPerFrame/distence);*/
			disResult = GameMathUtil.distance(ptResult.x,ptResult.y,_param.target.x,_param.target.y);
			if(disResult > dis)
			{
				bulletPositionX = _param.target.x;
				bulletPositionY = _param.target.y;
			}
			else
			{
				bulletPositionX = ptResult.x;
				bulletPositionY = ptResult.y;	
			}
			
			/*if(_curSpeed < _param.speedToTarget)
			{
				_curSpeed += 1;
				if(_curSpeed > _param.speedToTarget)
					_curSpeed = _param.speedToTarget;
			}*/
			
		}
		
		/**
		 * 切换目标并转换状态
		 */
		public function changeTarget(target:BasicOrganismElement):void
		{
			_param.target = target;
			if(target && TrackMissileTrajectoryState.UpToTurnPoint!=_state)
				caculateTurnLeftOrRight();
		}
		
		public function isFireToTargetState():Boolean
		{
			return TrackMissileTrajectoryState.FireToTarget == _state;
		}
		
		//获取运行时弹道角度
		override public function getRunTimeTrajectoryAngle():Number
		{
			return GameMathUtil.radianToDegree(
				GameMathUtil.caculateDirectionRadianByTwoPoint2(_oldPointX, _oldPointY, 
					bulletPositionX, bulletPositionY));
		}
		
	}
}