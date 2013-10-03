package kylin.echo.edward.framwork.view
{
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class KylinPanelMediater extends Mediator
	{		
		[Inject]
		public var basePanel:KylinBasePanel;
		
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
	}
}