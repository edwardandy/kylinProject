package mainModule.controller.gameInitSteps
{	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	
	import mainModule.extensions.flashVars.FlashVars;
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	import mainModule.model.textData.interfaces.ITextCfgModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	public class GameInitSetupGameCfgCmd extends KylinCommand
	{
		[Inject]
		public var gameCfgModel:IGameCfgModel;
		[Inject]
		public var textCfg:ITextCfgModel;
		[Inject]
		public var flashVars:FlashVars;
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var loadProgress:ILoaderProgress;
		
		public function GameInitSetupGameCfgCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			setUpContextMenu();
			loadTextConfig();
			
			directCommandMap.detain(this);
		}
		
		private function setUpContextMenu():void
		{
			var _conMenu:ContextMenu = new ContextMenu();
			_conMenu.hideBuiltInItems();
			var _contextMenuNameItem:ContextMenuItem = new ContextMenuItem(gameCfgModel.gameCfg.contextmenu);
			var _contextMenuVersionItem:ContextMenuItem = new ContextMenuItem("Version : "+ gameCfgModel.gameCfg.version +"." + flashVars.RES_VER +"_" + flashVars.LAN);
			_conMenu.customItems.push(_contextMenuNameItem);
			_conMenu.customItems.push(_contextMenuVersionItem);
			contextView.view.contextMenu = _conMenu;
		}
		
		private function loadTextConfig():void
		{
			for each(var textKey:XML in gameCfgModel.gameCfg.textConfig as XMLList)
			{
				loadService.addCfgFileItem(textKey).addToLoaderProgress(loadProgress);
			}
			loadProgress.completeCB = onTextConfigLoaded;
		}
		
		private function onTextConfigLoaded():void
		{
			for each(var textKey:XML in gameCfgModel.gameCfg.textConfig as XMLList)
			{
				var asset:AssetInfo = loadService.getCfgFileItem(textKey);
				if(asset && asset.content is XML)
					textCfg.addTextCfg(textKey,asset.content as XML);
			}
			
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitLoadPreloadCfg));
			
			directCommandMap.release(this);
		}
	}
}