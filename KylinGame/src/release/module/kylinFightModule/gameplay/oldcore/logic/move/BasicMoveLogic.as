package release.module.kylinFightModule.gameplay.oldcore.logic.move
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveLogic;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	public class BasicMoveLogic implements IMoveLogic
	{
		public function BasicMoveLogic()
		{
		}
		
		public function initMoveUnitByState(state:MoveState,bForceStop:Boolean = true):void
		{
			onRenderBodySkinByAngleIndex(state,bForceStop);
		}	
		
		//弧度
		public function setAngle(state:MoveState,value:Number, isApplyImmediately:Boolean = false):void
		{
			if(state.myAngle != value)
			{
				state.myAngle = value;
				state.myAngleChangedFlag = true;	
				
				if(isApplyImmediately)//立即应用
				{
					onUpdateAngle(state);
				}
			}
		}
		
		public function moveToByPath(state:MoveState,pathPoints:Vector.<PointVO>):void
		{
			if(pathPoints == null || pathPoints.length == 0) 
				return;
			state.currentPathStepIndex = 0;
			state.currentPathPoints = pathPoints;
			
			resumeWalk(state);
		}
		
		public function resumeWalk(state:MoveState):void
		{
			if(!state.myIsWalking)
			{
				state.myIsWalking = true;
				onRenderBodySkinByAngleIndex(state);
			}
		}
		
		public function stopWalk(state:MoveState):void
		{
			pauseWalk(state);
			state.currentPathStepIndex = 0;
			state.currentPathPoints = null;
		}
		
		public function pauseWalk(state:MoveState):void
		{
			if(state.myIsWalking)
			{
				state.myIsWalking = false;
				onRenderBodySkinByAngleIndex(state,true);
			}
		}
		
		private function onUpdateAngle(state:MoveState):void
		{
			if(state.myAngleChangedFlag)
			{
				state.myAngleChangedFlag = false;
				
				var targetAngleIndex:int = GameMathUtil.toSpecialAngleIndexByAngle(state.myAngle);
				if(targetAngleIndex != state.myAngleIndex)
				{
					state.myAngleIndex = targetAngleIndex;
					onRenderBodySkinByAngleIndex(state);
				}
			}
		}
		
		//只要停下来肯定是左右方向
		private function onRenderBodySkinByAngleIndex(state:MoveState,isExcuteStopWalkState:Boolean = false):void
		{
			var horizontalDirection:int = GameMathUtil.caculateHorizontalDirectionByAngleIndex(state.myAngleIndex);
			var verticalDirection:int = GameMathUtil.caculateVerticalDirectionByAngleIndex(state.myAngleIndex);
			state.unit.notifyMoveStateChange(horizontalDirection,verticalDirection,isExcuteStopWalkState);
		}	
		
		public function getRollbackPositionVOByDistance(state:MoveState,distance:Number):Array
		{
			return GameMathUtil.caculateLengthPositionByPathPoint(distance, 
				new PointVO(state.unit.x, state.unit.y), state.currentPathPoints, state.currentPathStepIndex, false);
		}
		
		public function getPredictionPositionVOByTime(state:MoveState,time:uint):PointVO
		{
			var actualSpeed:Number = state.unit.getCurrentActualSpeed();
			
			var mockCurrentPosition:PointVO = new PointVO(state.unit.x, state.unit.y);
			
			if(actualSpeed <= 0 ||
				state.currentPathPoints == null || 
				state.currentPathPoints.length == 0) return mockCurrentPosition;
			
			var mockcurrentPathStepIndex:int = state.currentPathStepIndex;
			
			var targetPathPoint:PointVO = null;
			var distance:Number = 0;
			var angle:Number = 0;
			
			var tickTimes:int = GameMathUtil.caculateFrameCountByTime(time);
			for(; tickTimes > 0; tickTimes--)
			{
				targetPathPoint = state.currentPathPoints[mockcurrentPathStepIndex];
				distance = GameMathUtil.distance(targetPathPoint.x, targetPathPoint.y, mockCurrentPosition.x, mockCurrentPosition.y);
				if(distance < actualSpeed)
				{
					mockcurrentPathStepIndex++;
					
					if(mockcurrentPathStepIndex >= state.currentPathPoints.length)
					{
						mockCurrentPosition.x = targetPathPoint.x;
						mockCurrentPosition.y = targetPathPoint.y;
						break;
					}
				}
				else
				{
					angle = GameMathUtil.caculateDirectionRadianByTwoPoint2(mockCurrentPosition.x, mockCurrentPosition.y, targetPathPoint.x, targetPathPoint.y)
					mockCurrentPosition.x += actualSpeed * Math.cos(angle);
					mockCurrentPosition.y += actualSpeed * Math.sin(angle);
				}
			}
			
			return mockCurrentPosition;
		}
		
		public function update(state:MoveState):void
		{
			if(state.myIsWalking) 
				onUpdatePosition(state);
			onUpdateAngle(state);
		}
		
		private function onUpdatePosition(state:MoveState):void
		{
			//			var t:int = getTimer();
			
			var actualSpeed:Number = state.unit.getCurrentActualSpeed();
			
			if(actualSpeed <= 0 ||
				state.currentPathPoints == null || 
				state.currentPathPoints.length == 0) return;
			
			var targetPathPoint:PointVO = state.currentPathPoints[state.currentPathStepIndex];
			var distance:Number = GameMathUtil.distance(targetPathPoint.x, targetPathPoint.y, state.unit.x, state.unit.y);
			var oldX:Number;
			var oldY:Number;
			//瞬移
			if(actualSpeed > GameFightConstant.MAX_MOVE_SPEED && distance>GameFightConstant.MIN_TELEPORT_RANGE)
			{
				onTeleportMove(state);
				state.myIsWalking = false;
				return;
			}
			if(actualSpeed > GameFightConstant.MAX_MOVE_SPEED)
				actualSpeed = GameFightConstant.NON_TELEPORT_SPEED;
			if(distance < actualSpeed)
			{
				state.currentPathStepIndex++;
				
				if(state.currentPathStepIndex >= state.currentPathPoints.length)
				{
					oldX = state.unit.x;
					oldY = state.unit.y;
					state.unit.x = targetPathPoint.x;
					state.unit.y = targetPathPoint.y;
					state.unit.notifyMoving(oldX,oldY);
					stopWalk(state);
					state.unit.notifyArrivedEndPoint();
				}
			}
			else
			{
				this.setAngle(state,GameMathUtil.caculateDirectionRadianByTwoPoint2(state.unit.x,state.unit.y, targetPathPoint.x, targetPathPoint.y));
				oldX = state.unit.x;
				oldY = state.unit.y;
				state.unit.x += actualSpeed * Math.cos(state.myAngle);
				state.unit.y += actualSpeed * Math.sin(state.myAngle);
				state.unit.notifyMoving(oldX,oldY);
			}
			
			//			trace(getTimer() - t);
		}
		
		//瞬移
		private function onTeleportMove(state:MoveState):void
		{
			state.unit.notifyTeleportMove();
		}
		
		//保持站立姿势
		public function enforceRecoverToStandState(state:MoveState):void
		{
			state.myIsWalking = false;
			onRenderBodySkinByAngleIndex(state,true);
		}
		
		public function updateWalkPathStepIndex(state:MoveState,pathStepIndex:int):void
		{
			if(state.currentPathPoints == null || state.currentPathPoints.length == 0) return;
			
			state.currentPathStepIndex = pathStepIndex;
			if(state.currentPathStepIndex <= 0) 
				state.currentPathStepIndex = 0;
			else if(state.currentPathStepIndex > state.currentPathPoints.length - 1) 
				state.currentPathStepIndex = state.currentPathPoints.length - 1;
		}
		
		public function dispose():void
		{
			
		}
	}
}