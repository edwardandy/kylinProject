package utili.behavior.appear
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
	import mainModule.model.gameConstAndVar.ConfigDataModel;
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IAppear;
	import utili.behavior.interfaces.IAppearBehavior;
	import utili.behavior.interfaces.IDispose;
	
	/**
	 * ...缩放出现
	 * @author MAY
	 */
	public class AppearScale extends Behavior implements IAppearBehavior
	{
		[Inject]
		public var _configData:IConfigDataModel;

		/**
		 * 动画阶段
		 */
		private var _iFlag:int;
		
		/**
		 * 变换矩阵
		 */
		private var _mtx:Matrix;
		
		/**
		 * 原始x坐标
		 */
		private var _nOriginalX:Number;
		
		/**
		 * 原始y坐标
		 */
		private var _nOriginalY:Number;
		
		/**
		 * 构造函数
		 */
		public function AppearScale() 
		{
			_mtx = new Matrix;
		}
		
		/**
		 * interface
		 * appear behavior
		 */
		public function appear():void
		{
			_nOriginalX = _mPanel.x;
			_nOriginalY = _mPanel.y;
			_mPanel.mouseChildren = false;
			_mPanel.mouseEnabled = false;
			_nFactor = 0.01;
			_mPanel.scaleX = _mPanel.scaleY = _nFactor;
			_mPanel.alpha = 1;
			_mPanel.visible = true;
			//得到老时间
			_iOldTime = getTimer();
			_mPanel.addEventListener(Event.ENTER_FRAME, onMoveHandler);
		}
		
		/**
		 * 停止动作
		 */
		public function stopAction():void
		{
			_mPanel.removeEventListener(Event.ENTER_FRAME, onMoveHandler);
		}
		
		/**
		 * 销毁
		 */
		override public function dispose():void
		{
			super.dispose();
		}
		
		/**
		 * 时间侦听器
		 * @param	e
		 */
		private function onMoveHandler(e:Event):void
		{	
			var _iTime:int = getTimer();
			var _nTimeDistance:Number = (_iTime - _iOldTime) / 1000;
			//临时距离
			var _nTempDistance:Number = _configData.nPanelScaleVelocity * _nTimeDistance;
			_iOldTime = _iTime;
			if (_iFlag == 0)
			{
				if (_nFactor < _configData.nPanelMaxScale - _nTempDistance) _nFactor += _nTempDistance;
				else
				{
					_nFactor = _configData.nPanelMaxScale;
					_iFlag = 1;
				}
			}
			else
			{
				if (_nFactor > 1 + _nTempDistance * .1) _nFactor -= _nTempDistance * .1;
				else
				{
					//default setting
					_mtx.identity();
					_mtx.tx = _nOriginalX;
					_mtx.ty = _nOriginalY;
					_mPanel.transform.matrix = _mtx;
					_nFactor = 1;
					_mPanel.mouseChildren = true;
					_mPanel.mouseEnabled = true;		
					_mPanel.removeEventListener(Event.ENTER_FRAME, onMoveHandler);
					_iFlag = 0;
					appearCB();
					return;
				}
			}
			_mtx.identity();
			_mtx.translate( -_mPanel.stage.stageWidth>>1, -_mPanel.stage.stageHeight>>1);
			_mtx.scale(_nFactor, _nFactor);
			_mtx.translate( _mPanel.stage.stageWidth>>1 + _nOriginalX, _mPanel.stage.stageHeight>>1 + _nOriginalY);
			_mPanel.transform.matrix = _mtx;
			_mPanel.alpha = _nFactor;
		}
		
	}

}
