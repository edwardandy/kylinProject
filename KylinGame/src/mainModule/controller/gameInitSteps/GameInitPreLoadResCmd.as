package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	import kylin.echo.edward.utilities.loader.resPath.ResPathFolderType;
	
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.panelData.PanelNameConst;
	import mainModule.model.panelData.interfaces.IPanelCfgModel;
	import mainModule.model.preLoadData.PreLoadCfgVo;
	import mainModule.model.preLoadData.interfaces.IPreLoadCfgModel;

	/**
	 * 预加载资源 
	 * @author Edward
	 * 
	 */	
	public class GameInitPreLoadResCmd extends KylinCommand
	{
		[Inject]
		public var panelCfgs:IPanelCfgModel;
		[Inject]
		public var loadMgr:ILoadMgr;
		[Inject]
		public var loadProgress:ILoaderProgress;
		[Inject]
		public var preLoadCfg:IPreLoadCfgModel;
		
		public function GameInitPreLoadResCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			startPreLoad();
			
			if(loadProgress.hasItem)
			{
				loadProgress.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
				loadProgress.addEventListener(Event.COMPLETE,allLoadCmp);
			}
			else
			{
				allLoadCmp();
			}
			
			directCommandMap.detain(this);
		}
		
		private function startPreLoad():void
		{
			preLoadPanels();
			preLoadRes();
		}
		
		private function preLoadPanels():void
		{
			var arrPanels:Array = panelCfgs.getPreloadPanelResIds();
			for each(var resId:String in arrPanels)
			{
				var item:ImageItem = loadMgr.addModuleItem(resId,resId+"_childDomain");
				if(item && !item.isLoaded)
					loadProgress.addItem(item);
			}
		}
		
		private function preLoadRes():void
		{
			var item:LoadingItem;
			for each(var cfg:PreLoadCfgVo in preLoadCfg.firstLoadRes)
			{
				switch(cfg.folder)
				{
					case ResPathFolderType.Module:
					{
						item = loadMgr.addModuleItem(cfg.id);
					}
						break;
					case ResPathFolderType.ConfigFile:
					{
						item = loadMgr.addCfgFileItem(cfg.id);
					}
						break;
				}
				
				if(item && !item.isLoaded)
					loadProgress.addItem(item);
			}
		}
		
		private function onLoadProgress(e:ProgressEvent):void
		{
			dispatch(e);
		}
		
		private function allLoadCmp(e:Event = null):void
		{
			loadProgress.removeEventListener(ProgressEvent.PROGRESS,onLoadProgress);
			loadProgress.removeEventListener(Event.COMPLETE,allLoadCmp);
			
			//dispatch(new HttpEvent(HttpEvent.Http_GameInit));
			dispatch(new UIPanelEvent(UIPanelEvent.UI_ClosePanel,PanelNameConst.LoadPanel));
			dispatch(new UIPanelEvent(UIPanelEvent.UI_OpenPanel,PanelNameConst.KylinFightModule));
			
			directCommandMap.release(this);
		}
	}
}