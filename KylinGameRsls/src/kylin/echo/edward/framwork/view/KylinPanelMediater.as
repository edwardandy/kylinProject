package kylin.echo.edward.framwork.view
{
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class KylinPanelMediater extends Mediator
	{		
		public function KylinPanelMediater()
		{
			super();
		}

		override public function initialize():void
		{
			super.initialize();
			basePanel.firstInit();
		}
		
		override public function destroy():void
		{
			super.destroy();
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