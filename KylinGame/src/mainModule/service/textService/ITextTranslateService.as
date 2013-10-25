package mainModule.service.textService
{
	import flash.text.TextField;

	/**
	 * 文本内容转换类，用于多语言文本 
	 * @author Edward
	 * 
	 */
	public interface ITextTranslateService
	{
		/**
		 * 转换文本 
		 * @param str
		 * @param tf
		 * @return 
		 * 
		 */		
		function translateText(str:String,tf:TextField = null):String;
	}
}