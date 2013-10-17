package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers.WizardTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	
	import framecore.structure.model.user.soldier.SoldierTemplateInfo;

	public class SummonByTower extends BasicSummonSoldier
	{		
		public function SummonByTower(typeId:int)
		{
			super(typeId);
			this.myElemeCategory = GameObjectCategoryType.SUMMON_BY_TOWER;
			_bNeedRebirthAnim = true;
		}
		
		private function get towerMaster():WizardTowerElement
		{
			return m_master as WizardTowerElement;
		}
		
		override protected function onResurrectionComplete():void
		{
			showBufferLayer(true);
			initStateWhenActive();
			_iRebirthType = 0;
			changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			//towerMaster.notifySoldierIsResurrectionComplete(this);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();	
		}
		
		override protected function initStateWhenActive():void
		{
			//一定要放在前面，否则父类方法会重置状态
			var bRebirth:Boolean = OrganismBehaviorState.RESURRECTION == currentBehaviorState;
			
			super.initStateWhenActive();
			changeToTargetBehaviorState(OrganismBehaviorState.BE_SUMMON);
			myFightState.rebirthTime =  SoldierTemplateInfo(myMoveFighterInfo).rebirthTime;
			myResurrectionCDTimer.setDurationTime(myFightState.rebirthTime);
			if(!bRebirth && myBodySkin.hasFrameName(GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
			{
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START
					,GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,notifyResurrectionCompleteToMaster);
			}
			else
				notifyResurrectionCompleteToMaster();
			
		}
		
		public function notifyResurrectionCompleteToMaster():void
		{
			towerMaster.notifySoldierIsResurrectionComplete(this);
		}
		
		override protected function checkHasAbilityToResurrection():Boolean
		{
			return true;
		}
	}
}