package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.skillBullets
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.identify.GroundEffectID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.ExplosionEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BulletEffectBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.TrackMissile.TrackMissileTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.TrackMissile.TrackMissileTrajectoryParam;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.skill.SkillTemplateInfo;

	/**
	 * 跟踪弹
	 */
	public class TrackMissile extends BasicBulletEffect
	{
		public function TrackMissile(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onConstructCmp():void
		{
			myIsNeedUpdateBulletAngleInRunTime = myBlletTemplateInfo.updateAngle;
			myBulletTrajectoryType = 7;		
			myBulletTrajectory = createBulletTrajectoryByType(myBulletTrajectoryType);
		}
		
		override public function fire(targetEnemy:ISkillTarget, 
							 bulletFirer:ISkillOwner, 
							 firePoint:PointVO,
							 hurtValue:uint,
							 trajectoryParameters:Object = null,
							 emphasizeBulletFallPointPoint:PointVO = null,skillState:SkillState = null):void
		{
			myTargetEnemy = targetEnemy;
			myTargetEnemySnapShootSpeed = (targetEnemy as BasicOrganismElement).getCurrentActualSpeed();
			mySkillState = skillState;
			myHurtEffectFirer = bulletFirer;
			myHurtValue = hurtValue;
			var startPoint:PointVO = new PointVO(firePoint.x, firePoint.y);
			var param:TrackMissileTrajectoryParam = new TrackMissileTrajectoryParam;
			param.radius = 60;
			param.speedPerFrame = 10;
			param.speedToTarget = 15;
			param.target = myTargetEnemy as BasicOrganismElement;
			param.turnY = 60;
			setUpBulletTrajectoryParametersWhenFire(startPoint, new PointVO, param);
		}
		
		override protected function onInit():void
		{
			changeToTargetBehaviorState(BulletEffectBehaviorState.RUNNING);
			onBulletEffectStart();
		}
		
		override protected function onRenderWhenRunning():void
		{
			_myCurrentRendTimes++;
			//if(0 == _myCurrentRendTimes%15)
			{
				//资源缺失
				addGroundEff(GroundEffectID.TrackMissileFog,0,null,myHurtEffectFirer);
			}
			if(!myTargetEnemy || !myTargetEnemy.isAlive)
			{
				var enemy:BasicOrganismElement = GameAGlobalManager.getInstance().groundSceneHelper
					.searchOrganismElementEnemy(this.x,this.y,1000,FightElementCampType.ENEMY_CAMP);
				if(enemy)
				{
					myTargetEnemy = enemy;
					(myBulletTrajectory as TrackMissileTrajectory).changeTarget(myTargetEnemy as BasicOrganismElement);
				}
			}
			
			if(myTargetEnemy && (myTargetEnemy as BasicOrganismElement).isFreezedState())
			{
				myTargetEnemy = null;
				(myBulletTrajectory as TrackMissileTrajectory).changeTarget(null);
			}
				
			
			if(myTargetEnemy && closeToTarget() && (myBulletTrajectory as TrackMissileTrajectory).isFireToTargetState())
				onBulletEffectEnd();
			else
				onRenderBulletEffect();
		}
		
		override protected function onRenderBulletEffect():void
		{
			myBulletTrajectory.updateProgress(0);
			
			this.x = myBulletTrajectory.bulletPositionX;
			this.y = myBulletTrajectory.bulletPositionY;
			
			if(myIsNeedUpdateBulletAngleInRunTime)
			{
				onUpdateBulletAngleByTrajectory(myBulletTrajectory.getRunTimeTrajectoryAngle());
			}
		}
		
		override protected function onBulletEffectEnd():void
		{
			myBulletHasHurtedTargetEnemy = checkIsHurtedTargetEnemy();
			
			if(myBulletHasHurtedTargetEnemy)
			{
				onHurtedTargetEnemy();
			}
			else
			{
				onUnHurtedTargetEnemy();
			}
			
			if(myBulletHasHurtedTargetEnemy && myAttackSceneTipTypeId > 0)
			{
				if(GameMathUtil.randomTrueByProbability(GameFightConstant.PLAY_SCENE_TIP_PROBABILITY))
				{
					SceneTipEffect.playSceneTipEffect(myAttackSceneTipTypeId, myTargetEnemy.x, 
						myTargetEnemy.y - (myTargetEnemy as BasicOrganismElement).bodyHeight);
				}
			}
			
			if(myBlletTemplateInfo.specialEffect > 0)
			{
				createBulletExplosion(myBlletTemplateInfo.specialEffect);
			}	

			onReadyToDestorySelfOnBulletEffectEnd();
		}
		
		override protected function checkIsHurtedTargetEnemy():Boolean
		{
			var enemy:BasicOrganismElement = myTargetEnemy as BasicOrganismElement;
			
			if(!enemy || !enemy.isAlive) 
				return false;
			
			return closeToTarget();
		}
		
		protected function closeToTarget():Boolean
		{
			var enemy:BasicOrganismElement = myTargetEnemy as BasicOrganismElement;
			if(!enemy)
				return false;
			var distance:Number = GameMathUtil.distance(myTargetEnemy.x, myTargetEnemy.y /*- myTargetEnemy.hurtPositionHeight*/, this.x, this.y);
			var hitAllowRange:Number = enemy.bodyWidth * 0.5 + myTargetEnemySnapShootSpeed;
			return distance < hitAllowRange;
		}
		
		override protected function createBulletExplosion(explosionTypeId:int):void
		{
			mySkillState.mainTarget = myTargetEnemy;
			var skillInfo:SkillTemplateInfo = TemplateDataFactory.getInstance().getSkillTemplateById(mySkillState.id);
			
			var vecEnemy:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance().groundSceneHelper
				.searchOrganismElementsBySearchArea(myTargetEnemy.x,myTargetEnemy.y,skillInfo.range,FightElementCampType.ENEMY_CAMP);
			mySkillState.vecTargets.length = 0;
			for each(var enemy:BasicOrganismElement in vecEnemy)
			{
				mySkillState.vecTargets.push(enemy);
			}
			//super.createBulletExplosion(explosionTypeId);
			
			var sceneExplosionEffectElement:ExplosionEffect = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.EXPLOSION, explosionTypeId, false) as ExplosionEffect;
			sceneExplosionEffectElement.blowUp(myHurtEffectFirer,getBulletExplosionPosition(), 
				Math.round(myHurtValue * GameFightConstant.EXPLOSION_HURT_BY_BULLET_PERCENT), 
				myAttackType,myBlletTemplateInfo.specialArea,mySkillState,myTargetEnemy/*, myAttackSceneTipTypeId*/);
			sceneExplosionEffectElement.notifyLifecycleActive();
		}
		
		
	}
}