package mainModule.controller.gameInitSteps
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.display.DisplayObjectUtils;
	
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.panelData.PanelNameConst;
	import mainModule.model.panelData.ViewLayersModel;
		
	public class GameInitSetViewLayersCmd extends KylinCommand
	{
		[Inject]
		public var viewLayers:ViewLayersModel;
		[Inject]
		public var stage:Stage;
		
		public function GameInitSetViewLayersCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			initLayers();
			
			dispatch(new UIPanelEvent(UIPanelEvent.UI_OpenPanel,PanelNameConst.LoadPanel));
		}
		
		private function initLayers():void
		{
			viewLayers.panelLayer = new Sprite;
			viewLayers.panelLayer.mouseEnabled = false;
			contextView.addChild(viewLayers.panelLayer);
			
			viewLayers.popUpLayer = new Sprite;
			viewLayers.popUpLayer.visible = false;
			contextView.addChild(viewLayers.popUpLayer);
			
			viewLayers.tipsLayer = new Sprite;
			viewLayers.tipsLayer.mouseEnabled = false;
			viewLayers.tipsLayer.mouseChildren = false;
			contextView.addChild(viewLayers.tipsLayer);
			
			viewLayers.waitPanelAppearLayer = new Sprite;
			viewLayers.waitPanelAppearLayer.mouseChildren = false;
			viewLayers.waitPanelAppearLayer.visible = false;
			contextView.addChild(viewLayers.waitPanelAppearLayer);
			DisplayObjectUtils.instance.fillRectSprite(viewLayers.waitPanelAppearLayer,stage.stageWidth,stage.stageHeight,0,0);
		}
			
	}
}