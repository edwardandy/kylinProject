package utili.behavior.appear
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IAppearBehavior;
	
	/**
	 * ...透明度出现
	 * @author MAY
	 */
	public class AppearAlpha extends Behavior implements IAppearBehavior
	{
		[Inject]
		public var _configData:IConfigDataModel;
		/**
		 * 出现
		 */
		public function appear():void
		{
			_mPanel.mouseChildren = true;
			_mPanel.mouseEnabled = true;
			_mPanel.visible = true;
			//_nFactor = 0;
			_mPanel.alpha = _nFactor;
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
		 * 移动
		 * @param	e
		 */
		private function onMoveHandler(e:Event):void
		{
			var _iTime:int = getTimer();
			var _nTimeDistance:Number = (_iTime - _iOldTime) / 1000;
			//临时距离
			var _nTempDistance:Number = _configData.nPanelAlphaVelocity * _nTimeDistance;
			_iOldTime = _iTime;
			if (_nFactor < 1 - _nTempDistance)
			{
				_nFactor += _nTempDistance;
				_mPanel.alpha = _nFactor;
			}
			else
			{
				_nFactor = 1;
				_mPanel.removeEventListener(Event.ENTER_FRAME, onMoveHandler);
				_mPanel.alpha = _nFactor;
				appearCB();
			}
			
			
		}
		
	}

}