package mainModule.model.panelData.interfaces
{
	import mainModule.model.panelData.PanelCfgVo;
	/**
	 * 面板设置 
	 * @author Edward
	 * 
	 */	
	public interface IPanelCfgModel
	{
		/**
		 * 通过面板id获得面板设置 
		 * @param key 面板id
		 * @return 面板设置
		 * 
		 */		
		function getPanelCfg(key:String):PanelCfgVo;
		/**
		 * 获得首次加载面板的资源id 
		 * @return 
		 * 
		 */		
		function getPreloadPanelResIds():Array;
	}
}