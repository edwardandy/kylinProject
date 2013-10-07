package mainModule.view.loadPanel
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import kylin.echo.edward.framwork.view.KylinBasePanel;
	import kylin.echo.edward.utilities.font.FontMgr;
	
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.panelData.PanelNameConst;
	
	import utili.font.FontClsName;

	/**
	 * 首次加载进度显示面板 
	 * @author Edward
	 * 
	 */	
	public class LoadPanel extends KylinBasePanel
	{
		//子显示对象名
		public var mcAnim:MovieClip;
		public var txtProgress:TextField;
		public var txtMsg:TextField;
		
		public function LoadPanel()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			mcAnim = null;
			txtProgress = null;
			txtMsg = null;
		}
		
		override protected function onShowEnd(param:Object=null):void
		{
			super.onShowEnd(param);
			dispatchEvent(new UIPanelEvent(UIPanelEvent.UI_PanelOpened,PanelNameConst.LoadPanel));
		}
		
		override protected function onFirstInit():void
		{
			super.onFirstInit();
			
			FontMgr.instance.setTextStyle(txtMsg,FontClsName.NormalFont);
			FontMgr.instance.setTextStyle(txtProgress,FontClsName.ButtonFont);
			
			txtMsg.text = "My Test Info.";
			txtProgress.text = "Loading...50%";
		}
	}
}