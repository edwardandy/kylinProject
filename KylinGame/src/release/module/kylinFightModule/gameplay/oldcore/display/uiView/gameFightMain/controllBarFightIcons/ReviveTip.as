package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import com.shinezone.utils.Reflection;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flashx.textLayout.formats.TextAlign;
	
	import framecore.tools.font.FontUtil;
	
	/**
	 * HeroReviveTip 
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class ReviveTip extends Sprite
	{
		public function ReviveTip()
		{
			super();
			
			var sp:DisplayObject = Reflection.createSprite( "DefaultToolTipBgSkin" );
			sp.width = 68;
			sp.height = 41;
			sp.x = -33.7;
			sp.y = -51.85;
			addChild( sp );
			
			sp = Reflection.createSprite( "ToolTipBgSkinD" );
			sp.x = -6.4;
			sp.y = -14.85;
			addChild( sp );
			
			_tf = new TextField();
			_tf.width = 55.8;
			_tf.height = 38.6;
			_tf.x = -27.7;
			_tf.y = -49.3;
			addChild( _tf );
			FontUtil.useFont( _tf, FontUtil.FONT_TYPE_NORMAL );
			_tf.textColor = 0x6F3819;
			_tf.multiline = true;
			_tf.autoSize = TextFieldAutoSize.CENTER;
			var tff:TextFormat = _tf.defaultTextFormat;
			tff.align = TextFormatAlign.CENTER;
			tff.size = 14;
			_tf.defaultTextFormat = tff;
		}
		
		public function set time( value:int ):void
		{
			_tf.text = "Revive\n00:" + (value > 9 ? value : "0"+value);
		}
		
		//-----------------------------------------------------
		//私有变量
		//-----------------------------------------------------
		
		private var _tf:TextField = null;
	}
}