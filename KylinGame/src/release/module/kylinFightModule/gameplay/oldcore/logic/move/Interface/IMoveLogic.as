package release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.MoveState;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	public interface IMoveLogic extends IDisposeObject
	{
		function initMoveUnitByState(state:MoveState,bForceStop:Boolean = true):void;
		function setAngle(state:MoveState,value:Number, isApplyImmediately:Boolean = false):void;
		function moveToByPath(state:MoveState,pathPoints:Vector.<PointVO>):void;
		
		function resumeWalk(state:MoveState):void;
		function stopWalk(state:MoveState):void;
		function pauseWalk(state:MoveState):void;
		/**
		 * 每帧更新移动状态
		 */
		function update(state:MoveState):void;
		/**
		 * 计算回退多少距离的位置
		 * @param distance :回退的距离
		 * @return 返回 点的位置 [positiveDirectionCurrentPathIndex, PointVO]
		 */
		function getRollbackPositionVOByDistance(state:MoveState,distance:Number):Array;
		/**
		 * 根据当前速度预估多少时间后的位置
		 */
		function getPredictionPositionVOByTime(state:MoveState,time:uint):PointVO;
		/**
		 * 保持站立姿势
		 */
		function enforceRecoverToStandState(state:MoveState):void;
		/**
		 * 通过给定的步数更新导航路径
		 */
		function updateWalkPathStepIndex(state:MoveState,pathStepIndex:int):void;
	}
}