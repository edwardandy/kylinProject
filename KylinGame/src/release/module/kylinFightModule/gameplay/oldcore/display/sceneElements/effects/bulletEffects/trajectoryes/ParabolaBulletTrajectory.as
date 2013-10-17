package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes
{
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * 抛物线型弹道。 该抛物线由二次贝塞尔曲线实现 
	 * @author Administrator
	 * 
	 */	
	public class ParabolaBulletTrajectory extends BasicBulletTrajectory
	{
		protected var _myControllPoint:PointVO = new PointVO();
		private var myBulletParabolaHeight:Number = 0;
		
		public function ParabolaBulletTrajectory()
		{
			super();
		}
		
		//这里要对控制点做些特殊处理
		override public function setUpBulletTrajectoryParameters(startPosition:PointVO, endPosition:PointVO, trajectoryParameters:Object = null):void
		{
			super.setUpBulletTrajectoryParameters(startPosition, endPosition, trajectoryParameters);
			genControlPoint(trajectoryParameters);	
		}
		
		protected function genControlPoint(trajectoryParameters:Object):void
		{
			myBulletParabolaHeight = Number(trajectoryParameters);
			
			//经过曲线的点
			var middleControllPoint:Point = GameMathUtil.interpolateTwoPoints(myStartPoint, myEndPoint, 0.5);
			_myControllPoint.x = middleControllPoint.x;
			_myControllPoint.y = middleControllPoint.y;
			
			//求真实的控制点
			GameMathUtil.adjustBezierCurveThroughControllPointToActualControllPoint(myStartPoint, _myControllPoint, myEndPoint);
			_myControllPoint.y -= myBulletParabolaHeight;
		}
		
		override protected function caculateBulletTrajectoryByProgress(progress:Number):void
		{
			var t0:Number = 1 - progress;
			var t1:Number = t0 * t0;
			var t2:Number = 2 * progress * t0;
			var t3:Number = progress * progress;
			
			bulletPositionX = t1 * myStartPoint.x + t2 * _myControllPoint.x + t3 * myEndPoint.x;
			bulletPositionY = t1 * myStartPoint.y + t2 * _myControllPoint.y + t3 * myEndPoint.y;
			
//			s.graphics.lineStyle(1, 0xFF0000);
//			s.graphics.lineTo(bulletPositionX, bulletPositionY);
//			trace(startPosition, controllPoint, endPosition);
		}
	}
}