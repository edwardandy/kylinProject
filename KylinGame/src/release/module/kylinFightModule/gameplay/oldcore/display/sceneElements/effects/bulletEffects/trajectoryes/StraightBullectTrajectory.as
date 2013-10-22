package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes
{
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	/**
	 * 直线型弹道 
	 * @author Administrator
	 * 
	 */	
	public class StraightBullectTrajectory extends BasicBulletTrajectory
	{
		public function StraightBullectTrajectory()
		{
			super();
		}
		
		override public function getRunTimeTrajectoryAngle():Number
		{
			return GameMathUtil.radianToDegree(
				GameMathUtil.caculateDirectionRadianByTwoPoint2(myStartPoint.x, myStartPoint.y, 
					myEndPoint.x, myEndPoint.y));
		}
		
		override protected function caculateBulletTrajectoryByProgress(progress:Number):void
		{
			bulletPositionX = myStartPoint.x + (myEndPoint.x - myStartPoint.x) * progress;
			bulletPositionY = myStartPoint.y + (myEndPoint.y - myStartPoint.y) * progress;
		}
	}
}