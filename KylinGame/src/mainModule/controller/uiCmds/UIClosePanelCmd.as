package mainModule.controller.uiCmds
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import mainModule.service.uiServices.interfaces.IUIPanelService;
	/**
	 * 关闭面板 
	 * @author Edward
	 * 
	 */	
	public class UIClosePanelCmd extends KylinCommand
	{
		[Inject]
		public var _event:UIPanelEvent;
		[Inject]
		public var _panelService:IUIPanelService;
		
		public function UIClosePanelCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			_panelService.closePanel(_event.panelId,_event.body);
		}
	}
}