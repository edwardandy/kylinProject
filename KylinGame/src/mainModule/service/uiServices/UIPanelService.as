package mainModule.service.uiServices
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	import kylin.echo.edward.framwork.view.interfaces.IKylinBasePanel;
	import kylin.echo.edward.utilities.display.DisplayObjectUtils;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	
	import mainModule.extensions.viewLayers.ViewLayersMgr;
	import mainModule.model.panelData.PanelCfgVo;
	import mainModule.model.panelData.PanelInstancesModel;
	import mainModule.model.panelData.PanelNameConst;
	import mainModule.model.panelData.interfaces.IPanelCfgModel;
	import mainModule.model.panelData.interfaces.IPanelDeclareModel;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	import mainModule.service.uiServices.interfaces.IUIPanelBehaviorService;
	import mainModule.service.uiServices.interfaces.IUIPanelService;
	
	import robotlegs.bender.framework.api.IInjector;
	
	
	
	public class UIPanelService extends KylinActor implements IUIPanelService
	{
		[Inject]
		public var _panelCfg:IPanelCfgModel;
		[Inject]
		public var _panelDeclare:IPanelDeclareModel;
		[Inject]
		public var _layers:ViewLayersMgr;
		[Inject]
		public var _panels:PanelInstancesModel;
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var _injector:IInjector;
		[Inject]
		public var _panelBehavior:IUIPanelBehaviorService;
		[Inject]
		public var stage:Stage;
		
		private var _dicResIDToPanelID:Dictionary;
		private var _dicPanelIDToParam:Dictionary;
		private var _iLoadingResCount:int;
		
		public function UIPanelService()
		{
			super();
			_dicResIDToPanelID = new Dictionary;
			_dicPanelIDToParam = new Dictionary;
			_iLoadingResCount = 0;
		}
			
		public function openPanel(id:String,param:Object = null):void
		{
			if(_panels.getPanel(id))
			{
				appearPanel(id,param);
				return;
			}
			
			var cfg:PanelCfgVo = _panelCfg.getPanelCfg(id);
			if(!cfg)
				return;
			var resId:String = cfg.resId || id;
			
			var assetInfo:AssetInfo = loadService.getModuleItem(resId);
			if(assetInfo && assetInfo.content)
			{
				genPanelInstance(id,assetInfo.content,param);
				return;
			}
			
			var item:ImageItem = loadService.addModuleItem(resId,resId+"_childDomain").item as ImageItem;
			if(!item)
				return;
			if(item.isLoaded)
			{
				genPanelInstance(id,item.content,param);
				return;
			}
			
			_dicPanelIDToParam[id] = param;
			
			_dicResIDToPanelID[item.id] ||= [];
			if(-1 != (_dicResIDToPanelID[item.id] as Array).indexOf(id))
			{
				return;
			}
			(_dicResIDToPanelID[item.id] as Array).push(id);
			
			//if(!item.isLoaded && !item._isLoading)
			{
				if(1 != cfg.iPreLoad)
				{
					++_iLoadingResCount;
					if(1 == _iLoadingResCount)
						openPanel(PanelNameConst.WaitingPanel);
				}
				item.addEventListener(Event.COMPLETE,onPanelResLoadCmp);
				item.addEventListener(IOErrorEvent.IO_ERROR,onPanelResLoadError);
				item.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onPanelResLoadError);
			}
		}
		
		private function appearPanel(id:String,param:Object):void
		{
			_panels.getPanel(id).appear(param);
			_panelBehavior.appear(id);
		}
		
		private function genPanelInstance(id:String,content:*,param:Object):void
		{
			if(_panels.getPanel(id))
				return;
			var instance:IKylinBasePanel;
			if(content is IKylinBasePanel)
			{
				//var cls:Class = loadService.domainMgr.getClassByDomain("release.module."+id+"::"+id);
				var fullClassName:String = "release.module."+id.charAt().toLowerCase()+id.slice(1)+"::"+id;
				instance = IKylinBasePanel(new ((content as Sprite).loaderInfo.applicationDomain.getDefinition(fullClassName) as Class))
				//instance = IKylinBasePanel(content);
				_injector.injectInto(instance);
			}
			else
				instance = IKylinBasePanel(_injector.instantiateUnmapped(_panelDeclare.getPanelClass(id)));
			if(!instance)
				return;
			_panels.cachePanel(id,instance);
			_panels.getPanel(id).panelId = id;
			
			_panels.getPanel(id).resDomain = (content as DisplayObject).loaderInfo.applicationDomain;
			DisplayObjectUtils.instance.fillRectSprite(Sprite(_panels.getPanel(id)),stage.stageWidth,stage.stageHeight,0,0);
			//var cfg:PanelCfgVo = _panelCfg.getPanelCfg(id);
			//_layers.getPanelSubLayerByIdx(cfg.layerIndex).addChild(DisplayObject(_panels.getPanel(id)));
			appearPanel(id,param);
		}
		
		private function onPanelResLoadCmp(e:Event):void
		{
			var item:ImageItem = e.currentTarget as ImageItem;
			if(!item)
				return;
			checkResLoadResult(item);
			
			for each(var panelId:String in _dicResIDToPanelID[item.id] as Array)
			{
				genPanelInstance(panelId,item.content,_dicPanelIDToParam[panelId]);
				_dicPanelIDToParam[panelId] = null;
				delete _dicPanelIDToParam[panelId];
			}
			
			_dicResIDToPanelID[item.id] = null;
			delete _dicResIDToPanelID[item.id];
		}
		
		private function onPanelResLoadError(e:Event):void
		{
			var item:ImageItem = e.currentTarget as ImageItem;
			if(!item)
				return;
			checkResLoadResult(item);
		}
		
		private function checkResLoadResult(item:ImageItem):void
		{
			item.removeEventListener(Event.COMPLETE,onPanelResLoadCmp);
			item.removeEventListener(IOErrorEvent.IO_ERROR,onPanelResLoadError);
			item.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onPanelResLoadError);
			
			if(_iLoadingResCount<=0)
				return;
			
			--_iLoadingResCount;
			if(0 == _iLoadingResCount)
				closePanel(PanelNameConst.WaitingPanel);
		}
		
		public function closePanel(id:String,param:Object = null):void
		{
			if(_panels.getPanel(id))
			{
				_panels.getPanel(id).disappear(param);
				_panelBehavior.disappear(id);
			}
		}
	}
}