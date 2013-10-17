package release.module.kylinFightModule.gameplay.oldcore.utils
{
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.getSize;
	import flash.utils.getTimer;
	
	public class MovieClipRasterizationUtil
	{
		private static const pt:Point = new Point();
		private static var rect:Rectangle;
		private static var realRect:Rectangle;
		private static var mt:Matrix = new Matrix();
		private static var emptyBitmapData:BitmapData = new BitmapData(1, 1, true, 0);
		
		public function MovieClipRasterizationUtil()
		{
			super();
		}
		
		/**
		 * 将mc cache为bitmapData数组
		 * @param mc 资源动画
		 * @param smoothing 是否平滑
		 * @return BitmapFrameInfo数组
		 */ 
		public static function rasterize(mc:MovieClip):Vector.<BitmapFrameInfo>
		{
//			var t:int = getTimer();
			
//			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
//			colorMatrixFilter.matrix = [1.1200000047683716,0,0,0,37.179996490478516,0,1.1200000047683716,0,0,37.179996490478516,0,0,1.1200000047683716,0,37.179996490478516,0,0,0,1,0];
//			mc.filters = [colorMatrixFilter];
			
			var bitmapFrameInfoArr:Vector.<BitmapFrameInfo>=new Vector.<BitmapFrameInfo>();
			var i:int;
			var n:int = mc.totalFrames;
			var lastBitmapFrameName:String = null;
			var bitmapFrameInfo:BitmapFrameInfo = null;
			for(i = 0; i< n; i++)
			{
				mc.gotoAndStop(i+1);
				bitmapFrameInfo = rasterizeCurrentFrame(mc, lastBitmapFrameName);
				lastBitmapFrameName = mc.currentLabel; 
				bitmapFrameInfoArr.push(bitmapFrameInfo);
			}
//			trace(getTimer() - t);
			return bitmapFrameInfoArr;
		}
		
		private static function rasterizeCurrentFrame(mc:MovieClip, lastFramName:String):BitmapFrameInfo
		{
			rect = mc.getBounds(mc);
			
			rect.x *= mc.scaleX;
			rect.y *= mc.scaleY;
			rect.width *= mc.scaleX;
			rect.height *= mc.scaleY;
			
			mt.a = mc.scaleX;
			mt.d = mc.scaleY;
			mt.tx = -rect.x;
			mt.ty = -rect.y;
			
			var bitmapData:BitmapData = null;
			
			//防止空白帧报错
			if(rect.isEmpty())
			{
				bitmapData = emptyBitmapData;
			}
			else
			{
				//截图
				bitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x000000);
				bitmapData.draw(mc, mt);
				
				//剔除透明边界, 这里一定是整数
				realRect = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
				
				if(!realRect.isEmpty() && 
					(bitmapData.width + bitmapData.height - realRect.width - realRect.height > 20))
				{
					var realBitData:BitmapData = new BitmapData(Math.ceil(realRect.width), Math.ceil(realRect.height), true, 0x000000);
					realBitData.copyPixels(bitmapData, realRect, pt);
					
					bitmapData.dispose();
					bitmapData = realBitData;

					rect.x += realRect.x;
					rect.y += realRect.y;
				}
			}
			
			var btmapFrameInfo:BitmapFrameInfo = new BitmapFrameInfo();
			btmapFrameInfo.bitmapData= bitmapData;
			if(mc.currentLabel != lastFramName)
			{
				btmapFrameInfo.name = mc.currentLabel;
			}
			btmapFrameInfo.frame = mc.currentFrame;
			
//			trace(rect);
			btmapFrameInfo.x = Math.ceil(rect.x);
			btmapFrameInfo.y = Math.ceil(rect.y);
			
			return btmapFrameInfo;
		}
		
		public static function rasterizeNew(ptTraceSize:Point,mc:MovieClip,scale:Number = 1,ioVecInfos:Vector.<BitmapFrameInfo> = null,startFrameName:Object=null,endFrameName:Object=null):Vector.<BitmapFrameInfo>
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
		
		private static var pot:Point = new Point;
		private static function rasterizeCurrentFrameNew(mc:MovieClip, lastFramName:String,scale:Number = 1):BitmapFrameInfo
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
		
		public static function rasterizeCurrentFrameToBitmap(mc:MovieClip,bitInfo:BitmapFrameInfo,scale:Number = 1):void
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