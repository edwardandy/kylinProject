package utili.behavior.appear
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IAppear;
	import utili.behavior.interfaces.IAppearBehavior;
	import utili.behavior.interfaces.IDispose;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class AppearAlphaScale extends Behavior implements IAppearBehavior 
	{
		
		/**
		 * 出现
		 */
		public function appear():void
		{
			_mPanel.mouseChildren = true;
			_mPanel.mouseEnabled = true;
			_mPanel.visible = true;
			_mPanel.alpha = 0;
			_mPanel.scaleX = _mPanel.scaleY = 0.01;
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
			
			
		}
		
	}

}