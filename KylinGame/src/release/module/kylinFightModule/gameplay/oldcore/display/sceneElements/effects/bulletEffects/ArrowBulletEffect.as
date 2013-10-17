package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ParabolaBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;

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
					
					GameAGlobalManager.getInstance().groundScene.swapSceneElementLayerType(this, 
						GroundSceneElementLayerType.LAYER_BOTTOM);
					
					//地面中弹
					if(myAttackSceneTipTypeId > 0)
					{
						if(GameMathUtil.randomTrueByProbability(GameFightConstant.PLAY_SCENE_TIP_PROBABILITY))
						{
							SceneTipEffect.playSceneTipEffect(myAttackSceneTipTypeId, this.x, this.y);
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