package mainModule.view.loadPanel
{
	import flash.events.ProgressEvent;
	
	import kylin.echo.edward.framwork.view.KylinPanelMediater;
	
	import mainModule.controller.gameInitSteps.GameInitStepEvent;
	import mainModule.controller.uiCmds.UIPanelEvent;
	
	public class LoadPanelMediater extends KylinPanelMediater
	{
		[Inject]
		public var _loadPanel:LoadPanel;
		
		public function LoadPanelMediater()
		{
			super();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			addViewListener(UIPanelEvent.UI_PanelOpened,onLoadPanelOpened,UIPanelEvent);
			addContextListener(ProgressEvent.PROGRESS,onLoadProgress,ProgressEvent);
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
	}
}