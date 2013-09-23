package mainModule.service.uiServices.interfaces
{
	/**
	 * 面板行为，包括显示和消失动画 
	 * @author Edward
	 * 
	 */	
	public interface IUIPanelBehaviorService
	{
		/**
		 * 面板显示动画 
		 * @param panelId
		 * 
		 */		
		function appear(panelId:String):void;
		/**
		 * 面板消失动画 
		 * @param panelId
		 * 
		 */		
		function disappear(panelId:String):void;
	}
}