package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.WitchRayEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	/**
	 * 女巫塔，子弹是射线
	 */
	public class WitchTowerElement extends WizardTowerElement
	{
		private var _witchRay:WitchRayEffect;
		
		public function WitchTowerElement(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			clearRay();
		}
		
		override protected function playAttackAnim():void
		{
			myTowerSoldierSkin.gotoAndPlay2(GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			fireRay();
		}
		
		private function fireRay():void
		{
			clearRay();
			
			_witchRay = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.BULLET,myTowerInfo.towerTemplateInfo.weapon,false) as WitchRayEffect;
			_witchRay.fire(mySearchedEnemy,this,getGlobalFirePoint(), getDmgBeforeHurtTarget(false,mySearchedEnemy));
			_witchRay.notifyLifecycleActive();
		}
			
		public function notifyRayDisappear():void
		{
			clearRay();
			changeToTargetBehaviorState(TowerBehaviorState.IDEL);
		}
		
		public function checkCanAttack():Boolean
		{
			return !myFightState.bStun && mySearchedEnemy;
		}
		
		private function clearRay():void
		{
			if(_witchRay)
				_witchRay.destorySelf();
			_witchRay = null;
		}
	}
}