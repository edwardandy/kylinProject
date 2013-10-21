package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters
{
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;

	/**
	 * 骷髅有被召唤动画
	 */
	public class Skeletons extends BasicMonsterElement
	{
		private var _bHasBorn:Boolean = false;
		
		public function Skeletons(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_bHasBorn = false;
		}
		
		override public function render(iElapse:int):void
		{
			if(!_bHasBorn && myMoveState.myIsWalking)
			{
				_bHasBorn = true;
				changeToTargetBehaviorState(OrganismBehaviorState.BORN);
			}
			super.render(iElapse);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			if(OrganismBehaviorState.BORN == currentBehaviorState)
			{
				myMoveLogic.pauseWalk(myMoveState);
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.SUMMON+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.SUMMON+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onSummonEnd);
				return;
			}
			super.onBehaviorStateChanged();
		}
		
		private function onSummonEnd():void
		{
			changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
		}
	}
}