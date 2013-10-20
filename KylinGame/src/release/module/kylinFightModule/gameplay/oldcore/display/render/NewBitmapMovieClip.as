package release.module.kylinFightModule.gameplay.oldcore.display.render
{
	import flash.display.Bitmap;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import io.smash.time.IRenderAble;
	import io.smash.time.TimeManager;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	
	/**
	 * 此类为战斗系统，场景元素动画实现部分的核心类。
	 * 采用Spriet + Bitmap + BitmapData 的方式实现，并提供了类似MovieClip的对动画的操作方式
	 *  
	 * @author Administrator
	 * 
	 */	
	public final class NewBitmapMovieClip extends Sprite implements IRenderAble, IDisposeObject
	{
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		[Inject]
		public var timeMgr:TimeManager;
		
		private var _bitmapFrameInfos:Vector.<BitmapFrameInfo>;
		private var _frameNames:Dictionary = new Dictionary;
		private var _bitmap:Bitmap;
		
		private var _currentFrame:int = 1;
		private var _totalFrame:int = 0;
		
		private var _loopTimes:int = -1;
		private var _fromFrame:int = 1;
		private var _toFrame:int = 1;
		
		private var _midleCareFrame:int = -1;//-1表示无效

		private var _playMiddleCareCallback:Function = null;//在此区间还有个帧需要关注
		private var _playEndCallback:Function = null;
		
		
		private var _isPlaying:Boolean = false;
		private var _isCurrentFrameRendered:Boolean = false;
		
		private var _tempCurrentFrameInfo:BitmapFrameInfo = null;
		
		private var _arrSrcUrl:Array;//["url1","url2",...]
		private var _arrScaleRatio:Array;//[1,2,...]
		private var _curUrlIdx:int = 0;
		private var _dicLableToUrl:Dictionary = new Dictionary(true);
		
		private var _iFirstFrameWidth:int;
		private var _iFirstFrameHeight:int;
				
		//appendBitmapFrameInfos 为附加动画数据，可以为空
		public function NewBitmapMovieClip(arrSource:Array,arrScale:Array = null)
		{		
			super();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_arrSrcUrl = arrSource;
			_arrScaleRatio = (arrScale || []);
			_totalFrame = 0;	
			_currentFrame = 1;
			
			_bitmap = new Bitmap();
			addChild(_bitmap);
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			genFrameNames();
		}
		
		public function get iFirstFrameHeight():int
		{
			return _iFirstFrameHeight;
		}
		
		public function get iFirstFrameWidth():int
		{
			return _iFirstFrameWidth;
		}
		
		private function genFrameNames():void
		{
			if(!_arrSrcUrl || 0 == _arrSrcUrl.length)
				return;
	
			for each(var url:String in _arrSrcUrl)
			{
				var mc:MovieClip = objPoolMgr.getMCByUrl(url);
				if(mc)
				{
					_totalFrame += mc.totalFrames;
					
					mc.gotoAndStop(1);
					mc.mouseChildren = false;
					mc.mouseEnabled = false;
					_iFirstFrameWidth ||= mc.width;
					_iFirstFrameHeight ||= mc.height;
					for each(var label:FrameLabel in mc.currentLabels)
					{
						if(null == _frameNames[label.name])
						{
							_frameNames[label.name] = label;
							_dicLableToUrl[label.name] = url;
						}
					}
				}
			}
		}
		
		public function totalFrames():int
		{
			return _totalFrame;
		}
		
		public function hasFrameName(name:String):Boolean
		{
			return null != _frameNames[name];
		}
		
		public function getFrameByName(name:String):int
		{
			if(null == _frameNames[name])
				return -1;
			return (_frameNames[name] as FrameLabel).frame;
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
			if(frame == null || !_bitmapFrameInfos) return null;
			
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
					if(_tempCurrentFrameInfo && _tempCurrentFrameInfo.name == frame)
					{
						return _tempCurrentFrameInfo;
					}
				}
			}
			
			return null;
		}
		
		public function render(iElapse:int):void
		{
			if(!_isCurrentFrameRendered)//如果当前帧已经渲染过，则不再渲染
			{
				_isCurrentFrameRendered = true;
				
				//inner Render
				_tempCurrentFrameInfo = ((null!=_bitmapFrameInfos)?_bitmapFrameInfos[_currentFrame - 1]:null);
				if(null == _tempCurrentFrameInfo)
				{
					if(_arrSrcUrl[_curUrlIdx] == "OrganismSkillBuffer_221021")
						var gaojian:int =0;
					_bitmapFrameInfos = objPoolMgr.getNewBitmapFrameInfos(_arrSrcUrl[_curUrlIdx],_arrScaleRatio[_curUrlIdx],_currentFrame);
					if(!_bitmapFrameInfos)
					{
						throw(new Error("getNewBitmapFrameInfos Error! url:"+_arrSrcUrl[_curUrlIdx]+" curFrame:"+_currentFrame));
						return;
					}
					_tempCurrentFrameInfo = _bitmapFrameInfos[_currentFrame - 1];
					if(null == _tempCurrentFrameInfo)
						return;
				}
				
				if(null == _tempCurrentFrameInfo.bitmapData)
				{
					objPoolMgr.rasterizeCurFrameInfo(_arrSrcUrl[_curUrlIdx],_arrScaleRatio[_curUrlIdx],_currentFrame);
				}
				_bitmap.bitmapData = _tempCurrentFrameInfo.bitmapData;
				_bitmap.x = _tempCurrentFrameInfo.x;
				_bitmap.y = _tempCurrentFrameInfo.y;
				//--
				
				if(_midleCareFrame > 0 && 
					_currentFrame == _midleCareFrame && 
					_playMiddleCareCallback != null)
				{
					timeMgr.callLater(_playMiddleCareCallback);
					//_playMiddleCareCallback();
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
								timeMgr.callLater(nowPlayEndCallback);
								//nowPlayEndCallback();
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
		public function gotoAndPlay2(fromFrame:Object, toFrame:Object,
									 loopTimes:int = -1, 
									 playEndCallback:Function = null,
									 middelCareFrame:Object = null, middleCareFrameCallback:Function = null,
									 offsetFrame:int = -1):void
		{
			var fromFrameInfo:BitmapFrameInfo = getFrameInfo(fromFrame);
			var toFrameInfo:BitmapFrameInfo = getFrameInfo(toFrame);
			
			if(fromFrameInfo == null || toFrameInfo == null)
			{
				var url:String = fromFrame is String?_dicLableToUrl[fromFrame]:_arrSrcUrl[0];
				if(!url)
				{
					if(playEndCallback != null)
						playEndCallback();
					return;
				}
				_curUrlIdx = _arrSrcUrl.indexOf(url);
				_bitmapFrameInfos = objPoolMgr.getNewBitmapFrameInfos(url,_arrScaleRatio[_curUrlIdx],fromFrame,toFrame);
			}
			
			fromFrameInfo = getFrameInfo(fromFrame);
			toFrameInfo = getFrameInfo(toFrame);
			
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
			if(_tempCurrentFrameInfo == null)
			{
				var url:String = (frame is String)?_dicLableToUrl[frame]:_arrSrcUrl[0];
				if(!url)
					return;
				_curUrlIdx = _arrSrcUrl.indexOf(url);
				_bitmapFrameInfos = objPoolMgr.getNewBitmapFrameInfos(url,_arrScaleRatio[_curUrlIdx],frame);
				_tempCurrentFrameInfo = getFrameInfo(frame);
				if(_tempCurrentFrameInfo == null)
					return;
			}

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
			_currentFrame = 1;			
			_fromFrame = 1;
			_toFrame = 1;
			_midleCareFrame = -1;
			_isCurrentFrameRendered = false;
			_curUrlIdx = 0;
			
			_tempCurrentFrameInfo = null;
			_playEndCallback = null;
			_playMiddleCareCallback = null;
		}
		
		//IDisposeObject Interface
		public function dispose():void
		{
			_arrSrcUrl = null;
			_arrScaleRatio = null;//[1,2,...]
			_dicLableToUrl = null;
			
			_iFirstFrameWidth = 0;
			_iFirstFrameHeight = 0;
			
			_tempCurrentFrameInfo = null;
			
			_isPlaying = false;
			_isCurrentFrameRendered = true;
			
			_loopTimes = -1;
			_currentFrame = 1;
			//_totalFrame = 1;
			_fromFrame = 1;
			_toFrame = 1;
			
			//这里只是切除引用，bitmapFrameInfos由单独类去ObjectPoolManager.dispose
			_bitmapFrameInfos = null;
			
			_playEndCallback = null;
			_playMiddleCareCallback = null;
			
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