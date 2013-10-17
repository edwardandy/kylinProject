package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.ExplosionEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ParabolaBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
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