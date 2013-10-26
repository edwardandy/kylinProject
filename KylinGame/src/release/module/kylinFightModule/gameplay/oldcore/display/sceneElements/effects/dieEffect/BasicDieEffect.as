package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.dieEffect
{
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SkillEffectBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	
	public class BasicDieEffect extends BasicBodySkinSceneElement
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
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			injector.injectInto(_dieStayCd);
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