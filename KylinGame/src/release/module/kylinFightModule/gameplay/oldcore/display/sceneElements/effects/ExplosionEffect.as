package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects
{
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.utili.structure.PointVO;

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
			var monsters:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 50, camp); 
			
			for each(var monster:BasicOrganismElement in monsters)
			{
				if(myHurtEffectFirer && myHurtEffectFirer.isAlive && !myHurtEffectFirer.isFreezedState())
					myHurtEffectFirer.hurtTarget(monster,mySkillState);
				else
				    monster.hurtBlood(myHurtValue, FightAttackType.PHYSICAL_ATTACK_TYPE, false);
			}
			
			createSceneTipEffect(SceneTipEffect.SCENE_TIPE_BOOM, this.x, this.y);
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