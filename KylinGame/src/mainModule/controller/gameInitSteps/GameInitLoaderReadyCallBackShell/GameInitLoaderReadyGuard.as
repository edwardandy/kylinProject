package mainModule.controller.gameInitSteps.GameInitLoaderReadyCallBackShell
{
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.panelData.PanelNameConst;
	
	public class GameInitLoaderReadyGuard
	{
		[Inject]
		public var uiEvt:UIPanelEvent;
		
		public function GameInitLoaderReadyGuard()
		{
		}
		
		public function approve():Boolean
		{
			if(PanelNameConst.LoadPanel == uiEvt.panelId)
				return true;
			return false;
		}
	}
}