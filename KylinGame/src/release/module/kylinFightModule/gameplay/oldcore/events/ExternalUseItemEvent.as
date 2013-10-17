package release.module.kylinFightModule.gameplay.oldcore.events
{
	import flash.events.Event;
	
	/**
	 * 外部途径使用道具事件
	 * @author Jiao Zhongxiao
	 * @date   2013-7-31
	 *
	 */
	public class ExternalUseItemEvent extends Event
	{
		public static const USE_ITEM:String = "ExternalUseItemEventUseItem";
		
		public var id:uint = 0;
		
		public function ExternalUseItemEvent( type:String, id:uint )
		{
			super(type, false, false);
			this.id = id;
		}
	}
}