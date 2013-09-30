package mainModule.controller.uiCmds
{
	import flash.events.Event;
	
	/**
	 * 面板打开、关闭等操作事件 
	 * @author Administrator
	 * 
	 */	
	public class UIPanelEvent extends Event
	{
		/**
		 * 打开面板
		 */		
		public static const UI_OpenPanel:String = "openPanel";
		/**
		 * 面板打开完毕
		 */		
		public static const UI_PanelOpened:String = "panelOpened";
		/**
		 * 关闭面板
		 */		
		public static const UI_ClosePanel:String = "closePanel";
		/**
		 * 面板关闭完毕
		 */		
		public static const UI_PanelClosed:String = "panelClosed";
		
		private var _panelId:String;
		private var _body:Object;
		
		public function UIPanelEvent(type:String,id:String,data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_panelId = id;
			_body = data;
		}
		/**
		 * 事件所带的参数 
		 * @return 
		 * 
		 */		
		public function get body():Object
		{
			return _body;
		}

		/**
		 * 事件处理的面板id 
		 * @return 
		 * 
		 */		
		public function get panelId():String
		{
			return _panelId;
		}

		override public function clone():Event
		{
			return new UIPanelEvent(type,_panelId,bubbles,cancelable);
		}
	}
}