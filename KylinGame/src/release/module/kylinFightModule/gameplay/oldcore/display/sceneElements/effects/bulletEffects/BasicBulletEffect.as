package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import mainModule.model.gameData.sheetData.weapon.IWeaponSheetDataModel;
	import mainModule.model.gameData.sheetData.weapon.IWeaponSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.ExplosionEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.BasicBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ParabolaBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.StraightBullectTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.TrackMissile.TrackMissileTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public class BasicBulletEffect extends BasicBodySkinSceneElement//extends BasicHurtEffect implements IOrganismSkiller
	{
		[Inject]
		public var weaponModel:IWeaponSheetDataModel;
		
		protected var myHurtValue:uint;
		protected var myAttackType:int;
		
		protected var myAttackSceneTipTypeId:int = -1;
		
		protected var mySkillState:SkillState;
		
		protected var myTargetEnemy:ISkillTarget//BasicOrganismElement;
		protected var myHurtEffectFirer:ISkillOwner;
		protected var myTargetEnemySnapShootSpeed:Number = 0;
		
		protected var myDuration:uint = 0;//毫秒数
		
		protected var myBlletTemplateInfo:IWeaponSheetItem;
		protected var myBulletTrajectory:BasicBulletTrajectory;//弹道

		//由抛物线决定
		protected var myIsNeedUpdateBulletAngleInRunTime:Boolean = false;
		
		/*protected var myHasAppearAnimation:Boolean = false;
		protected var myHasDisappearAnimation:Boolean = false;
		protected var myHasBulletAnimation:Boolean = false;*/
		protected var myBulletHasHurtedTargetEnemy:Boolean = false;
		
		protected var _myCurrentRendTimes:int = 0;
		protected var _myTotalRendTimes:int = 0;
		
		protected var myBulletTrajectoryType:int = 0;
		protected var myBulletEffectProgress:Number = 0;
		
		public function BasicBulletEffect(typeId:int)
		{
			super();

			this.myElemeCategory = GameObjectCategoryType.BULLET;
			this.myObjectTypeId = typeId;
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_TOP;
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			myBlletTemplateInfo = weaponModel.getWeaponSheetById(myObjectTypeId);				
			onConstructCmp();
		}
		
		protected function onConstructCmp():void
		{
			myDuration = myBlletTemplateInfo.duration;
			myIsNeedUpdateBulletAngleInRunTime = myBlletTemplateInfo.updateAngle;
			
			if(myBulletTrajectoryType == 0)
			{
				myBulletTrajectoryType = myBlletTemplateInfo.type;	
			}
			
			myBulletTrajectory = createBulletTrajectoryByType(myBulletTrajectoryType);
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return myBlletTemplateInfo.resId>0 ? (myElemeCategory + "_" + myBlletTemplateInfo.resId) : super.bodySkinResourceURL;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_myTotalRendTimes = GameMathUtil.caculateFrameCountByTime(myDuration);
		}

		public function fire(targetEnemy:ISkillTarget, 
							 bulletFirer:ISkillOwner, 
							 firePoint:PointVO,
							 hurtValue:uint,
							 trajectoryParameters:Object = null,
							 emphasizeBulletFallPointPoint:PointVO = null,skillState:SkillState = null):void
		{

			myTargetEnemy = targetEnemy;
			mySkillState = skillState;
			var tower:BasicTowerElement;
			var enemy:BasicOrganismElement;
			
			//子弹可能没有敌人
			if(myTargetEnemy != null)
			{
				if(GameObjectCategoryType.TOWER == myTargetEnemy.elemeCategory)
					tower = myTargetEnemy as BasicTowerElement;
				else
					enemy = myTargetEnemy as BasicOrganismElement;
				
				if(enemy && enemy.isAlive)
					myTargetEnemySnapShootSpeed = enemy.getCurrentActualSpeed();
				else 
					myTargetEnemySnapShootSpeed = 0;
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
					if(enemy)
					{
						if(enemy.isAlive)
						{
							endPoint = enemy.getPredictionPositionVOByTime(myDuration);
							endPoint.y = endPoint.y - enemy.hurtPositionHeight;
						}
						else
							endPoint = new PointVO(enemy.x, enemy.y);
						
						
					}
					else if(tower)
					{
						endPoint = new PointVO(tower.x, tower.y);
					}
				}

				setUpBulletTrajectoryParametersWhenFire(startPoint, endPoint, trajectoryParameters);
			}

			myHurtEffectFirer = bulletFirer;
			myHurtValue = hurtValue;
			_myCurrentRendTimes = 0;
		}
		
		protected function setUpBulletTrajectoryParametersWhenFire(startPoint:PointVO, endPoint:PointVO, 
																   trajectoryParameters:Object = null):void
		{
			myBulletTrajectory.setUpBulletTrajectoryParameters(startPoint, endPoint, trajectoryParameters);
		}

		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			onInit();
		}
		
		protected function onInit():void
		{
			myBulletEffectProgress = 0;
			if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
			{
				changeToTargetBehaviorState(BulletEffectBehaviorState.APPEAR);
			}
			else
			{
				changeToTargetBehaviorState(BulletEffectBehaviorState.RUNNING);
			}
			
			onBulletEffectStart();
		}

		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();

			myBulletHasHurtedTargetEnemy = false;
			myTargetEnemy = null;
			myAttackSceneTipTypeId = -1;
			mySkillState = null;
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			if(!myBodySkin)
			{
				return;
			}
			switch(currentBehaviorState)
			{
				case BulletEffectBehaviorState.APPEAR:
					if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
						myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
							GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, appearAnimationEndHandler);
					else
						changeToTargetBehaviorState(BulletEffectBehaviorState.RUNNING);
					break;
				
				case BulletEffectBehaviorState.RUNNING:
					onBehaviorChangedToRunning();
				break;
				
				case BulletEffectBehaviorState.DISAPPEAR:
					if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
						myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
							GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, disappearAnimationEndHandler);
					else
						disappearAnimationEndHandler();
					break;
			}
		}
		
		protected function onBehaviorChangedToRunning():void
		{
			if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
			{
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			}
			else if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.IDLE))
			{
				myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE);
			}
			else
				changeToTargetBehaviorState(BulletEffectBehaviorState.DISAPPEAR);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myBulletTrajectory = null;
			myBlletTemplateInfo = null;
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
			if(currentBehaviorState == BulletEffectBehaviorState.RUNNING)
			{
				onRenderWhenRunning();
			}
		}
		
		protected function onRenderWhenRunning():void
		{
			_myCurrentRendTimes++;
			if(_myCurrentRendTimes > _myTotalRendTimes)
			{
				_myCurrentRendTimes = 0;
				onBulletEffectEnd();
			}
			else
			{
				onRenderBulletEffect();
			}
		}
		
		protected function onBulletEffectStart():void
		{
			if(myBulletTrajectory != null)
			{
				this.x = myBulletTrajectory.bulletPositionX;
				this.y = myBulletTrajectory.bulletPositionY;
				
				if(myIsNeedUpdateBulletAngleInRunTime)
				{
					onUpdateBulletAngleByTrajectory(myBulletTrajectory.getRunTimeTrajectoryAngle());
				}
			}
		}

		protected function onRenderBulletEffect():void
		{
			myBulletEffectProgress = _myCurrentRendTimes / _myTotalRendTimes;
			
			if(myBulletTrajectory != null)
			{
				myBulletTrajectory.updateProgress(myBulletEffectProgress);
				
				this.x = myBulletTrajectory.bulletPositionX;
				this.y = myBulletTrajectory.bulletPositionY;
				
				if(myIsNeedUpdateBulletAngleInRunTime)
				{
					onUpdateBulletAngleByTrajectory(myBulletTrajectory.getRunTimeTrajectoryAngle());
				}
			}
		}
		
		protected function onUpdateBulletAngleByTrajectory(angle:Number):void
		{
			this.myBodySkin.rotation = angle;
		}

		protected function onBulletEffectEnd():void
		{
			//子弹可能没有敌人
			if(myTargetEnemy != null)
			{
				//this.x = myTargetEnemy.x;
				//this.y = myTargetEnemy.y;
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
						var tower:BasicTowerElement;
						var enemy:BasicOrganismElement;
						if(GameObjectCategoryType.TOWER == myTargetEnemy.elemeCategory)
							tower = myTargetEnemy as BasicTowerElement;
						else
							enemy = myTargetEnemy as BasicOrganismElement;
						
						createSceneTipEffect(myAttackSceneTipTypeId, myTargetEnemy.x, 
							myTargetEnemy.y - (enemy?enemy.bodyHeight:tower.height));
					}
				}
			}
			
			if(processTransfer())
				return;	
			
			if(myBlletTemplateInfo.specialEffect > 0)
			{
				createBulletExplosion(myBlletTemplateInfo.specialEffect);
			}
			
			if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
			{
				changeToTargetBehaviorState(BulletEffectBehaviorState.DISAPPEAR);
			}
			else
			{
				onReadyToDestorySelfOnBulletEffectEnd();
			}
		}
		/**
		 * 是否处理子弹弹射
		 */
		protected function processTransfer():Boolean
		{
			return false;
		}
		
		//子弹路径结束准备销毁, 可能有些子弹还需要做一些其他事情
		protected function onReadyToDestorySelfOnBulletEffectEnd():void
		{
			destorySelf();
		}

		protected function createBulletExplosion(explosionTypeId:int):void
		{
			var sceneExplosionEffectElement:ExplosionEffect = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.EXPLOSION, explosionTypeId, false) as ExplosionEffect;
			sceneExplosionEffectElement.blowUp(myHurtEffectFirer, (myTargetEnemy!=null && myTargetEnemy.isAlive)?
				new PointVO(myTargetEnemy.x,myTargetEnemy.fightState.isFlyUnit?myTargetEnemy.y/*-(myTargetEnemy as BasicOrganismElement).bodyHeight*/:myTargetEnemy.y)
				:getBulletExplosionPosition(), 
				Math.round(myHurtValue * GameFightConstant.EXPLOSION_HURT_BY_BULLET_PERCENT), 
				myAttackType,40,mySkillState,myTargetEnemy/*, myAttackSceneTipTypeId*/);
			sceneExplosionEffectElement.notifyLifecycleActive();
		}
		
		protected function getBulletExplosionPosition():PointVO
		{
			return new PointVO(this.x, this.y)
		}
		
		private function appearAnimationEndHandler():void
		{
			changeToTargetBehaviorState(BulletEffectBehaviorState.RUNNING);
		}
		
		protected function disappearAnimationEndHandler():void
		{
			destorySelf();
		}
		
		protected function checkIsHurtedTargetEnemy():Boolean
		{
			var tower:BasicTowerElement;
			var enemy:BasicOrganismElement;
			if(GameObjectCategoryType.TOWER == myTargetEnemy.elemeCategory)
				return true;
				//tower = myTargetEnemy as BasicTowerElement;
			//else
				enemy = myTargetEnemy as BasicOrganismElement;
			
			if(enemy && !enemy.isAlive) 
				return false;
			
			var distance:Number = GameMathUtil.distance(myTargetEnemy.x, myTargetEnemy.y - myTargetEnemy.hurtPositionHeight, 
				this.x, this.y);
			
			var hitAllowRange:Number = (enemy?enemy.bodyWidth:tower.width) * 0.5 + myTargetEnemySnapShootSpeed;
			return true/*distance < hitAllowRange*/;
		}
		
		protected function onHurtedTargetEnemy():void
		{
			//myTargetEnemy.hurtBlood(myHurtValue, myAttackType, false, this);
			if(myBlletTemplateInfo.specialEffect <= 0)//如果没有爆炸伤害，则子弹造成伤害，否则子弹不伤害目标
			{
				if(myHurtEffectFirer)
					myHurtEffectFirer.hurtTarget(myTargetEnemy,mySkillState);
				else
					myTargetEnemy.hurtSelf(myHurtValue, myAttackType, null,OrganismDieType.NORMAL_DIE,1,false);
			}
		}

		protected function onUnHurtedTargetEnemy():void
		{
		}
		
		//util
		protected static function createBulletTrajectoryByType(type:int):BasicBulletTrajectory
		{
			var bulletTrajectory:BasicBulletTrajectory = null;
			switch(type)
			{
				case 1://抛物线,弓箭类
				case 2://抛物线，炮弹类	
					bulletTrajectory = new ParabolaBulletTrajectory();
					break;
				
				case 3://直线
				case 6://多段伤害
					bulletTrajectory = new StraightBullectTrajectory();
					break;
				case 7://跟踪弹弹道
					bulletTrajectory = new TrackMissileTrajectory();
					break;
			}
			
			return bulletTrajectory;
		}
		
		protected function addGroundEff(effId:uint,duration:uint,param:Array,owner:ISkillOwner):BasicGroundEffect
		{
			var eff:BasicGroundEffect = objPoolMgr.createSceneElementObject(
				GameObjectCategoryType.GROUNDEFFECT,effId,false) as BasicGroundEffect;
			if(!eff)
				return null;
			eff.x = x;
			eff.y = y;
			eff.setEffectParam(duration,param,owner);
			eff.notifyLifecycleActive();
			return eff;
		}
	}
}