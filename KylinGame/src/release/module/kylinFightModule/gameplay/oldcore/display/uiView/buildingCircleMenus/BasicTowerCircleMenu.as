package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	public class BasicTowerCircleMenu extends BasicBuildingCircleMenu
	{
		[Inject]
		public var mouseCursorMgr:GameFightMouseCursorManager;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		
		protected var myTowerTemplateInfo:ITowerSheetItem;
		protected var mySellCircleItem:SellCircleItem;
		
		public function BasicTowerCircleMenu(buildingElement:BasicBuildingElement, 
											 towerTemplateInfo:ITowerSheetItem)
		{
			super(buildingElement);

			myTowerTemplateInfo = towerTemplateInfo;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			mySellCircleItem = new SellCircleItem(onCircleMenuItemSellClick, this);
			mySellCircleItem.x = 47;
			mySellCircleItem.y = 30;
			addChild(mySellCircleItem);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			disposeCircleItem(mySellCircleItem);
			mySellCircleItem = null;
		}
		
		protected function disposeCircleItem(circleItem:BasicBuildingCircleItem):void
		{
			removeChild(circleItem);
			circleItem.dispose();
		}
	}
}