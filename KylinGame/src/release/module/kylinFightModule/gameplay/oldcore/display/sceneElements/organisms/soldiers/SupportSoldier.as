package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.SubjectCategory;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	/**
	 * 援兵
	 */
	public class SupportSoldier extends CondottiereSoldier
	{
		private var _lifeCd:SimpleCDTimer = new SimpleCDTimer();
		protected var myShareCenterPt:PointVO = new PointVO;
		
		public function SupportSoldier(typeId:int)
		{
			super(typeId);
			this.myElemeCategory = GameObjectCategoryType.SUPPORT_SOLDIER;
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return GameObjectCategoryType.SOLDIER+"_"+ (soldierTempInfo.resId || myObjectTypeId);
		}
		
		override public function render(iElapse:int):void
		{
			if(_lifeCd && _lifeCd.getIsCDEnd())
			{
				destorySelf();				
				return;
			}
			super.render(iElapse);
		}
		
		public function set lifeDuration(dur:int):void
		{
			if(dur>0)
			{
				_lifeCd.setDurationTime(dur);
				_lifeCd.resetCDTime();
			}
		}
		
		override public function get subjectCategory():int
		{
			return SubjectCategory.SOLDIER;
		}
		
		override protected function get searchCenterX():Number
		{
			return myShareCenterPt.x;
		}
		
		override protected function get searchCenterY():Number
		{
			return myShareCenterPt.y;
		}
		
		public function setShareSearchCenter(ptCenter:PointVO):void
		{
			myShareCenterPt.x = ptCenter.x;
			myShareCenterPt.y = ptCenter.y;
		}
	}
}