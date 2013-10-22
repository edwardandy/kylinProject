package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.StraightBullectTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ArcaneBomb.ArcaneBombBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public class ArcaneBombBulletEffect extends BasicBulletEffect
	{
		private var _trajectParam:int;
		private var _order:int;
		
		public function ArcaneBombBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onConstructCmp():void
		{
			myIsNeedUpdateBulletAngleInRunTime = true;
		}
		
		public function setOrder(iOrder:int):void
		{
			_order = iOrder;
			/*myBulletTrajectory = new ArcaneBombBulletTrajectory;
			myDuration = 150;
			_trajectParam = -20;*/
			switch(_order)
			{
				case 0:
					myBulletTrajectory = new StraightBullectTrajectory;
					myDuration = 100;
					_trajectParam = 0;
					break;
				case 1:
					myBulletTrajectory = new ArcaneBombBulletTrajectory;
					myDuration = 150;
					_trajectParam = 20;
					break;
				case 2:
					myBulletTrajectory = new ArcaneBombBulletTrajectory;
					myDuration = 200;
					_trajectParam = -20;
					break;
				case 3:
					myBulletTrajectory = new ArcaneBombBulletTrajectory;
					myDuration = 250;
					_trajectParam = 40;
					break;
				case 4:
					myBulletTrajectory = new ArcaneBombBulletTrajectory;
					myDuration = 300;
					_trajectParam = -40;
					break;
			}
			
			_myTotalRendTimes = GameMathUtil.caculateFrameCountByTime(myDuration);
		}
		
		override protected function setUpBulletTrajectoryParametersWhenFire(startPoint:PointVO, endPoint:PointVO, 
																   trajectoryParameters:Object = null):void
		{
			myBulletTrajectory.setUpBulletTrajectoryParameters(startPoint, endPoint, _trajectParam);
		}
		
		override protected function createBulletExplosion(explosionTypeId:int):void
		{
			if(4 == _order)
				super.createBulletExplosion(explosionTypeId);
		}
			
	}
}