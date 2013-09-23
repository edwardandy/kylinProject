package utili.behavior.displayUtility
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class DisplayUtility
	{
		private static var _instance:DisplayUtility;
		
		private var currentObj:DisplayObject;
		private var cNum:int = 0;
		private var colorStr:String = "";
		private var colorFlag:Boolean = true;
		private var timer:Timer = new Timer(30,20);
		
		public function DisplayUtility()
		{
			
		}
		
		public static function get instance():DisplayUtility
		{
			return _instance ||= new DisplayUtility;
		}

		/**
		 *停止动画，包括之动画 
		 * @param mc
		 * 
		 */		
		public function stopMc(mc:MovieClip):void
		{
			if(mc) mc.stop();
			
			for(var i:int=0;i<mc.numChildren;i++)
			{
				var m:MovieClip=mc.getChildAt(i) as MovieClip;
				if(m) stopMc(m);
			}
		}
		
		
		/**
		 *恢复动画 
		 * @param mc
		 * 
		 */		
		public function resumeMc(mc:MovieClip):void
		{
			for(var i:int=0;i<mc.numChildren;i++)
			{
				var m:MovieClip=mc.getChildAt(i) as MovieClip;				
				if(m) resumeMc(m);
			}
			
			if(mc) mc.play();						
		}
		/**
		 *变成灰色 
		 * @param o
		 * @param flag
		 * 
		 */		
		public function makeGrey(o:DisplayObject,flag:Boolean):void
		{						
			var rLum:Number=0.2225;
			var gLum:Number=0.7169;
			var bLum:Number=0.0606;
			var matrix:Array=[rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, 0, 0, 0, 1, 0];				
			
			var Disable_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			var arr:Array = o.filters;
			var i:uint = 0;

			if (flag){				
				for (i = 0; i < arr.length; i++){
					if (arr[i] is ColorMatrixFilter){
						break;
					}
				}
				if (i == arr.length){
					arr.push(Disable_filter);
				}
			}else{
				for (i = 0; i < arr.length; i++){
					if (arr[i] is ColorMatrixFilter){
						arr.splice(i, 1);
						break;
					}
				}
			}								
			o.filters=arr;			
		}
		public function makeGrey2(o:DisplayObject,flag:Boolean):void
		{
			var cfilter:ColorMatrixFilter = new ColorMatrixFilter([0,0,0,0,0.5,0,0,0,0,0.5,0,0,0,0,0.5,0,0,0,1,0]);
			o.filters = flag ? [cfilter] : [];
		}
		
		
		/**
		 *删除所有子孩子 
		 * @param displayObj
		 * 
		 */		
		public function removeAllChild(displayObj:DisplayObjectContainer):void
		{
			while(displayObj.numChildren > 0)
			{
				displayObj.removeChildAt(0);
			}
		}
		
		
		public var textDropFilter:GlowFilter = new GlowFilter(0x002133,1,3,3,3,1); 
		
		/**
		 *获取可是对象的位图拷贝  
		 * @param displayObj
		 * @param w
		 * @param h
		 * @return 
		 * 
		 */
		public function getBitMapCopy(displayObj:DisplayObject,w:Number,h:Number):Bitmap{
			
			var bmpDataCopy:BitmapData;
			var bmpCopy:Bitmap;
			
			bmpDataCopy = new BitmapData(displayObj.width,displayObj.height,true,0);
			var bound:Rectangle = displayObj.getBounds(displayObj);
			var mat:Matrix = new Matrix;
			mat.tx = -bound.x;
			mat.ty = -bound.y;
			bmpDataCopy.draw(displayObj,mat);
			
			bmpCopy = new Bitmap(bmpDataCopy);
			bmpCopy.width = w;
			bmpCopy.height = h;
			return bmpCopy;
		}
		
		/**
		 * //垂线上指定距离的坐标点
		 * @param	cp 当前坐标点
		 * @param	angle 角度
		 * @param	len 距离
		 * @param	left 是否左边
		 */
		public function offsetPiontByAngel(cp:Point, angle:Number, len:Number,left:Boolean = true ):Point {
			
			var angleVer:Number;
			
			if (left) {
				angleVer = angle + 90;
				
			}else {
				angleVer = angle - 90;
			}
			var p:Point = setVectorByAngleAndLen(angleVer, len);
			
			var rp:Point = new Point();
			
			rp.x = cp.x + p.x;
			rp.y = cp.y + p.y;
			
			return rp;
		}
		
		private function setVectorByAngleAndLen(angle:Number, len:Number):Point {
			
			var radian:Number = angle / 180 * Math.PI;
			var point:Point = new Point();
			point.x = Math.cos(radian) * len;
			point.y = Math.sin(radian) * len;
			return point;
		}
		
		public function replaceObj(fakeObj:DisplayObject,realObj:DisplayObject,offsetX:Number = 0,offsetY:Number = 0):void
		{
			var parent:DisplayObjectContainer = fakeObj.parent;
			if(parent){
				var index:int = parent.getChildIndex(fakeObj); 
				parent.addChildAt(realObj,index);
				parent.removeChild(fakeObj);
			}
			realObj.x = fakeObj.x + offsetX;
			realObj.y = fakeObj.y + offsetY;
			
		}
		
		private var strokeFilter:GlowFilter = new GlowFilter();
		public function strokeTextField(tfl:TextField,color:uint = 0x7c2f19):void{
			var filters:Array= tfl.filters;
			strokeFilter.color = color;
			strokeFilter.blurX = 2;
			strokeFilter.blurY = 2;
			strokeFilter.strength = 10;
			filters.push(strokeFilter);
			tfl.filters = filters;
		}
		
		/**
		 * 动态自适应UI元素 
		 * @param elements
		 * 
		 */		
		public function repositionUIElements( gap:int, ...elements ):void
		{
			if ( elements && elements.length > 1 )
			{
				var posx:Number = elements[0].x;
				
				for ( var i:int=0, len:int=elements.length; i<len; i++ )
				{
					elements[i].x = posx;
					posx += elements[i].width + gap;
				}
			}
		}
		
		private var _blackBgs:Dictionary = new Dictionary();
				
		/**
		 * 面板出现消失特效 
		 * @param panel			面板
		 * @param centerOffset	面板的父容器的注册点	true在中心，false在左上角
		 * @param panelCenter	面板的注册点 		true在中心，false在左上角
		 * @param endCallBack	特效结束时回调
		 * 
		 */		
		public function panelAppear( panel:DisplayObject, centerOffset:Boolean=false, panelCenter:Boolean=true, endCallBack:Function=null ):void
		{
			if ( panel.parent )
			{
				var container:DisplayObjectContainer = panel.parent;
				
				if ( container.contains( panel ) )
				{
					container.removeChild( panel );
				}
				
				panel.visible = true;
				panel.alpha = 1;
				
				var bg:Sprite = _blackBgs[panel] as Sprite;
				
				if ( _blackBgs[panel] == null )
				{
					bg = _blackBgs[panel] = new Sprite();
					bg.graphics.beginFill( 0 );
					bg.graphics.drawRect( 0, 0, 760, 650 );
					bg.graphics.endFill();
					
				}
				container.addChild( bg );
				_blackBgs[panel] = bg;
				bg.alpha = 0;
				
				var matrix:Matrix = null;
				
				if ( panelCenter )
				{
					matrix = new Matrix();
					matrix.translate( 380, 325 );
				}
				
				if ( centerOffset )
				{
					bg.x = -380;
					bg.y = -325;
				}
				
				
				var bitmap:Bitmap = new Bitmap( new BitmapData( 760, 650, true, 0xFF0000 ) );					
				bitmap.bitmapData.draw( panel, matrix );
				container.addChild( bitmap );
				bitmap.alpha = 0;
				
				var step:int = 0;
				var speed:Number = 0.4;
				var speeds:Number = 0.2;
				panel.addEventListener( Event.ENTER_FRAME, 
					function( e:Event ):void
					{
						if ( step == 0 )
						{
							bg.alpha += 0.125;
							
							if ( bg.alpha >= 0.5 )
							{
								bitmap.alpha = 0.24;
								bitmap.scaleX = bitmap.scaleY = 0.7;
								bitmap.x = (centerOffset ? 0 : 380) - bitmap.width * 0.5;
								bitmap.y = (centerOffset ? 0 : 325) - bitmap.height * 0.5;
								step = 1;
							}
						}
						else
						{
							speed *= 0.7;
							speed = speed < 0.05 ? 0.05 : speed;
							speeds *= 0.7;
							speeds = speeds < 0.02 ? 0.02 : speeds;
							bitmap.alpha += speed;
							bitmap.scaleX = bitmap.scaleY += speeds;
							
							bitmap.x = (centerOffset ? 0 : 380) - bitmap.width * 0.5;
							bitmap.y = (centerOffset ? 0 : 325) - bitmap.height * 0.5;
							
							if ( bitmap.alpha >= 1 || bitmap.scaleY >= 1 )
							{
								container.addChild( panel );
								
								if ( container.contains( bitmap ) )
								{
									container.removeChild( bitmap );
								}
								bitmap.bitmapData.dispose();
								
								panel.removeEventListener( Event.ENTER_FRAME, arguments.callee );
								
								if ( endCallBack != null )
								{
									endCallBack();
								}
							}
						}
					}
				);
			}
		}
		
		/**
		 * 面板出现消失特效
		 * @param panel			面板
		 * @param centerOffset	见panelAppear
		 * @param panelCenter	面板注册点
		 * @param endCallBack	播放完时回调
		 * 
		 */		
		public function panelDisappear( panel:DisplayObject, centerOffset:Boolean=false, panelCenter:Boolean=true, endCallBack:Function = null ):void
		{
			if ( panel.parent )
			{
				var container:DisplayObjectContainer = panel.parent;
				
				if ( container.contains( panel ) )
				{
					container.removeChild( panel );
				}
				
				panel.visible = true;
				panel.alpha = 1;
			
				var bg:Sprite = _blackBgs[panel] as Sprite;
				
				if ( _blackBgs[panel] == null )
				{
					bg = _blackBgs[panel] = new Sprite();
					bg.graphics.beginFill( 0 );
					bg.graphics.drawRect( 0, 0, 760, 650 );
					bg.graphics.endFill();
					
				}
				container.addChild( bg );
				bg.alpha = 0.5;
				
				var matrix:Matrix = null;
				
				if ( panelCenter )
				{
					matrix = new Matrix();
					matrix.translate( 380, 325 );
				}
				
				if ( centerOffset )
				{
					bg.x = -380;
					bg.y = -325;					
				}
				
				var bitmap:Bitmap = new Bitmap( new BitmapData( 760, 650, true, 0xFF0000 ) );
				bitmap.bitmapData.draw( panel, matrix );
				container.addChild( bitmap );
				
				bitmap.x = (centerOffset ? 0 : 380) - bitmap.width * 0.5;
				bitmap.y = (centerOffset ? 0 : 325) - bitmap.height * 0.5;
				
				bitmap.alpha = 1;
				
				var step:int = 0;
				var speed:Number = 0.08;
				var speeds:Number = 0.04;
				panel.addEventListener( Event.ENTER_FRAME, 
					function( e:Event ):void
					{
						if ( step == 0 )
						{
							speed *= 1.1;
							speeds *= 1.1;
							bitmap.alpha -= speed;
							bitmap.scaleX = bitmap.scaleY -= speeds;
							
							bitmap.x = (centerOffset ? 0 : 380) - bitmap.width * 0.5;
							bitmap.y = (centerOffset ? 0 : 325) - bitmap.height * 0.5;
							
							if ( bitmap.alpha <= 0.24 || bitmap.scaleY <= 0.7 )
							{
								step = 1;
								
								if ( container.contains( bitmap ) )
								{
									container.removeChild( bitmap );
								}
								bitmap.bitmapData.dispose();								
							}
						}
						else
						{
							bg.alpha -= 0.1;
							
							if ( bg.alpha <= 0 )
							{
								if ( container.contains( bg ) )
								{
									container.removeChild( bg );
								}
								container.addChild( panel );
								
								panel.visible = false;
								panel.alpha = 0;
								
								_blackBgs[panel] = null;
								
								panel.removeEventListener( Event.ENTER_FRAME, arguments.callee );
								
								if ( endCallBack != null )
								{
									endCallBack();
								}
							}
						}
					}
				);
			}
		}
	}
}