package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	public class SummonByOrganisms extends BasicSummonSoldier
	{
		public function SummonByOrganisms(typeId:int)
		{
			super(typeId);
			this.myElemeCategory = GameObjectCategoryType.SUMMON_BY_ORGANISM;
			_bNeedRebirthAnim = true;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			changeToTargetBehaviorState(OrganismBehaviorState.BE_SUMMON);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			if(currentBehaviorState == OrganismBehaviorState.BE_SUMMON)
			{
				if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.SUMMON+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
				{
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.SUMMON+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						GameMovieClipFrameNameType.SUMMON+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onIdle);
				}
				else
					onIdle();
			}
		}
		
		private function onIdle():void
		{
			changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
		}
		
		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.IDLE:
					//var distance:Number = GameMathUtil.distance(this.x, this.y, m_master.x, m_master.y);
					if(!GameMathUtil.containsPointInEllipseSearchArea(m_master.x, m_master.y,GameFightConstant.NEAR_MASTER_DISTANCE,x, y) 
						/*distance >  GameFightConstant.NEAR_MASTER_DISTANCE*/ && !mySearchedEnemy)
						moveToMasterNearby();
					break;
			}
			super.render(iElapse);
		}
		
		public function get myMaster():BasicOrganismElement
		{
			return m_master as BasicOrganismElement;
		}
		
		private function moveToMasterNearby():void
		{
			myAppointPoint = myMaster.getAttackablePositionByTargetEnemy(this);
			backToCurrentAppointPoint();
		}
		
		public function notifyMasterMoved():void
		{
			if(OrganismBehaviorState.MOVE_TO_APPOINTED_POINT != currentBehaviorState || mySearchedEnemy)
				return;
			if(!GameMathUtil.containsPointInEllipseSearchArea(myMaster.appointPoint.x, myMaster.appointPoint.y,GameFightConstant.NEAR_MASTER_DISTANCE
				,myAppointPoint.x, myAppointPoint.y))
			{
				myAppointPoint = myMaster.getAttackablePositionByTargetEnemy(this,myMaster.appointPoint);
				backToCurrentAppointPoint();
			}
		}	
	}
}