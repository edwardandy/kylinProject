package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	
	public class IconTip extends Sprite
	{
		public function IconTip()
		{
			super();
			var sp:DisplayObject = Reflection.createSprite( "DefaultToolTipBgSkin" );
			sp.width = 68;
			sp.height = 36;
			sp.x = -33.7;
			sp.y = -47.1;
			addChild( sp );
			_bg = sp;
			
			sp = Reflection.createSprite( "ToolTipBgSkinD" );
			_arrow = sp as Sprite;
			sp.x = -6.45;
			sp.y = -15.05;
			addChild( sp );
			
			_tf = new TextField();
			_tf.selectable = false;
			_tf.width = 55.8;
			_tf.height = 40;
			_tf.x = -27.7;
			_tf.y = -39.5;
			_tf.multiline = true;
			addChild( _tf );
			FontUtil.useFont( _tf, FontUtil.FONT_TYPE_NORMAL );
			_tf.textColor = 0x6F3819;
			_tf.autoSize = TextFieldAutoSize.CENTER;
			var tff:TextFormat = _tf.defaultTextFormat;
			tff.align = TextFormatAlign.CENTER;
			tff.size = 14;
			_tf.defaultTextFormat = tff;
			
			this.cacheAsBitmap = true;
		}
		
		public function set showLine( value:Boolean ):void
		{
			if ( value )
			{
				if ( _lineShape == null )
				{
					_lineShape = new Shape();
					addChildAt( _lineShape, getChildIndex( _tf ) );
				}
				_lineShape.visible = true;
				drawLine();
			}
			else
			{
				if ( _lineShape )
				{
					_lineShape.visible = false;
				}
			}
		}
		
		public function drawLine():void
		{
			var g:Graphics = _lineShape.graphics;
			g.clear();
			g.lineStyle( 2, BasicToolTip.lineColor, BasicToolTip.separatealpha, true );
			if ( _tf.numLines > 1 )
			{
				var endX:Number = _tf.width - 3;
				var lineHeight:Number = _tf.textHeight / _tf.numLines;
				for ( var i:int=1; i<_tf.numLines; i++ )
				{
					var y:Number = 2 + lineHeight * i;
					g.moveTo( 3, y );
					g.lineTo( endX, y );
				}
			}
		}
		
		/**
		 * 设置内容 
		 * @param value
		 * 
		 */		
		public function set tip( value:String ):void
		{
			if ( _value == value )
			{
				return;
			}
			_value = value;
			_tf.width = 200;
			_tf.height = 39.6;
			
			var tf:TextFormat = _tf.defaultTextFormat;
			var lineFlag:Boolean = _lineShape && _lineShape.visible;
			lineFlag ? tf.leading = 10 : tf.leading = 0;
			_tf.defaultTextFormat = tf;			
			_tf.text = value;
			if ( lineFlag )
			{
				drawLine();
			}
			_tf.width = _tf.textWidth + 2;
			_tf.height = _tf.numLines > 1 ? 39.6 : 20.8;
			_bg.width = _tf.width + 12;
			_bg.height = _tf.height + 12;
			_bg.y = -_bg.height - 11.1;
			_tf.y = _bg.y + 7.6;
			
			_bg.x = -_bg.width >> 1;
			
			_testP.x = _bg.x;
			_testP = GameAGlobalManager.getInstance().game.globalToLocal(this.localToGlobal( _testP ));
			if ( _testP.x < 0 )	//超出舞台左边
			{
				_testP.x = 0;
				_bg.x = -GameAGlobalManager.getInstance().game.globalToLocal(this.localToGlobal( _testP )).x;
				_tf.x = _bg.x + 6;
				if ( lineFlag )
				{
					_lineShape.x = _tf.x;
					_lineShape.y = _tf.y;
				}
				return;
			}
			
			_testP.x = _bg.width >> 1;
			_testP = GameAGlobalManager.getInstance().game.globalToLocal(this.localToGlobal( _testP ));
			if ( _testP.x > GameFightConstant.SCENE_MAP_WIDTH )	//超出舞台右边
			{
				_testP.x = 0;
				_bg.x = GameFightConstant.SCENE_MAP_WIDTH - GameAGlobalManager.getInstance().game.globalToLocal(this.localToGlobal( _testP )).x - _bg.width;
			}
			_tf.x = _bg.x + 6;
			if ( lineFlag )
			{
				_lineShape.x = _tf.x;
				_lineShape.y = _tf.y;
			}
		}
		
		//-----------------------------------------------------
		//私有变量
		//-----------------------------------------------------
		
		protected var _tf:TextField = null;
		
		protected var _value:String = null;
		
		protected var _bg:DisplayObject = null;
		
		private var _testP:Point = new Point();
		
		protected var _arrow:Sprite = null;
		
		protected var _lineShape:Shape = null;
	}
}