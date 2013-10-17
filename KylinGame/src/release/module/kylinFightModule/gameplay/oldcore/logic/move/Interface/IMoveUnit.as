package release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface
{
	public interface IMoveUnit
	{
		function get x():Number;
		function get y():Number;
		function set x(_x:Number):void;
		function set y(_y:Number):void;
		function getCurrentActualSpeed():Number;
		/**
		 * 通知移动状态改变
		 * @param horDir :水平方向 -1左0中间1右
		 * @param verDir :垂直方向 上-1中间0下面1
		 * @param bStop  :是否停下不动
		 */
		function notifyMoveStateChange(horDir:int,verDir:int,bForceStop:Boolean):void;
		/**
		 * 瞬移了
		 */
		function notifyTeleportMove():void;
		/**
		 * 移动到了目标点
		 */
		function notifyArrivedEndPoint():void;
		/**
		 * 每次移动的通知
		 */
		function notifyMoving(oldX:Number,oldY:Number):void;
		/**
		 * 当前导航点索引
		 */
		//function get currentPathStep():int;
		
	}
}