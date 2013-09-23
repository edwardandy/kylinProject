package mainModule.controller.uiCmds
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import mainModule.service.uiServices.interfaces.IUIPanelService;

	/**
	 * 打开面板 
	 * @author Edward
	 * 
	 */	
	public class UIOpenPanelCmd extends KylinCommand
	{
		[Inject]
		public var _event:UIPanelEvent;
		[Inject]
		public var _panelService:IUIPanelService;
		
		public function UIOpenPanelCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			_panelService.openPanel(_event.panelId,_event.body);
		}
	}
}