package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	/**
	 * 炮弹 
	 * @author Administrator
	 * 
	 */	
	public class ShellBulletEffect extends BasicBulletEffect
	{
		//炮弹打到人是在人的身体中心位置,但是爆炸却是在脚底
		private var _shellPointOfFallHeight:Number = 0;
		
		public function ShellBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		override protected function setUpBulletTrajectoryParametersWhenFire(startPoint:PointVO, endPoint:PointVO, trajectoryParameters:Object = null):void
		{
			super.setUpBulletTrajectoryParametersWhenFire(startPoint, endPoint, trajectoryParameters);
			_shellPointOfFallHeight = (myTargetEnemy && myTargetEnemy.isAlive && !myTargetEnemy.isFreezedState()) ? 
				myTargetEnemy.hurtPositionHeight : 0;		
		}
		
		override protected function getBulletExplosionPosition():PointVO
		{
			return new PointVO(this.x, this.y + _shellPointOfFallHeight)
		}
	}
}