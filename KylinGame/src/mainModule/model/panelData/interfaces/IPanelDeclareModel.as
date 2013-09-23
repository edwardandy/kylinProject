package mainModule.model.panelData.interfaces
{
	/**
	 * 面板名与面板类的映射声明 
	 * @author Edward
	 * 
	 */	
	public interface IPanelDeclareModel
	{
		/**
		 * 通过面板名获得面板类 
		 * @param id 面板名
		 * @return 面板类
		 * 
		 */		
		function getPanelClass(id:String):Class;
		/**
		 * 添加面板名和面板类的映射 
		 * @param id 面板名
		 * @param panel 面板类
		 * 
		 */		
		function declarePanel(id:String,panel:Class):void;
	}
}