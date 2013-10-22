package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.identify.ExplosionID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.ExplosionEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	/**
	 * 地精地雷
	 */
	public class GoblinBombMagicSkill extends BasicMagicSkillEffect
	{
		private var _bBombHasSet:Boolean = false;
				
		public function GoblinBombMagicSkill(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
			
		}
		
		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.APPEAR:
					{				
						if(_bBombHasSet)
							ScanContactEnemy();
					}
					break;
				case MagicSkillEffectBehaviorState.RUNNING:
					//myMagicSkillCDTimer.tick();
					if(myMagicSkillCDTimer.getIsCDEnd())
					{
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
					}
					break;
			}
			
			super.render(iElapse);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.APPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
						myBodySkinAppearAnimationEndHandler);
					break;
				
				case MagicSkillEffectBehaviorState.RUNNING:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					break;
				
				case MagicSkillEffectBehaviorState.DISAPPEAR:
					Explode();
					destorySelf();
					break;
			}
		}
		
		private function ScanContactEnemy():void
		{
			var targets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			if(!targets || targets.length <= 0)
				return;
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
		}
		
		private function Explode():void
		{
			var explodeId:int = ExplosionID.GoblinBomb2;
			switch(myMagicLevel)
			{
				case 1:
					explodeId = ExplosionID.GoblinBomb;
					break;
				case 2:
					explodeId = ExplosionID.GoblinBomb2;
					break;
				case 3:
					explodeId = ExplosionID.GoblinBomb3;
					break;
				case 4:
					explodeId = ExplosionID.GoblinBomb4;
					break;
			}
			var sceneExplosionEffectElement:ExplosionEffect = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.EXPLOSION, explodeId, false) as ExplosionEffect;
			const arrDmg:Array = (myMagicSkillTemplateInfo.objEffect[SkillResultTyps.DMG] as String).split("-");
			myMagicHurtValue = GameMathUtil.randomUintBetween(arrDmg[0], arrDmg[1]);
			sceneExplosionEffectElement.blowUp(null, getBulletExplosionPosition(), 
				myMagicHurtValue, myMagicSkillTemplateInfo.atkType,
				myMagicSkillTemplateInfo.range);
			sceneExplosionEffectElement.notifyLifecycleActive();
		}
		
		private function getBulletExplosionPosition():PointVO
		{
			return new PointVO(this.x, this.y)
		}
		
		private function myBodySkinAppearAnimationEndHandler():void
		{
			_bBombHasSet = true;
		}
		
		override protected function get myMagicLevel():int
		{
			return _myMagicLevel;
		}
	}
}