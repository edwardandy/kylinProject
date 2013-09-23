package mainModule.model.panelData
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.framwork.model.KylinModel;
	import kylin.echo.edward.framwork.view.interfaces.IKylinBasePanel;

	/**
	 * 面板实例 
	 * @author Edward
	 * 
	 */	
	public class PanelInstancesModel extends KylinModel
	{
		private var _dicPanels:Dictionary;
		
		public function PanelInstancesModel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_dicPanels = new Dictionary;
		}
		
		public function getPanel(id:String):IKylinBasePanel
		{
			return _dicPanels[id];
		}
		
		public function cachePanel(id:String,panel:IKylinBasePanel):void
		{
			_dicPanels[id] = panel;
		}
		
		public function deletePanel(id:String):IKylinBasePanel
		{
			var panel:IKylinBasePanel = _dicPanels[id];
			_dicPanels[id] = null;
			delete _dicPanels[id];
			return panel;
		}
	}
}