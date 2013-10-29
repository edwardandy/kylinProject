package kylin.echo.edward.ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import kylin.echo.edward.utilities.font.FontMgr;
	
	/**
	 * 
	 * 
	 * 按钮;皮肤必须是影片剪辑类型的,否则无法实现效果;
	 * 会自动添加鼠标划入划出效果,以及增加禁用状态;
	 * 皮肤:
	 */
	public class McButton
	{
		protected var bt : MovieClip;
		protected var curEnabled : Boolean = true;
		// 帧序列,1;正常状态,2;鼠标滑入效果,3;鼠标点击,4;禁用状态;5;激活等待点击,
		protected var frameArr : Array = [1, 2, 3, 4, 5];
		protected var tipsLabel : String;
		// 防止快速频繁点击;
		protected var lastClickTime : int = 0;
		protected var actionListener : Function;
		protected var args : Array;
		protected var overSound : String;
		protected var clickSound : String;
		protected var curVisibleState : Boolean = true;
		
		protected var _selected:Boolean = false;
		
		protected var _txt:TextField;
		protected var _backFifter:Array = [];
		protected var _enabedFifter:Array = [];
		
		//private var _labelPreY:int;

		public function McButton(tipsLabel : String = "", overSound : String = "", clickSound : String = "")
		{
			this.overSound = overSound;
			this.clickSound = clickSound;
			resetToolTips(tipsLabel);
			this.frameArr = frameArr;
		}
		
		protected var toOverUntilClickFlag:Boolean = false;
		
		public function toOverUntilClick():void
		{
			toOverUntilClickFlag = true;
			if ( bt.totalFrames < frameArr[4] )
			{
				bt.gotoAndStop(frameArr[1]);
			}
			else
			{
				bt.gotoAndStop(frameArr[4]);
			}
		}
		
		public function set visible(isVisible : Boolean) : void
		{
			curVisibleState = isVisible;
			if (bt != null)
			{
				bt.visible = isVisible;
			}
		}

		public function get visible() : Boolean
		{
			return curVisibleState;
		}

		public function dispose() : void
		{
			removeEvent();
			if (bt != null) 
				bt.stop();
			bt = null;
			frameArr = null;
			actionListener = null;
			args = null;
		}

		public function set(attName : String, value : *) : void
		{
			if (bt == null) return;
			bt[attName] = value;
		}

		public function get(attName : String) : *
		{
			if (bt == null) return null;
			return bt[attName];
		}

		public function addActionEventListener(fun : Function, ...args) : void
		{
			actionListener = fun;
			this.args = args;
		}

		public function removeActionEventListener() : void
		{
			actionListener = null;
		}

		public function addEventListener(type : String, fun : Function) : void
		{
			if (bt == null)
			{
				return;
			}
			bt.addEventListener(type, fun);
		}

		public function removeEventListener(type : String, fun : Function) : void
		{
			if (bt == null)
			{
				return;
			}
			bt.removeEventListener(type, fun);
		}

		public function resetToolTips(str : String = "") : void
		{
			tipsLabel = str;
			if (str != "")
			{
			}
		}

		public function setFrameIndex(frameArr : Array = null) : void
		{
			if (frameArr != null)
			{
				this.frameArr = frameArr;
				if (bt != null)
				{
					if (_txt != null)
					{
						//_txt.y=_labelPreY;
					}
					bt.gotoAndStop(frameArr[0]);
				}
			}
		}

		public function getFrameIndexArr() : Array
		{
			return frameArr;
		}

		public function getSkin() : MovieClip
		{
			return bt;
		}
		
		public function get x():Number
		{
			return bt.x;
		}
		public function get y():Number
		{
			return bt.y;
		}
		public function move(x:Number, y:Number):void
		{
			bt.x = x;
			bt.y = y;
		}

		public function setSkin(skin : MovieClip, frameArr : Array = null) : void
		{
			if (frameArr != null) this.frameArr = frameArr;
			if (bt == skin) return;
			if (skin == null)
			{
				throw(new Error("MyButton对象的皮肤不能为空"));
				return;
			}
			if (bt != null)
			{
				removeEvent();
			}

			bt = skin;
			//bt.mcButton = this;
			bt.mouseChildren = false;
			bt.buttonMode = true;
			bt.gotoAndStop(this.frameArr[0]);
			bt.visible = curVisibleState;
			addEvent();
			
			_txt = bt.getChildByName("label") as TextField;
			if(!_txt)return;
			//Fonts.autoEmbedFonts(bt);
			_backFifter = _txt.filters;
			_enabedFifter =[new GlowFilter(0x4a4a4a,0.7,5,5,1000)];
//			if(_enabedFifter.length == 0)
//			{
//				var _filter:GlowFilter = new GlowFilter(0x4a4a4a,1,4,4,1000);
//				_enabedFifter = [_filter];
//			}
			//if (_txt != null)_labelPreY = _txt.y;
		}

		public function set label(str : String) : void
		{
			if (bt != null && str != null)
			{
				_txt = bt.getChildByName("label") as TextField;
				if (_txt != null)
				{
					_txt.text = str;
					//_labelPreY = _txt.y;
					
					/*var rextFormat:TextFormat = _txt.getTextFormat();
					rextFormat.size = 20;
					_txt.setTextFormat(rextFormat);*/
					
					//默认设置了button的字体
//					setLabelFont(FontUtil.FONT_TYPE_BUTTON,14);
				}
			}
		}
		
		public function get label():String
		{
			return _txt != null ? _txt.text : "";
		}
		
		/**
		 * 按钮标签居中对齐 
		 */
		public function alignLabel():void
		{
			var rect:Rectangle = bt.getBounds(bt);
			if(bt['label']){
				var label:TextField = bt['label'];
				label.autoSize = TextFieldAutoSize.CENTER;
				AutoAlign.alignYToRect([label],rect);
			}
		}

		/**
		 * 设置label字体 
		 * @param fontType
		 * @param fontSize
		 * 
		 */
		public function setLabelFont(fontType:String,fontSize:* = null):void
		{
			if(bt){
				var tfl:TextField = bt.getChildByName("label") as TextField;
				if(tfl){
					tfl.multiline = false;
					if(fontSize){
						var format:TextFormat = tfl.defaultTextFormat;
						format.size = fontSize;
						tfl.defaultTextFormat = format;
					}
					FontMgr.instance.setTextStyle(tfl,fontType);
				}
			}
		}
		
		/**
		 * 禁用鼠标,禁用后会删除所有事件,也就没有了鼠标效果;
		 */
		public function set enabled(isEnabled : Boolean) : void
		{
			if (bt == null) return;
			curEnabled = isEnabled;
			bt.buttonMode = isEnabled;
			if(_txt){
				_txt.filters = isEnabled ? _backFifter :_enabedFifter;
			}
			if(bt.totalFrames < 4){
				//DisplayUtility.makeGrey(bt,!isEnabled);
				if(!isEnabled){
					bt.gotoAndStop(frameArr[0]);
					return;
				}
			}
			
			bt.gotoAndStop(isEnabled ? frameArr[0] : frameArr[3]);
		}

		public function get enabled() : Boolean
		{
			return curEnabled;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (value) {
				enabled = false;
				bt.gotoAndStop(frameArr[2]);
			}else {
				enabled = true;
				bt.gotoAndStop(frameArr[0]);
			}
			_selected = value;
		}

		/**
		 * 注册tip 
		 * @param gameTipType
		 * @param tipHandlerOrData 如果传入函数则当作tip处理函数，如果传入数据则当作tip数据
		 * 
		 */
		/*protected var _tipHandler:Function;
		public function registTip(gameTipType:int,tipHandlerOrData:*):void
		{
			unRegistTip();
			ToolTipManager.getInstance().registGameToolTipTarget(bt,gameTipType);
			if(tipHandlerOrData is Function){
				_tipHandler = tipHandlerOrData;
				bt.addEventListener(ToolTipEvent.GAME_TOOL_TIP_SHOW,tipHandlerOrData);
			}
			else{
				_tipHandler = function (e:ToolTipEvent):void{ e.toolTip.data = tipHandlerOrData; };
				bt.addEventListener(ToolTipEvent.GAME_TOOL_TIP_SHOW, _tipHandler);
			}
		}*/
		
		/**
		 * 移除tip侦听
		 */
		/*public function unRegistTip():void
		{
			ToolTipManager.getInstance().unRegistToolTipTarget(bt);
			if(_tipHandler != null){
				bt.removeEventListener(ToolTipEvent.GAME_TOOL_TIP_SHOW,_tipHandler);
			}
		}*/
		
		protected function addEvent() : void
		{
			bt.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			bt.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			bt.addEventListener(MouseEvent.MOUSE_DOWN, onPressDown);
			bt.addEventListener(MouseEvent.MOUSE_UP, onReleaseUp);
			bt.addEventListener(MouseEvent.CLICK, onClickBt);
		}

		protected function onClickBt(e : MouseEvent) : void
		{
			toOverUntilClickFlag = false;
			if (curEnabled && actionListener != null)
			{
				if (args.length > 0)
				{
					actionListener.apply(null, args);
				}
				else
				{
					actionListener.apply(null, null);
				}
			}
		}

		protected function removeEvent() : void
		{
			if (bt == null) return;
			bt.removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			bt.removeEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			bt.removeEventListener(MouseEvent.MOUSE_DOWN, onPressDown);
			bt.removeEventListener(MouseEvent.MOUSE_UP, onReleaseUp);
			bt.removeEventListener(MouseEvent.CLICK, onClickBt);
		}

		protected function onRollOver(e : MouseEvent) : void
		{
			if (curEnabled)
			{
				if (overSound != "")
				{
					// SoundManager.instance.createSound(overSound, DataManager.getInstance().soundApp);
				}
				if (_txt != null)
				{
					//_txt.y=_labelPreY;
				}
				
				if ( toOverUntilClickFlag )
				{
					toOverUntilClick();
				}
				else
				{
					bt.gotoAndStop(frameArr[1]);
				}
			}
		}

		protected function onRollOut(e : MouseEvent) : void
		{
			if (curEnabled && !toOverUntilClickFlag){
				if (_txt != null)
				{
					//_txt.y=_labelPreY;
				}
				
				if ( toOverUntilClickFlag )
				{
					toOverUntilClick();
				}
				else
				{
					bt.gotoAndStop(frameArr[0]);
				}
			}
		}

		protected function onPressDown(e : MouseEvent) : void
		{
			if (curEnabled)
			{
				if (clickSound != "")
				{
					// SoundManager.instance.createSound(clickSound, DataManager.getInstance().soundApp);
				}
				
				if (_txt != null)
				{
					//_txt.y=_labelPreY + 2;
				}
				
				bt.gotoAndStop(frameArr[2]);
			}
		}

		protected function onReleaseUp(e : MouseEvent) : void
		{
			if (curEnabled)
			{
				if (_txt != null)
				{
					//_txt.y=_labelPreY;
				}
				bt.gotoAndStop(frameArr[1]);
			}
		}
	}
}