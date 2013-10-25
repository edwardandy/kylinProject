package mainModule.service.textService
{
	import flash.text.TextField;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	/**
	 * 文本内容转换类，用于多语言文本 
	 * @author Edward
	 * 
	 */	
	public class TextTranslateService extends KylinActor
	{
		public function TextTranslateService()
		{
			super();
		}
		
		public function translateText(str:String,tfl:TextField = null):String
		{
			if(tfl)
				tfl.text = str;
			return str;
		}
	}
}