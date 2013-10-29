package mainModule.view.loadPanel
{
	import flash.events.ProgressEvent;
	
	import kylin.echo.edward.framwork.view.KylinPanelMediater;
	
	import mainModule.controller.gameInitSteps.GameInitStepEvent;
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.panelData.PanelNameConst;
	
	public class LoadPanelMediater extends KylinPanelMediater
	{
		[Inject]
		public var _loadPanel:LoadPanel;
		
		public function LoadPanelMediater()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			addViewListener(UIPanelEvent.UI_PanelOpened,onLoadPanelOpened,UIPanelEvent);
			addContextListener(ProgressEvent.PROGRESS,onLoadProgress,ProgressEvent);
			_loadPanel.ctrlBtnFight.addActionEventListener(onClickFight);
		}
		
		override public function destroy():void
		{
			_loadPanel.ctrlBtnFight.removeActionEventListener();
			super.destroy();
		}
		
		private function onLoadPanelOpened(e:UIPanelEvent):void
		{
			dispatch(e);
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitPreLoadRes));
		}
		
		private function onLoadProgress(e:ProgressEvent):void
		{
			//_loadPanel.txtMsg.text = "My Test Info.";
			_loadPanel.txtProgress.text = "Loading..." + int(e.bytesLoaded*100).toString() + "%";
		}
		
		private function onClickFight():void
		{
			dispatch(new UIPanelEvent(UIPanelEvent.UI_ClosePanel,PanelNameConst.LoadPanel));
			dispatch(new UIPanelEvent(UIPanelEvent.UI_OpenPanel,PanelNameConst.KylinFightModule));
		}
	}
}