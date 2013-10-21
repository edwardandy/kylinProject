package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	

	public class MeetingPointCircleItem extends BasicBuildingCircleItem
	{
		public function MeetingPointCircleItem(clickCallback:Function, buildingCircleMenu:BasicBuildingCircleMenu)
		{
			super(clickCallback, buildingCircleMenu);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myItemBGView.itemTextSkin.visible = false;
			myItemBGView.gotoAndStop("mettingPoint");
		}
		
		/*override protected function onShowToolTipHandler( event:ToolTipEvent ):void
		{
			var data:TowerMenuToolTipDataVO = new TowerMenuToolTipDataVO();
			data.status = TowerMenuToolTip.STATUS_MEET_POINT;
			event.toolTip.data = data;
		}*/
		
		override protected function excuteClickCallback():void
		{
			//ToolTipManager.getInstance().hide();
			super.excuteClickCallback();
		}
	}
}