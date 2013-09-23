package utili.behavior.disappear
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IDisappear;
	import utili.behavior.interfaces.IDisappearBehavior;
	import utili.behavior.interfaces.IDispose;
	
	/**
	 * ...透明度消失
	 * @author MAY
	 */
	public class DisappearAlpha extends Behavior implements IDisappearBehavior
	{
		[Inject]
		public var _configData:IConfigDataModel;
		/**
		 * 消失
		 */
		public function disappear():void
		{
			
			_mPanel.mouseChildren = false;
			_mPanel.mouseEnabled = false;
			_nFactor = _mPanel.alpha;
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
			_mPanel.removeEventListener(Event.ENTER_FRAME, onMoveHandler);
			super.dispose();
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onMoveHandler(e:Event):void
		{
			var _iTime:int = getTimer();
			var _nTimeDistance:Number = (_iTime - _iOldTime) / 1000;
			//临时距离
			var _nTempDistance:Number = _configData.nPanelAlphaVelocity * _nTimeDistance;
			_iOldTime = _iTime;
			if (_nFactor > _nTempDistance)
			{
				_nFactor -= _configData.nPanelAlphaVelocity * _nTempDistance;	
				_mPanel.alpha = _nFactor;
			}
			else
			{
				_nFactor = 0;
				_mPanel.visible = false;
				_mPanel.removeEventListener(Event.ENTER_FRAME, onMoveHandler);
				_mPanel.alpha = _nFactor;
				appearCB();
			}			
		}
		
	}

}