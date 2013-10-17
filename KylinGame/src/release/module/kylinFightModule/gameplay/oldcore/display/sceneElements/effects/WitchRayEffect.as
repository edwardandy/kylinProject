package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillResultTyps;
	import com.shinezone.towerDefense.fight.constants.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers.WitchTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BulletEffectBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import framecore.structure.model.constdata.AttributeConst;
	
	public class WitchRayEffect extends BasicBulletEffect
	{
		private var _hurtScalePerFrame:Number;
		private var _firePoint:PointVO;
		private var _atkDurationCd:SimpleCDTimer = new SimpleCDTimer;
		
		public function WitchRayEffect(typeId:int)
		{
			super(typeId);
		}
		
		override public function fire(targetEnemy:ISkillTarget, 
							 bulletFirer:ISkillOwner, 
							 firePoint:PointVO,
							 hurtValue:uint,
							 trajectoryParameters:Object = null,
							 emphasizeBulletFallPointPoint:PointVO = null,skillState:SkillState = null):void
		{
			myTargetEnemy = targetEnemy;
			myHurtEffectFirer = bulletFirer;
			if(myTargetEnemy)
			{
				var param:Object = {};
				param[BufferFields.BUFF] = BufferID.HitByWitchTower;
				param[BufferFields.DURATION] = 0;
				param[SkillResultTyps.SPECIAL_PROCESS] = 1;
				myTargetEnemy.notifyAttachBuffer(BufferID.HitByWitchTower,param,myHurtEffectFirer);
			}
			myHurtValue = hurtValue;
			_firePoint = firePoint;
			this.x = _firePoint.x + 4;
			this.y = _firePoint.y + 5;
			
			_atkDurationCd.setDurationTime(myDuration);
		}
		
		override protected function onInit():void
		{
			this.scaleX = 1;
			this.rotation = 0;
			//每帧伤害
			_hurtScalePerFrame = 1.0*1000/myDuration/GameFightConstant.GAME_PER_FRAME_TIME;
			changeToTargetBehaviorState(BulletEffectBehaviorState.RUNNING);
		}
		
		override protected function onBehaviorChangedToRunning():void
		{
			super.onBehaviorChangedToRunning();
			_atkDurationCd.resetCDTime();
		}
		
		override public function destorySelf():void
		{
			if(myTargetEnemy && myTargetEnemy.isAlive && !myTargetEnemy.isFreezedState() && myTargetEnemy.hasBuffer(BufferID.HitByWitchTower))
				myTargetEnemy.notifyDettachBuffer(BufferID.HitByWitchTower);
			super.destorySelf();
		}
		
		override public function render(iElapse:int):void
		{
			if(currentBehaviorState == BulletEffectBehaviorState.RUNNING)
			{
				onRenderWhenRunning();
			}
			/*else
				super.render();*/
		}
		
		override protected function onRenderWhenRunning():void
		{
			if(_atkDurationCd.getIsCDEnd() || !(myHurtEffectFirer as WitchTowerElement).checkCanAttack())
			{
				(myHurtEffectFirer as WitchTowerElement).notifyRayDisappear();
				return;
			}
			myBodySkin.rotation = 0;
			myBodySkin.scaleX = 1.0;
			
			var distance:Number = GameMathUtil.distance( this.x, this.y, myTargetEnemy.x, myTargetEnemy.y - myTargetEnemy.hurtPositionHeight);
			
			myBodySkin.scaleX = distance / (this.width == 0?myBodySkin.iFirstFrameWidth:this.width);
			//myBodySkin.width = distance;
			
			myBodySkin.rotation = GameMathUtil.radianToDegree(
				/*GameMathUtil.adjustRadianBetween0And2PI(*/
					GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, myTargetEnemy.x, myTargetEnemy.y - myTargetEnemy.hurtPositionHeight))/*)*/;
			myBodySkin.render(0);
			myTargetEnemy.hurtSelf(myHurtValue,FightAttackType.MAGIC_ATTACK_TYPE,myHurtEffectFirer,0,_hurtScalePerFrame,null == mySkillState);
		}
		
	}
}