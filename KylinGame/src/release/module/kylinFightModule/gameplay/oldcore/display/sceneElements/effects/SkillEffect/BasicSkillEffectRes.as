package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	public class BasicSkillEffectRes extends BasicBodySkinSceneElement
	{
		protected var mySkillState:SkillState;
		protected var mySkillOwner:ISkillOwner;
		protected var myFirePoint:PointVO = new PointVO();
		
		public function BasicSkillEffectRes(typeId:int)
		{
			super();
			
			myElemeCategory = GameObjectCategoryType.SKILLRES;
			myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_TOP;
			myObjectTypeId = typeId;
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return GameObjectCategoryType.SPECIAL + "_" + myObjectTypeId;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			beginToShow();
		}
		
		protected function beginToShow():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				onSkillEffEndHandler, 
				GameMovieClipFrameNameType.FIRE_POINT, onSkillEffFireTimeHandler);
		}
			
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			switch(currentBehaviorState)
			{
				case SkillEffectBehaviorState.DISAPPEAR:
					onBehaviorStateChangedToDisappear();
					break;
			}
		}
		
		protected function onBehaviorStateChangedToDisappear():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, destorySelf);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			mySkillState = null;
			mySkillOwner = null;
		}
		
		protected function onSkillEffFireTimeHandler():void
		{
			if(mySkillOwner && mySkillState)
				mySkillOwner.processSkillState(mySkillState);
		}
		
		protected function onSkillEffEndHandler():void
		{
			destorySelf();
		}
		
		public function activeSkillEffect(owner:ISkillOwner, state:SkillState):void
		{
			mySkillOwner = owner;
			mySkillState = state;
			if(state && state.mainTarget)
			{
				if(state.mainTarget)
				{
					myFirePoint.x = this.x = state.mainTarget.x;
					myFirePoint.y = this.y = state.mainTarget.y;	
				}
				else 
				{
					myFirePoint.x = this.x = state.vecTargets[0].x;
					myFirePoint.y = this.y = state.vecTargets[0].y;	
				}
			}
			else if(mySkillOwner)
			{
				myFirePoint.x = this.x = mySkillOwner.x;
				myFirePoint.y = this.y = mySkillOwner.y;	
			}
		}
	}
}