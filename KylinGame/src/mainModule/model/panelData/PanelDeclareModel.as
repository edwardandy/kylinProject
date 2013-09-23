package mainModule.model.panelData
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.framwork.model.KylinModel;
	
	import mainModule.model.panelData.interfaces.IPanelDeclareModel;
	import mainModule.view.loadPanel.LoadPanel;

	/**
	 * 面板名与面板类的映射声明 
	 * @author Edward
	 * 
	 */	
	public class PanelDeclareModel extends KylinModel implements IPanelDeclareModel
	{
		private var _dicPanelDeclare:Dictionary = new Dictionary;
		
		public function PanelDeclareModel()
		{
			super();
			declare();
		}
		
		private function declare():void
		{
			declarePanel(PanelNameConst.LoadPanel,LoadPanel);
		}
		
		public function declarePanel(id:String,panel:Class):void
		{
			_dicPanelDeclare[id] = panel;
		}
		
		public function getPanelClass(id:String):Class
		{
			return _dicPanelDeclare[id];
		}
	}
}