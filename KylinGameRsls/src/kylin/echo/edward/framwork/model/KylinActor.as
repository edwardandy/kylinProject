package kylin.echo.edward.framwork.model
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	
	public class KylinActor 
	{
		/**
		 * @private
		 */
		protected var _eventDispatcher:IEventDispatcher;
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		
		public function KylinActor()
		{
		}
		
		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		[Inject]
		/**
		 * @private
		 */
		public function set eventDispatcher(value:IEventDispatcher):void
		{
			_eventDispatcher = value;
		}
		
		/**
		 * Dispatch helper method
		 *
		 * @param event The <code>Event</code> to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
		 */
		protected function dispatch(event:Event):Boolean
		{
			if(eventDispatcher.hasEventListener(event.type))
				return eventDispatcher.dispatchEvent(event);
			return false;
		}
	}
}