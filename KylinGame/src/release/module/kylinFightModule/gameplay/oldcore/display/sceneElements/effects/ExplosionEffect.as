package com.shinezone.towerDefense.fight.display1.sceneElements.effects
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import com.shinezone.towerDefense.fight.display.sceneElements.basics.BasicBodySkinSceneElement;
	import com.shinezone.towerDefense.fight.display.sceneElements.organisms.BasicOrganismElement;
	import com.shinezone.towerDefense.fight.display.sceneElements.organisms.IOrganismSkiller;
	import com.shinezone.towerDefense.fight.logic.skill.SkillState;
	imporelease.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillStatece.ISkillOwrelease.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwnerce.ISkillTarelease.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTargets.GameAGlobalManager;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	/**
	 * 爆炸效果 
	 * @author Administrator
	 * 
	 */	
	public class ExplosionEffect extends BasicBodySkinSceneElement
	{
		protected var myFirePoint:PointVO = new PointVO();
		protected var myHurtValue:uint;
		protected var myAttackType:int;
		protected var mySkillState:SkillState;
		protected var myHurtEffectFirer:ISkillOwner;
		protected var myTarget:ISkillTarget;
		
		public function ExplosionEffect(typeId:int)
		{
			super();
			
			myElemeCategory = GameObjectCategoryType.EXPLOSION;
			myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_TOP;
			myObjectTypeId = typeId;
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return GameObjectCategoryType.SPECIAL + "_" + myObjectTypeId;
		}
		
		public function blowUp(explosionFirer:ISkillOwner, 
							   firePoint:PointVO, 
							   hurtValue:uint,
							   attackType:uint,
							   attackArea:int,
							  state:SkillState = null,target:ISkillTarget = null):void
		{
			myTarget = target;
			myHurtEffectFirer = explosionFirer;
			mySkillState = state;
			myFirePoint.x = this.x = firePoint.x;
			myFirePoint.y = this.y = firePoint.y;
			
			myHurtValue = hurtValue;
			myAttackType = attackType;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			onStartEffect();
		}
		
		protected function onStartEffect():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				onExplosionEndHandler, 
				GameMovieClipFrameNameType.FIRE_POINT, onExplosionFireTimeHandler);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			mySkillState = null;
			myHurtEffectFirer = null;
		}
		
		private function onExplosionFireTimeHandler():void
		{
			if(mySkillState && myHurtEffectFirer)
			{
				if((SkillID.ExplosionFireBomb == mySkillState.id || SkillID.ExplosionFireBomb1 == mySkillState.id || SkillID.ExplosionFireBomb2 == mySkillState.id) 
					&& mySkillState.mainTarget)
				{
					mySkillState.mainTarget.lastExplosionPoint.x = this.x;
					mySkillState.mainTarget.lastExplosionPoint.y = this.y;
				}
				myHurtEffectFirer.processSkillState(mySkillState);
				return;
			}
			var camp:int = myTarget!=null?myTarget.campType:FightElementCampType.ENEMY_CAMP;
			var monsters:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 50, camp); 
			
			for each(var monster:BasicOrganismElement in monsters)
			{
				if(myHurtEffectFirer && myHurtEffectFirer.isAlive && !myHurtEffectFirer.isFreezedState())
					myHurtEffectFirer.hurtTarget(monster,mySkillState);
				else
				    monster.hurtBlood(myHurtValue, FightAttackType.PHYSICAL_ATTACK_TYPE, false);
			}
			
			SceneTipEffect.playSceneTipEffect(SceneTipEffect.SCENE_TIPE_BOOM, this.x, this.y);
		}
		
		private function onExplosionEndHandler():void
		{
			destorySelf();
		}
		
		protected function necessarySearchConditionFilter(target:BasicOrganismElement):Boolean
		{
			if(myHurtEffectFirer && myHurtEffectFirer is BasicOrganismElement && (myHurtEffectFirer as BasicOrganismElement).isFarAttackable)
				return true;
			return !target.fightState.isFlyUnit;
		}
	}
}