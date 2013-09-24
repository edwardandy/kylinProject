package mainModule.controller.gameInitSteps
{	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	
	import mainModule.model.gameConstAndVar.FlashVarsModel;
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	import mainModule.model.textData.interfaces.ITextCfgModel;
	
	public class GameInitSetupGameCfgCmd extends KylinCommand
	{
		[Inject]
		public var gameCfgModel:IGameCfgModel;
		[Inject]
		public var textCfg:ITextCfgModel;
		[Inject]
		public var flashVars:FlashVarsModel;
		[Inject]
		public var loadMgr:ILoadMgr;
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
				loadProgress.addItem(loadMgr.addCfgFileItem(textKey));
			}
			loadProgress.addEventListener(Event.COMPLETE,onTextConfigLoaded);
		}
		
		private function onTextConfigLoaded(e:Event):void
		{
			loadProgress.removeEventListener(Event.COMPLETE,onTextConfigLoaded);
			
			for each(var textKey:XML in gameCfgModel.gameCfg.textConfig as XMLList)
			{
				textCfg.addTextCfg(textKey,loadMgr.addCfgFileItem(textKey).content as XML);
			}
			
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitLoadPreloadCfg));
			
			directCommandMap.release(this);
		}
	}
}