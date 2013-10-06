package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	import kylin.echo.edward.utilities.loader.resPath.ResPathFolderType;
	
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.panelData.PanelNameConst;
	import mainModule.model.panelData.interfaces.IPanelCfgModel;
	import mainModule.model.preLoadData.PreLoadCfgVo;
	import mainModule.model.preLoadData.interfaces.IPreLoadCfgModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;

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
		public var loadService:ILoadAssetsServices;
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
				loadProgress.progressCB = onLoadProgress;
				loadProgress.completeCB = allLoadCmp;
			}
			else
				allLoadCmp();
			
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
				loadService.addModuleItem(resId,resId+"_childDomain").addToLoaderProgress(loadProgress);	
			}
		}
		
		private function preLoadRes():void
		{
			for each(var cfg:PreLoadCfgVo in preLoadCfg.firstLoadRes)
			{
				switch(cfg.folder)
				{
					case ResPathFolderType.Module:
					{
						loadService.addModuleItem(cfg.id).addToLoaderProgress(loadProgress);
					}
						break;
					case ResPathFolderType.ConfigFile:
					{
						loadService.addCfgFileItem(cfg.id).addToLoaderProgress(loadProgress);
					}
						break;
				}
			}
		}
		
		private function onLoadProgress(fPercent:Number):void
		{
			dispatch(new ProgressEvent(ProgressEvent.PROGRESS,false,false,fPercent,1));
		}
		
		private function allLoadCmp(e:Event = null):void
		{
			//dispatch(new HttpEvent(HttpEvent.Http_GameInit));
			dispatch(new UIPanelEvent(UIPanelEvent.UI_ClosePanel,PanelNameConst.LoadPanel));
			dispatch(new UIPanelEvent(UIPanelEvent.UI_OpenPanel,PanelNameConst.KylinFightModule));
			
			directCommandMap.release(this);
		}
	}
}