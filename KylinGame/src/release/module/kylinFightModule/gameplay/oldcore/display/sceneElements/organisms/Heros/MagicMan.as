package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.identify.BulletID;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.ArcaneBombBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	
	import framecore.structure.model.user.base.BaseSkillInfo;

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
				var buffTemp:BaseSkillInfo = getBaseSkillInfo(skillId);
				if(!buffTemp)
					return;
				var i:int=0;
				for(;i<5;++i)
				{
					var bulletEffect:ArcaneBombBulletEffect = ObjectPoolManager.getInstance()
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