package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	//滚油
	public class GunTangDeYouBulletEffect extends BasicBulletEffect
	{
		private var _stayCDTimer:SimpleCDTimer;
		
		public function GunTangDeYouBulletEffect(typeId:int)
		{
			super(typeId);

			myHasDisappearAnimation = true;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_stayCDTimer = new SimpleCDTimer(3000);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			switch(currentBehaviorState)
			{
				case BulletEffectBehaviorState.STOP_A_BULLET:
					_stayCDTimer.resetCDTime();
					break;
				
				case BulletEffectBehaviorState.DISAPPEAR:
					GameAGlobalManager.getInstance().groundScene.swapSceneElementLayerType(this, 
						GroundSceneElementLayerType.LAYER_BOTTOM);
					break;
			}
		}
		
		override public function render():void
		{
			if(currentBehaviorState == BulletEffectBehaviorState.STOP_A_BULLET)
			{
				_stayCDTimer.tick();
				if(_stayCDTimer.getIsCDEnd())
				{
					destorySelf();
				}
				else
				{
					onHurtEmemyWhenPerRender();
				}
			}
			else
			{
				super.render();	
			}
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			
			myBodySkin.gotoAndStop2(1);
		}
		
		override protected function onUpdateBulletAngleByTrajectory(angle:Number):void
		{
		}
		
		override protected function disappearAnimationEndHandler():void
		{
			changeToTargetBehaviorState(BulletEffectBehaviorState.STOP_A_BULLET);
		}
		
		//滚烫的油造成伤害 ？
		private function onHurtEmemyWhenPerRender():void
		{
		}
	}
}