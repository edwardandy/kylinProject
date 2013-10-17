package com.shinezone.towerDefense.fight.display.sceneElements.effects.dieEffect
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import com.shinezone.towerDefense.fight.display.sceneElements.basics.BasicBodySkinSceneElement;
	import com.shinezone.towerDefense.fight.display.sceneElements.effects.SkillEffect.SkillEffectBehaviorState;
	import com.shinezone.towerDefense.fight.utils.SimpleCDTrelease.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimerBodySkinSceneElement
	{
		private var _endCallBack:Function;
		private var _dieStayCd:SimpleCDTimer = new SimpleCDTimer(2000);
		
		public function BasicDieEffect(typeId:int)
		{
			super();
			myElemeCategory = GameObjectCategoryType.DIEEFFECT;
			myObjectTypeId = typeId;
			myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
		}
		
		public function setDieEffectParam(callback:Function):void
		{
			_endCallBack = callback;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();		
			changeToTargetBehaviorState(SkillEffectBehaviorState.APPEAR);			
		}
		
		override protected function onBehaviorStateChanged():void
		{
			if(SkillEffectBehaviorState.APPEAR == currentBehaviorState)
			{
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onEffEnd);	
			}
			else if(SkillEffectBehaviorState.DISAPPEAR == currentBehaviorState)
			{
				_dieStayCd.resetCDTime();
			}
		}
		
		private function onEffEnd():void
		{
			changeToTargetBehaviorState(SkillEffectBehaviorState.DISAPPEAR);		
		}
		
		override public function render(iElapse:int):void
		{
			if(SkillEffectBehaviorState.DISAPPEAR == currentBehaviorState && _dieStayCd.getIsCDEnd())
			{
				if(_endCallBack != null)
					_endCallBack();
				_endCallBack = null;
				
				destorySelf();
			}
			super.render(iElapse);
		}
	}
}