package release.module.kylinFightModule.gameplay.oldcore.logic.move
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveUnit;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	public class MoveState implements IDisposeObject
	{
		/**
		 * 基本速度
		 */
		public var mySpeed:Number = 0;
		/**
		 * 速度加成百分比
		 */
		public var mySpeedPct:Number = 0;
		
		public var myAngle:Number = 0;//弧度
		public var myAngleIndex:int = 0;
		public var myAngleChangedFlag:Boolean = false;	
		public var myIsWalking:Boolean = false;
		
		public var currentPathStepIndex:int = 0;
		public var currentPathPoints:Vector.<PointVO> = null;
		
		private var bStore:Boolean = false;
		public var storePathStepIndex:int = 0;
		public var storePathPoints:Vector.<PointVO> = null;
		
		public var unit:IMoveUnit;
		
		public function MoveState(moveunit:IMoveUnit)
		{
			unit = moveunit;
		}
		
		public function clear():void
		{
			mySpeed = 0;
			mySpeedPct = 0;
			myAngle = 0;
			myAngleIndex = 0;
			myAngleChangedFlag = false;	
			myIsWalking = false;
			currentPathStepIndex = 0;
			currentPathPoints = null;
			storePathStepIndex = 0;
			storePathPoints = null;
			bStore = false;
		}
		
		public function dispose():void
		{
			clear();
			unit = null;
		}
		
		public function storePath():void
		{
			if(!bStore)
			{
				bStore = true;
				storePathStepIndex = currentPathStepIndex;
				storePathPoints = currentPathPoints;
			}
		}
		
		public function restorePath():void
		{
			if(bStore)
			{
				bStore = false;
				currentPathStepIndex = storePathStepIndex;
				currentPathPoints = storePathPoints;
			}
		}
		
		public function getCurrentLineIndex():int
		{
			if(bStore)
				return storePathStepIndex;
			else
				return currentPathStepIndex;
		}
	}
	
	
}