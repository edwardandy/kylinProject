package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	public class MagicFlySwordBulletEffect extends BasicBulletEffect
	{
		private var _myStopABulletDispearCDTimer:SimpleCDTimer;
		
		public function MagicFlySwordBulletEffect(typeId:int)
		{
			super(typeId);
			
			myHasAppearAnimation = true;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_myStopABulletDispearCDTimer = new SimpleCDTimer(GameFightConstant.STOP_A_BULLET_DISPEAR_TIME);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			_myStopABulletDispearCDTimer.resetCDTime();
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
		
			switch(currentBehaviorState)
			{
				case BulletEffectBehaviorState.STOP_A_BULLET:
					
					myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.STOP_A_BULLET);
					myBodySkin.render();
					
					GameAGlobalManager.getInstance().groundScene.swapSceneElementLayerType(this, 
						GroundSceneElementLayerType.LAYER_BOTTOM);
					break;
			}
		}
		
		override public function render():void
		{
			if(currentBehaviorState == BulletEffectBehaviorState.STOP_A_BULLET)
			{
				_myStopABulletDispearCDTimer.tick();
				if(_myStopABulletDispearCDTimer.getIsCDEnd())
				{
					destorySelf();
				}
			}
			else
			{
				super.render();
			}
		}
		
		override protected function onReadyToDestorySelfOnBulletEffectEnd():void
		{
			changeToTargetBehaviorState(BulletEffectBehaviorState.STOP_A_BULLET);
		}
		
		//都是打到
		override protected function checkIsHurtedTargetEnemy():Boolean
		{
			return true;
		}
	}
}