package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 *
	 * @author Jiao Zhongxiao
	 * @date   2013-7-31
	 *
	 */
	public class MonsterWarnTip extends IconTip
	{
		public function MonsterWarnTip()
		{
			super();
			addChild( _mask );
			_tf.mask = _mask;
			var tff:TextFormat = _tf.defaultTextFormat;
			tff.align = TextFormatAlign.LEFT;
			_tf.defaultTextFormat = tff;
			//FontUtil.resizeFont( _tf, 12 );
//			_arrow.visible = false;
			
			_header = new MonsterWarnTip_Header0();
			addChild( _header );
		}
		
		override public function set tip(value:String):void
		{
			var arr:Array = value.split( "\\n" );
			for ( var i:int=0; i<arr.length; i++ )
			{
				arr[i] = "             " + arr[i];
			}
			super.tip = arr.join( "\n" );
		}
		
		public function show():void
		{
			_header.x = _bg.x - 5;
			_header.y = _bg.y + _bg.height - _header.height - 2;
			
			_mask.x = _tf.x;
			_mask.y = _tf.y;
			_mask.graphics.clear();
			_mask.graphics.beginFill( 0xFF00FF );
			_mask.graphics.drawRect( 0, 0, _tf.width, _tf.height );
			_mask.graphics.endFill();
			
			_mask.scaleX = this.scaleX = this.scaleY = 0;
			this.alpha = 0;
			
			TweenLite.to( this, 1, {scaleX:1, scaleY:1, alpha:1} );
			TweenLite.to( _mask, 1, {scaleX:1, delay:1} );
			TweenLite.to( this, 1, {scaleX:0, scaleY:0, alpha:0, delay:4} );
		}
		
		//-----------------------------------------------------
		//私有变量
		//-----------------------------------------------------
		
		protected var _mask:Shape = new Shape();
		
		protected var _header:MovieClip = null;
	}
}