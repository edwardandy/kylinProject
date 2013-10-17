package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes
{
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	/**
	 * 弹道基础类 
	 * @author Administrator
	 * 
	 */	
	public class BasicBulletTrajectory
	{
		public var bulletPositionX:Number = 0;
		public var bulletPositionY:Number = 0;

		protected var myStartPoint:PointVO = new PointVO();
		protected var myEndPoint:PointVO = new PointVO();
		
		protected var _lastBulletPositionX:Number = 0;
		protected var _lastBulletPositionY:Number = 0;
		
		public function BasicBulletTrajectory()
		{
			super();
		}
		
		//获取运行时弹道角度
		public function getRunTimeTrajectoryAngle():Number
		{
			return GameMathUtil.radianToDegree(
				GameMathUtil.caculateDirectionRadianByTwoPoint2(_lastBulletPositionX, _lastBulletPositionY, 
					bulletPositionX, bulletPositionY));
		}
		
		//获取直线型弹道角度
		public function getStraightTrajectoryAngle():Number
		{
			return GameMathUtil.radianToDegree(
				GameMathUtil.caculateDirectionRadianByTwoPoint(myStartPoint, myEndPoint));
		}
		
		//设置弹道参数
		public function setUpBulletTrajectoryParameters(startPosition:PointVO, endPosition:PointVO, parameters:Object = null):void
		{
			if(!myStartPoint || !startPosition || !myEndPoint || !endPosition)
				return;
			
			myStartPoint.x = bulletPositionX = _lastBulletPositionX = startPosition.x;
			myStartPoint.y = bulletPositionY = _lastBulletPositionY = startPosition.y;
			myEndPoint.x = endPosition.x;
			myEndPoint.y = endPosition.y;
		}
		
		//更新
		public final function updateProgress(progress:Number):void
		{
			_lastBulletPositionX = bulletPositionX;
			_lastBulletPositionY = bulletPositionY;
			
			caculateBulletTrajectoryByProgress(progress);
		}
		
		protected function caculateBulletTrajectoryByProgress(progress:Number):void
		{
		}
	}
}