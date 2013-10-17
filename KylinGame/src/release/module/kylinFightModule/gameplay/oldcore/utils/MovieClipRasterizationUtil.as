package release.module.kylinFightModule.gameplay.oldcore.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	
	public class MovieClipRasterizationUtil
	{
		private const pt:Point = new Point();
		private var rect:Rectangle;
		private var realRect:Rectangle;
		private var mt:Matrix = new Matrix();
		private var emptyBitmapData:BitmapData = new BitmapData(1, 1, true, 0);
		private var pot:Point = new Point;
		
		public function MovieClipRasterizationUtil()
		{
			super();
		}
		
		public function rasterizeNew(ptTraceSize:Point,mc:MovieClip,scale:Number = 1,ioVecInfos:Vector.<BitmapFrameInfo> = null,startFrameName:Object=null,endFrameName:Object=null):Vector.<BitmapFrameInfo>
		{	
			var bitmapFrameInfoArr:Vector.<BitmapFrameInfo>= (ioVecInfos || new Vector.<BitmapFrameInfo>(mc.totalFrames));
			var i:int;
			var n:int = mc.totalFrames;
			var lastBitmapFrameName:String = null;
			var bitmapFrameInfo:BitmapFrameInfo = null;
			var bAtLast:Boolean = false;
			var bAtFirst:Boolean = false;
			ptTraceSize.x = 0;
			/*if(1 == startFrameName)//初始化第一帧
			{
				n = 1;
			}*/
			for(i = 0; i< n; i++)
			{
				mc.gotoAndStop(i+1);
				
				if(startFrameName)
				{
					if(!endFrameName)
					{
						if((startFrameName is String && mc.currentLabel == startFrameName)
							||(startFrameName is int && i+1 == startFrameName))
							bAtLast = true;
						else
							continue;
					}
					else
					{
						if(!bAtFirst && ((startFrameName is String && mc.currentLabel != startFrameName)
							||(startFrameName is int && i+1 != startFrameName)))
							continue;
						else if(!bAtFirst && ((startFrameName is String && mc.currentLabel == startFrameName)
						||(startFrameName is int && i+1 == startFrameName)))
							bAtFirst = true;
						else if((startFrameName is String && mc.currentLabel == endFrameName) 
							||(startFrameName is int && i+1 == endFrameName))
							bAtLast = true;
					}
				}
				if(null == bitmapFrameInfoArr[i])
				{
					bitmapFrameInfo = rasterizeCurrentFrameNew(mc, lastBitmapFrameName,scale);
					bitmapFrameInfoArr[i] = bitmapFrameInfo;
					//ptTraceSize.x += getSize(bitmapFrameInfo.bitmapData);
				}
				lastBitmapFrameName = mc.currentLabel; 
				
				if(bAtLast)
					break;
			}
			return bitmapFrameInfoArr;
		}
		
		private function rasterizeCurrentFrameNew(mc:MovieClip, lastFramName:String,scale:Number = 1):BitmapFrameInfo
		{	
			var bitInfo:BitmapFrameInfo = new BitmapFrameInfo();
			if(mc.currentLabel != lastFramName)
			{
				bitInfo.name = mc.currentLabel;
			}
			bitInfo.frame = mc.currentFrame;
			
			//rasterizeCurrentFrameToBitmap(mc,bitInfo,scale);
			
			return bitInfo;
		}
		
		public function rasterizeCurrentFrameToBitmap(mc:MovieClip,bitInfo:BitmapFrameInfo,scale:Number = 1):void
		{
			if(!mc || !bitInfo)
				return;
			
			var rect:Rectangle = mc.getBounds(mc);
			var x:int = Math.round(rect.x * scale);
			var y:int = Math.round(rect.y * scale);
			
			if (rect.isEmpty())
			{
				rect.width = 1;
				rect.height = 1;
			}
			
			var bitData:BitmapData = new BitmapData(Math.ceil(rect.width * scale), Math.ceil(rect.height * scale), true, 0);
			bitData.draw(mc, new Matrix(scale, 0, 0, scale, -x, -y), null, null, null, true);
			
			//查找非空白区域
			var colorBoundsRect:Rectangle = bitData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			
			if (!colorBoundsRect.isEmpty() && (bitData.width != colorBoundsRect.width || bitData.height != colorBoundsRect.height))
			{				
				var colorBoundsBitmapData:BitmapData = new BitmapData(colorBoundsRect.width, colorBoundsRect.height, true, 0);
				colorBoundsBitmapData.copyPixels(bitData, colorBoundsRect, pot);
				
				bitData.dispose();
				bitData = colorBoundsBitmapData;
				x += colorBoundsRect.x;
				y += colorBoundsRect.y;				
			}
			
			bitInfo.x = x;
			bitInfo.y = y;
			bitInfo.bitmapData = bitData;
		}
	}
}