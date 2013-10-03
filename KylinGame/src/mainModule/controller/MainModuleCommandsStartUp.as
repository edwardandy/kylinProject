package mainModule.controller
{
	import mainModule.controller.gameInitSteps.GameInitLoadFontsCmd;
	import mainModule.controller.gameInitSteps.GameInitLoadGameCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitLoadPreloadCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitLoadResCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitLoaderReadyCallBackShell.GameInitLoaderReadyCallBackShellCmd;
	import mainModule.controller.gameInitSteps.GameInitPreLoadResCmd;
	import mainModule.controller.gameInitSteps.GameInitSetViewLayersCmd;
	import mainModule.controller.gameInitSteps.GameInitSetupGameCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitStepEvent;
	import mainModule.controller.netCmds.httpCmds.HttpEvent;
	import mainModule.controller.netCmds.httpCmds.cmds.HttpGameInitCmd;
	import mainModule.controller.uiCmds.UIClosePanelCmd;
	import mainModule.controller.uiCmds.UIOpenPanelCmd;
	import mainModule.controller.uiCmds.UIPanelEvent;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
		

	public class MainModuleCommandsStartUp
	{
		public function MainModuleCommandsStartUp(cmdMap:IEventCommandMap)
		{
			cmdMap.map(GameInitStepEvent.GameInitLoadResCfg,GameInitStepEvent).toCommand(GameInitLoadResCfgCmd).once();
			cmdMap.map(GameInitStepEvent.GameInitLoadGameCfg,GameInitStepEvent).toCommand(GameInitLoadGameCfgCmd).once();
			cmdMap.map(GameInitStepEvent.GameInitSetupGameCfg,GameInitStepEvent).toCommand(GameInitSetupGameCfgCmd).once();
			cmdMap.map(GameInitStepEvent.GameInitLoadPreloadCfg,GameInitStepEvent).toCommand(GameInitLoadPreloadCfgCmd).once();
			cmdMap.map(GameInitStepEvent.GameInitLoadFonts,GameInitStepEvent).toCommand(GameInitLoadFontsCmd).once();
			cmdMap.map(GameInitStepEvent.GameInitSetViewLayers,GameInitStepEvent).toCommand(GameInitSetViewLayersCmd).once();
			cmdMap.map(GameInitStepEvent.GameInitPreLoadRes,GameInitStepEvent).toCommand(GameInitPreLoadResCmd).once();
			
			cmdMap.map(UIPanelEvent.UI_OpenPanel,UIPanelEvent).toCommand(UIOpenPanelCmd);
			cmdMap.map(UIPanelEvent.UI_OpenPanel,UIPanelEvent).toCommand(GameInitLoaderReadyCallBackShellCmd)
				.withGuards().once();
			cmdMap.map(UIPanelEvent.UI_ClosePanel,UIPanelEvent).toCommand(UIClosePanelCmd);
	
			mapHttpCmds(cmdMap);
		}
		
		private function mapHttpCmds(cmdMap:IEventCommandMap):void
		{
			cmdMap.map(HttpEvent.Http_GameInit,HttpEvent).toCommand(HttpGameInitCmd);
		}
	}
}