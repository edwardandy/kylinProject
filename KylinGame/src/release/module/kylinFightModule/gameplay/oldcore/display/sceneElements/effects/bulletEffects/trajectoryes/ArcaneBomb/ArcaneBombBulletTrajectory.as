package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ArcaneBomb
{
	import flash.geom.Point;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ParabolaBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public class ArcaneBombBulletTrajectory extends ParabolaBulletTrajectory
	{
		public function ArcaneBombBulletTrajectory()
		{
			super();
		}
		
		override protected function genControlPoint(trajectoryParameters:Object):void
		{
			var iNum:int = trajectoryParameters as int;
			var bNeg:Boolean = iNum > 0;
			iNum = Math.abs(iNum);
			
			//经过曲线的点
			var middleControllPoint:Point = GameMathUtil.interpolateTwoPoints(myStartPoint, myEndPoint, 0.2);
			var middle:PointVO = new PointVO(middleControllPoint.x,middleControllPoint.y);
			
			var vecLine:Vector.<PointVO> = new Vector.<PointVO>;
			vecLine.push(middle);
			vecLine.push(myStartPoint);
			
			var arrResult:Array = GameMathUtil.caculateTwoParallelLinesByMiddleLine(vecLine,iNum);
			var p1:PointVO = (arrResult[0] as Vector.<PointVO>)[0];
			var p2:PointVO = (arrResult[1] as Vector.<PointVO>)[0];
			var p:PointVO;
			if((p1.y < middle.y && bNeg) || (p1.y > middle.y && !bNeg))
				p = p1;
			else
				p = p2;
			
			_myControllPoint.x = p.x;
			_myControllPoint.y = p.y;
			
			//求真实的控制点
			//GameMathUtil.adjustBezierCurveThroughControllPointToActualControllPoint(myStartPoint, _myControllPoint, myEndPoint);
			//_myControllPoint.y -= myBulletParabolaHeight;	
		}
	}
}