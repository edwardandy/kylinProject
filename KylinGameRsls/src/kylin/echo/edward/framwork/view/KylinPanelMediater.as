package kylin.echo.edward.framwork.view
{
	public class KylinPanelMediater extends KylinMediater
	{		
		public function KylinPanelMediater()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();
			basePanel.firstInit();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			basePanel.dispose();
		}
		/**
		 * 获得面板 
		 * @return 
		 * 
		 */		
		protected function get basePanel():KylinBasePanel
		{
			return viewComponent as KylinBasePanel;
		}
	}
}