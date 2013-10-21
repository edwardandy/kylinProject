package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers
{
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.WitchRayEffect;

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
			
			_witchRay = objPoolMgr.createSceneElementObject(GameObjectCategoryType.BULLET
				,myTowerTemplateInfo.weapon,false) as WitchRayEffect;
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