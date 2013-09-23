package kylin.echo.edward.framwork
{
	import flash.events.Event;
	
	import org.robotlegs.utilities.modular.base.IModuleEvent;
	
	public class KylinEvent extends Event implements IModuleEvent
	{
		public function KylinEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}