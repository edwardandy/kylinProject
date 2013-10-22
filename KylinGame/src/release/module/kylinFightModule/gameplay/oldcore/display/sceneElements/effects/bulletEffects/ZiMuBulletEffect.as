package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.ExplosionEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 子母弹
	 */
	public class ZiMuBulletEffect extends BasicBulletEffect
	{
		private static var OFFSETY:int = 183;
		public function ZiMuBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		override public function fire(targetEnemy:ISkillTarget, bulletFirer:ISkillOwner, firePoint:PointVO, hurtValue:uint, trajectoryParameters:Object=null, emphasizeBulletFallPointPoint:PointVO=null, skillState:SkillState=null):void
		{
			myTargetEnemy = targetEnemy;
			mySkillState = skillState;
			trajectoryParameters = 200;
			myIsNeedUpdateBulletAngleInRunTime = true;
			
			var enemy:BasicOrganismElement = myTargetEnemy as BasicOrganismElement;
			//子弹可能没有敌人
			if(myTargetEnemy != null)
			{
				myTargetEnemySnapShootSpeed = enemy.getCurrentActualSpeed();
			}
			
			if(myBulletTrajectory != null)
			{
				var startPoint:PointVO = new PointVO(firePoint.x, firePoint.y);
				var endPoint:PointVO = null;
				
				//如果有强调落点的话，会优先使用
				if(emphasizeBulletFallPointPoint != null)
				{
					endPoint = emphasizeBulletFallPointPoint.clone();
				}
				else
				{
					endPoint = enemy.getPredictionPositionVOByTime(myDuration);
					endPoint.y = endPoint.y - enemy.hurtPositionHeight;

				}	
				endPoint.y -= OFFSETY;
				/*if(endPoint.y<0)
					endPoint.y = 0 ;*/
				setUpBulletTrajectoryParametersWhenFire(startPoint, endPoint, trajectoryParameters);
			}
			
			myHurtEffectFirer = bulletFirer;
			myHurtValue = hurtValue;
			_myCurrentRendTimes = 0;
		}
		
		override protected function createBulletExplosion(explosionTypeId:int):void
		{
			var sceneExplosionEffectElement:ExplosionEffect = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.EXPLOSION, explosionTypeId, false) as ExplosionEffect;
			
			var pt:PointVO = getBulletExplosionPosition();
			pt.y += OFFSETY;
			sceneExplosionEffectElement.blowUp(myHurtEffectFirer, pt, 
				Math.round(myHurtValue * GameFightConstant.EXPLOSION_HURT_BY_BULLET_PERCENT), 
				myAttackType,40/*, myAttackSceneTipTypeId*/);
			sceneExplosionEffectElement.notifyLifecycleActive();
		}
	}
}