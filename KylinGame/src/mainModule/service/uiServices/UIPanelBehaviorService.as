package mainModule.service.uiServices
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	import kylin.echo.edward.framwork.view.interfaces.IKylinBasePanel;
	
	import mainModule.model.panelData.PanelCfgVo;
	import mainModule.model.panelData.PanelInstancesModel;
	import mainModule.model.panelData.ViewLayersModel;
	import mainModule.model.panelData.interfaces.IPanelCfgModel;
	import mainModule.service.uiServices.interfaces.IUIPanelBehaviorService;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import utili.behavior.declare.DeclareBehavior;
	import utili.behavior.interfaces.IAppearBehavior;
	import utili.behavior.interfaces.IDisappearBehavior;
	
	public class UIPanelBehaviorService extends KylinActor implements IUIPanelBehaviorService
	{
		[Inject]
		public var _panelCfg:IPanelCfgModel;
		[Inject]
		public var _panels:PanelInstancesModel;
		[Inject]
		public var _injector:IInjector;
		[Inject]
		public var _declare:DeclareBehavior;
		[Inject]
		public var _layers:ViewLayersModel;
		
		private var _appearPanelCount:int;
		public function UIPanelBehaviorService()
		{
			super();
		}
		
		public function appear(panelId:String):void
		{
			var panel:IKylinBasePanel = _panels.getPanel(panelId);
			if(!panel)
				return;
			
			var appearClass:Class = _declare.getBehaviorClass(_panelCfg.getPanelCfg(panelId).appearStrategy);
			appearClass ||= _declare.getBehaviorClass("AppearDirectly");
			if(!appearClass)
				return;
			
			var cfg:PanelCfgVo = _panelCfg.getPanelCfg(panelId);
			_layers.getPanelSubLayerByIdx(cfg.layerIndex).addChild(DisplayObject(_panels.getPanel(panelId)));
			
			var iAppear:IAppearBehavior = _injector.instantiateUnmapped(appearClass);
			iAppear.init(Sprite(panel),appearCB);
			iAppear.appear();
			++_appearPanelCount;
			if(1 == _appearPanelCount)
				_layers.waitPanelAppearLayer.visible = true;
		}
		
		private function appearCB(iAppear:IAppearBehavior,panel:IKylinBasePanel):void
		{
			iAppear.dispose();
			panel.afterAppear();
			
			if(_appearPanelCount <= 0)
				return;
			--_appearPanelCount;
			if(0 == _appearPanelCount)
				_layers.waitPanelAppearLayer.visible = false;
		}
		
		public function disappear(panelId:String):void
		{
			var panel:IKylinBasePanel = _panels.getPanel(panelId);
			if(!panel)
				return;
			
			var disappearClass:Class = _declare.getBehaviorClass(_panelCfg.getPanelCfg(panelId).disappearStrategy);
			disappearClass ||= _declare.getBehaviorClass("DisappearDirectly");
			if(!disappearClass)
				return;
			var iDisappear:IDisappearBehavior = _injector.instantiateUnmapped(disappearClass);
			iDisappear.init(Sprite(panel),disappearCB);
			iDisappear.disappear();
		}
		
		private function disappearCB(iDisappear:IDisappearBehavior,panel:IKylinBasePanel):void
		{
			iDisappear.dispose();
			panel.afterDisappear();
			var spPanel:Sprite = panel as Sprite;
			if(spPanel.parent)
				spPanel.parent.removeChild(spPanel);
		}
	}
}