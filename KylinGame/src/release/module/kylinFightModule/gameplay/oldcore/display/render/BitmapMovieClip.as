package release.module.kylinFightModule.gameplay.oldcore.display.render
{
    import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
    import release.module.kylinFightModule.gameplay.oldcore.core.IRenderAble;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.utils.getTimer;

	/**
	 * 此类为战斗系统，场景元素动画实现部分的核心类。
	 * 采用Spriet + Bitmap + BitmapData 的方式实现，并提供了类似MovieClip的对动画的操作方式
	 *  
	 * @author Administrator
	 * 
	 */	
    public final class BitmapMovieClip extends Sprite implements IRenderAble, IDisposeObject
    {
        private var _bitmapFrameInfos:Vector.<BitmapFrameInfo>;
		private var _frameNames:Array = [];
        private var _bitmap:Bitmap;

        private var _currentFrame:int = 1;
		private var _totalFrame:int = 1;
		
		private var _loopTimes:int = -1;
		private var _fromFrame:int = 1;
		private var _toFrame:int = 1;
		
		private var _midleCareFrame:int = -1;//-1表示无效
		
		private var _playMiddleCareCallback:Function = null;//在此区间还有个帧需要关注
		private var _playEndCallback:Function = null;
		
		
		private var _isPlaying:Boolean = false;
		private var _isCurrentFrameRendered:Boolean = false;

		private var _tempCurrentPlayEndCallback:Function = null;
		private var _tempCurrentFrameInfo:BitmapFrameInfo = null;
		
		//上一次停止时当前帧里开始帧的偏移量
//		private var _lastStopTimeFromFrameToToFrameOffSet:int = -1;
		
		//appendBitmapFrameInfos 为附加动画数据，可以为空
        public function BitmapMovieClip(sourceBitmapFrameInfos:Vector.<BitmapFrameInfo>, 
										appendBitmapFrameInfos:Vector.<BitmapFrameInfo> = null)
        {
            super();

			this.mouseChildren = false;
			this.mouseEnabled = false;

            _bitmapFrameInfos = sourceBitmapFrameInfos.concat();
			genFrameNames();
			_totalFrame = _bitmapFrameInfos.length;
			
			if(appendBitmapFrameInfos != null && appendBitmapFrameInfos.length > 0)
			{
				var n:uint = appendBitmapFrameInfos.length;
				for(var i:uint = 0; i < n; i++)
				{
					var appendBitmapFrameInfo:BitmapFrameInfo = appendBitmapFrameInfos[i];
					var bitmapFrameInfo:BitmapFrameInfo = new BitmapFrameInfo();
					bitmapFrameInfo.x = appendBitmapFrameInfo.x;
					bitmapFrameInfo.y = appendBitmapFrameInfo.y;
					bitmapFrameInfo.name = appendBitmapFrameInfo.name;
					bitmapFrameInfo.bitmapData = appendBitmapFrameInfo.bitmapData;
					bitmapFrameInfo.frame = appendBitmapFrameInfo.frame + _totalFrame;
					_bitmapFrameInfos.push(bitmapFrameInfo);
				}
				
				_totalFrame += n;
			}
			
            if(_totalFrame == 0) throw new Error("BitmapMovieClip::BitmapMovieClip empty frame");
			
			_currentFrame = 1;

			_bitmap = new Bitmap();
			addChild(_bitmap);
//test			
//			this.cacheAsBitmap = true;
//			graphics.beginFill(0xFF0000);
//			graphics.drawCircle(0, 0, 2);
//			graphics.endFill();
        }
		
		private function genFrameNames():void
		{
			if(!_bitmapFrameInfos || 0 == _bitmapFrameInfos.length)
				return;
			for each(var info:BitmapFrameInfo in _bitmapFrameInfos)
			{
				if(info.name && _frameNames.indexOf(info.name) == -1)
					_frameNames.push(info.name);
			}
		}
		
		public function hasFrameName(name:String):Boolean
		{
			return _frameNames.indexOf(name) != -1;
		}
			
		
		//MovieClip Interface
		//是否处于播放状态
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		//当前帧
		public final function get currentFrame():int
		{
			return _currentFrame;
		}
		
		//当前总帧数
		/*public final function get totalFrame():int
		{
			return _totalFrame;
		}*/
		
		public function set smoothing(value:Boolean):void
		{
			_bitmap.smoothing = value;
		}
		
		//获取当前帧的，帧信息，参数可以是FrameLabel 或 FrameIndex
		public final function getFrameInfo(frame:Object):BitmapFrameInfo
		{
			if(frame == null) return null;
			
			if(frame is Number)
			{
				var validFrame:int = int(frame);
				if(validFrame < 1 || validFrame > _bitmapFrameInfos.length) return null;
				else return _bitmapFrameInfos[validFrame -1];
			}
			else if(frame is String)
			{
				for each(_tempCurrentFrameInfo in _bitmapFrameInfos)
				{
					if(_tempCurrentFrameInfo.name == frame)
					{
						return _tempCurrentFrameInfo;
					}
				}
			}
			
			return null;
		}
		
        //IRenderAble
		public function update(iElapse:int):void
		{
			/*if(!_isCurrentFrameRendered)//如果当前帧已经渲染过，则不再渲染
			{					
				if(_midleCareFrame > 0 && 
					_currentFrame == _midleCareFrame && 
					_playMiddleCareCallback != null)
				{
					_playMiddleCareCallback();
				}
				
				if(_loopTimes > 0)
				{
					if(_currentFrame == _toFrame)
					{
						_loopTimes--;
						if(_loopTimes <= 0)
						{
							//innerstop
							_loopTimes = -1;
							_isPlaying = false;
							
							//这里要获取引用不然会有问题
							var nowPlayEndCallback:Function = _playEndCallback;
							
							_playEndCallback = null;
							_playMiddleCareCallback = null;
							
							if(nowPlayEndCallback != null)
							{
								nowPlayEndCallback();
								nowPlayEndCallback = null;
							}				
							return;
						}
					}
				}
			}*/
		}
			
        public function render(iElapse:int):void
        {
			if(!_isCurrentFrameRendered)//如果当前帧已经渲染过，则不再渲染
			{
				_isCurrentFrameRendered = true;

				//inner Render
				_tempCurrentFrameInfo = _bitmapFrameInfos[_currentFrame - 1];
				_bitmap.bitmapData = _tempCurrentFrameInfo.bitmapData;
				_bitmap.x = _tempCurrentFrameInfo.x;
				_bitmap.y = _tempCurrentFrameInfo.y;
				//--
				
				if(_midleCareFrame > 0 && 
					_currentFrame == _midleCareFrame && 
					_playMiddleCareCallback != null)
				{
					_playMiddleCareCallback();
				}
				
				if(_loopTimes > 0)
				{
					if(_currentFrame == _toFrame)
					{
						_loopTimes--;
						if(_loopTimes <= 0)
						{
							//innerstop
							_loopTimes = -1;
							_isPlaying = false;
							
							//这里要获取引用不然会有问题
							var nowPlayEndCallback:Function = _playEndCallback;
							
							_playEndCallback = null;
							_playMiddleCareCallback = null;
							
							if(nowPlayEndCallback != null)
							{
								nowPlayEndCallback();
								nowPlayEndCallback = null;
							}				
							return;
						}
					}
				}
			}
			
			if(_isPlaying)
			{
				innerNextFrame(_loopTimes != 1);
			}
        }

		//不支持环状循环脚本，fromFrame 必须 <= toFrame
		//offsetFrame为便宜量，一般很少用到
		public function gotoAndPlay2(fromFrame:String, toFrame:String,
									 loopTimes:int = -1, 
									 playEndCallback:Function = null,
									 middelCareFrame:Object = null, middleCareFrameCallback:Function = null,
									 offsetFrame:int = -1):void
		{
			var fromFrameInfo:BitmapFrameInfo = getFrameInfo(fromFrame);
			var toFrameInfo:BitmapFrameInfo = getFrameInfo(toFrame);
			
			if(fromFrameInfo == null ||
				toFrameInfo == null ||
				fromFrameInfo.frame > toFrameInfo.frame)
			{
				if(playEndCallback != null)
					playEndCallback();
				return;
			}
			
			_fromFrame = fromFrameInfo.frame;
			_toFrame = toFrameInfo.frame;

			//只有MiddleCareCallback存在_midleCareFrame才有意义
			if(middleCareFrameCallback != null)
			{
				var middleCareFrameInfo:BitmapFrameInfo = getFrameInfo(middelCareFrame);
				if(middleCareFrameInfo != null)
				{
					_midleCareFrame = middleCareFrameInfo.frame;
				}
				else
				{
					_midleCareFrame = -1;
					middleCareFrameCallback = null;
				}
			}
			else
			{
				_midleCareFrame = -1;
			}

			_loopTimes = loopTimes;
			
			_playMiddleCareCallback = middleCareFrameCallback;
			_playEndCallback = playEndCallback;
			
			if(_fromFrame == _toFrame)
			{
				_loopTimes = 1;
				//没有意义
				_midleCareFrame = -1;
				_playMiddleCareCallback = null;
			}
			else//小于
			{
				if(_loopTimes < 1)//表示无限循环
				{
					_playEndCallback = null;//不会有结束的时候
				}
			}
			
			var readToStartFrame:int = _fromFrame;
			
			if(offsetFrame > 0 && offsetFrame < _fromFrame - _toFrame)
			{
				readToStartFrame += offsetFrame;
			}
			
			if(_currentFrame != readToStartFrame)
			{
				_currentFrame = readToStartFrame;
				_isCurrentFrameRendered = false;
			}
			
			_isPlaying = true;
		}
		
		//指定渲染某一帧，并停止当前的播放状态
		public function gotoAndStop2(frame:Object = null):void
		{
			_isPlaying = false;

			_loopTimes = -1;
			_fromFrame = 1;
			_toFrame = 1;
			_midleCareFrame = -1;

			_playEndCallback = null;
			_playMiddleCareCallback = null;
			
			_tempCurrentFrameInfo = getFrameInfo(frame);
			if(_tempCurrentFrameInfo == null) return;

			if(_currentFrame != _tempCurrentFrameInfo.frame)
			{
				_currentFrame = _tempCurrentFrameInfo.frame;
				_isCurrentFrameRendered = false;
			}
		}
		
		//清除当前播放信息
		public function clear():void
		{
			_loopTimes = -1;
			_isPlaying = false;
			
			_playEndCallback = null;
			_playMiddleCareCallback = null;
			_tempCurrentPlayEndCallback = null;
		}
		
		//IDisposeObject Interface
		public function dispose():void
		{
			_tempCurrentFrameInfo = null;
			
			_isPlaying = false;
			_isCurrentFrameRendered = true;
			
			_loopTimes = -1;
			_currentFrame = 1;
			_totalFrame = 1;
			_fromFrame = 1;
			_toFrame = 1;
			
			//这里只是切除引用，bitmapFrameInfos由单独类去ObjectPoolManager.dispose
			_bitmapFrameInfos = null;
			
			_playEndCallback = null;
			_playMiddleCareCallback = null;
			_tempCurrentPlayEndCallback = null;
			
			removeChild(_bitmap);
			_bitmap.bitmapData = null;
			_bitmap = null;
		}

		private function innerNextFrame(loop:Boolean):void
		{
			var lastCurrentFrame:int = _currentFrame;
			_currentFrame++;
			validateAndAdjustCurrentFrame(loop);
			if(lastCurrentFrame != _currentFrame) _isCurrentFrameRendered = false;
		}
		
		//fromFrame 和 toFrame 必须是在范围1-_bitmapFrameInfos.length，fromFrame <= toFrame且 这个逻辑一定会保证的
		private function validateAndAdjustCurrentFrame(loop:Boolean):void
		{
			if(_currentFrame < _fromFrame) _currentFrame = _fromFrame;
			else if(_currentFrame > _toFrame) _currentFrame = loop ? _fromFrame : _toFrame;
		}
    }
}