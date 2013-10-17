package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	
	import framecore.tools.tips.ToolTipConst;
	import framecore.tools.tips.ToolTipEvent;
	import framecore.tools.tips.ToolTipManager;
	import framecore.tools.tips.towerMenu.TowerMenuToolTip;
	import framecore.tools.tips.towerMenu.TowerMenuToolTipDataVO;
	import framecore.tools.tips.towerMenu.TowerPropItem;

	public class SellCircleItem extends BasicBuildingCircleItem
	{
		public function SellCircleItem(clickCallback:Function, buildingCircleMenu:BasicBuildingCircleMenu)
		{
			super(clickCallback, buildingCircleMenu);
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myItemBGView.itemTextSkin.visible = false;
			myItemBGView.gotoAndStop("sell");
		}
		
		override protected function onShowToolTipHandler( event:ToolTipEvent ):void
		{
			var data:TowerMenuToolTipDataVO = new TowerMenuToolTipDataVO();
			data.status = TowerMenuToolTip.STATUS_SELL;
			data.towerName = "Sell and receive";
			var towerMenu:BasicTowerCircleMenu = myBuildingCircleItemOwner as BasicTowerCircleMenu;
			var towerElement:BasicTowerElement = towerMenu.buildingElement as BasicTowerElement;
//			data.props[TowerPropItem.PROP_BOX] = towerElement.myTowerCostGold >> 1;
			data.props.push( TowerPropItem.PROP_BOX, (towerElement.myTowerCostGold >> 1) + "" );
			event.toolTip.data = data;
		}
	}
}