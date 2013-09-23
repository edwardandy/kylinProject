package mainModule.service.uiServices.interfaces
{
	/**
	 * 面板打开关闭的功能管理 
	 * @author Edward
	 * 
	 */	
	public interface IUIPanelService
	{
		/**
		 * 打开面板 
		 * @param id 面板id
		 * @param param 显示参数
		 * 
		 */		
		function openPanel(id:String,param:Object = null):void;
		/**
		 * 关闭面板 
		 * @param id 面板id
		 * @param param 显示参数
		 * 
		 */	
		function closePanel(id:String,param:Object = null):void;
	}
}