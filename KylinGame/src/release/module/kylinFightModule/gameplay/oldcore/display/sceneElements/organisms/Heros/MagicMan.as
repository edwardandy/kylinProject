package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseFighterSheetItem;
	import mainModule.model.gameData.sheetData.skill.IBaseOwnerSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.identify.BulletID;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.ArcaneBombBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;

	/**
	 * 秀逗魔导士 
	 * 
	 */	
	public class MagicMan extends HeroElement
	{
		public function MagicMan(typeId:int)
		{
			super(typeId);
		}
		
		override protected function checkRandomIdelAnim():void
		{
			
		}
		
		override protected function onBehaviorChangeToIdle():void
		{
			myBodySkin.gotoAndPlay2(getIdleTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				getIdleTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
		}
		
		override protected function appearSkillEffect():void
		{
			if(SkillID.ArcaneBomb == myFightState.curUseSkillId || SkillID.ArcaneBombAdv == myFightState.curUseSkillId)
			{
				var skillId:uint = myFightState.curUseSkillId;
				var state:SkillState = mySkillStates.get(skillId) as SkillState;
				var buffTemp:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
				if(!buffTemp)
					return;
				var i:int=0;
				for(;i<5;++i)
				{
					var bulletEffect:ArcaneBombBulletEffect = objPoolMgr
						.createSceneElementObject(GameObjectCategoryType.BULLET, BulletID.ArcaneBombBullet, false) as ArcaneBombBulletEffect;
					bulletEffect.setOrder(i);
					bulletEffect.fire(state.mainTarget,this,getGlobalFirePoint(),0,100,null,state);
					bulletEffect.notifyLifecycleActive();
				}
				return;
			}
			super.appearSkillEffect();
		}
	}
}