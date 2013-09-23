package mainModule.model.textData.interfaces
{
	/**
	 * 文字配置文件，用于灵活显示多语言文本内容 
	 * @author Edward
	 * 
	 */	
	public interface ITextCfgModel
	{
		function addTextCfg(id:String,cfg:XML):void;
		function getTextCfg(id:String):XML;
	}
}