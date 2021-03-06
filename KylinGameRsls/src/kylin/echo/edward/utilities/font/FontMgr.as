package kylin.echo.edward.utilities.font
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public final class FontMgr
	{
		private static var _instance:FontMgr;
		
		private var _dicFonts:Dictionary;
		
		public function FontMgr()
		{
		}
		
		public static function get instance():FontMgr
		{
			return _instance ||= new FontMgr;
		}
		
		private function init():void
		{
			if(!_dicFonts)
			{
				_dicFonts = new Dictionary;
				
				var arrFonts:Array = Font.enumerateFonts();
				var name:String;
				var ft:Font;
				for each(ft in arrFonts)
				{
					name = ft.fontName;//getQualifiedClassName(ft);//
					_dicFonts[name] = ft;
				}
				
				if(!_dicFonts["default"])
				{
					arrFonts = Font.enumerateFonts(true);
					for each(ft in arrFonts)
					{
						if("微软雅黑" == ft.fontName)
						{
							_dicFonts["default"] = ft;
							return;
						}
					}
				}
			}
		}
		
		private function getFontByName(fontName:String):Font
		{
			return (null != _dicFonts[fontName] ? _dicFonts[fontName] : _dicFonts["default"]);
		}
		
		public function setTextStyle(tf:TextField,fontName:String):void
		{
			init();
			var font:Font = getFontByName(fontName);
			if(font)
			{
				var fmt:TextFormat = tf.defaultTextFormat;		
				fmt.bold = false;
				fmt.italic = false;
				fmt.font = font.fontName;
				tf.embedFonts = true;
				tf.defaultTextFormat = fmt;
				tf.text = tf.text;
				//tf.setTextFormat(fmt);
			}
		}
	}
}