package mainModule.controller
{
	import mainModule.controller.gameInitSteps.GameInitLoadFontsCmd;
	import mainModule.controller.gameInitSteps.GameInitLoadGameCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitLoadPreloadCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitLoadResCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitPreLoadResCmd;
	import mainModule.controller.gameInitSteps.GameInitSetViewLayersCmd;
	import mainModule.controller.gameInitSteps.GameInitSetupGameCfgCmd;
	import mainModule.controller.gameInitSteps.GameInitStepEvent;
	import mainModule.controller.netCmds.httpCmds.HttpEvent;
	import mainModule.controller.netCmds.httpCmds.cmds.HttpGameInitCmd;
	import mainModule.controller.uiCmds.UIClosePanelCmd;
	import mainModule.controller.uiCmds.UIOpenPanelCmd;
	import mainModule.controller.uiCmds.UIPanelEvent;
	
	import org.robotlegs.core.ICommandMap;

	public class MainModuleCommandsStartUp
	{
		public function MainModuleCommandsStartUp(cmdMap:ICommandMap)
		{
			cmdMap.mapEvent(GameInitStepEvent.GameInitLoadResCfg,GameInitLoadResCfgCmd,GameInitStepEvent,true);
			cmdMap.mapEvent(GameInitStepEvent.GameInitLoadGameCfg,GameInitLoadGameCfgCmd,GameInitStepEvent,true);
			cmdMap.mapEvent(GameInitStepEvent.GameInitSetupGameCfg,GameInitSetupGameCfgCmd,GameInitStepEvent,true);
			cmdMap.mapEvent(GameInitStepEvent.GameInitLoadPreloadCfg,GameInitLoadPreloadCfgCmd,GameInitStepEvent,true);
			cmdMap.mapEvent(GameInitStepEvent.GameInitLoadFonts,GameInitLoadFontsCmd,GameInitStepEvent,true);
			cmdMap.mapEvent(GameInitStepEvent.GameInitSetViewLayers,GameInitSetViewLayersCmd,GameInitStepEvent,true);
			cmdMap.mapEvent(GameInitStepEvent.GameInitPreLoadRes,GameInitPreLoadResCmd,GameInitStepEvent,true);
			
			cmdMap.mapEvent(UIPanelEvent.UI_OpenPanel,UIOpenPanelCmd,UIPanelEvent);
			cmdMap.mapEvent(UIPanelEvent.UI_ClosePanel,UIClosePanelCmd,UIPanelEvent);
			
			mapHttpCmds(cmdMap);
		}
		
		private function mapHttpCmds(cmdMap:ICommandMap):void
		{
			cmdMap.mapEvent(HttpEvent.Http_GameInit,HttpGameInitCmd,HttpEvent);
		}
	}
}