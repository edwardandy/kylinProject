package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	public class ArrowBulletEffect extends BasicBulletEffect
	{
		private var _myStopABulletDispearCDTimer:SimpleCDTimer;
		
		public function ArrowBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_myStopABulletDispearCDTimer = new SimpleCDTimer(GameFightConstant.STOP_A_BULLET_DISPEAR_TIME);
			injector.injectInto(_myStopABulletDispearCDTimer);
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
					var randomRotationIndex:int = int(GameMathUtil.randomFromValues(GameFightConstant.STOP_ARROW_BILLET_ANGLE_INDEXS));
					
					if(myObjectTypeId == 20011)
					{
						myBodySkin.rotation += randomRotationIndex * GameFightConstant.STOP_ARROW_BILLET_ANGLE_GAP;
					}

					myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.STOP_A_BULLET);
					myBodySkin.render(0);//这里只渲染一次
					
					sceneElementsModel.swapSceneElementLayerType(this, 
						GroundSceneElementLayerType.LAYER_BOTTOM);
					
					//地面中弹
					if(myAttackSceneTipTypeId > 0)
					{
						if(GameMathUtil.randomTrueByProbability(GameFightConstant.PLAY_SCENE_TIP_PROBABILITY))
						{
							createSceneTipEffect(myAttackSceneTipTypeId, this.x, this.y);
						}	
					}
					break;
			}
		}
		
		override public function render(iElapse:int):void
		{
			if(currentBehaviorState == BulletEffectBehaviorState.STOP_A_BULLET)
			{
				//_myStopABulletDispearCDTimer.tick();
				if(_myStopABulletDispearCDTimer.getIsCDEnd())
				{
					destorySelf();
				}
			}
			else
			{
				super.render(iElapse);
			}
		}

		override protected function onReadyToDestorySelfOnBulletEffectEnd():void
		{
			if(myBulletHasHurtedTargetEnemy) 
			{
				super.onReadyToDestorySelfOnBulletEffectEnd();
			}
			else
			{
				changeToTargetBehaviorState(BulletEffectBehaviorState.STOP_A_BULLET);
			}
		}
	}
}