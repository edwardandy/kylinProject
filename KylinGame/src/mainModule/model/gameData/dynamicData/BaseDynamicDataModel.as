package mainModule.model.gameData.dynamicData
{
	import kylin.echo.edward.framwork.model.KylinActor;
	import kylin.echo.edward.utilities.datastructures.FillObjectUtil;
	
	import mainModule.controller.gameData.GameDataUpdateEvent;
	
	/**
	 * 后台保存的游戏动态数据 
	 * @author Edward
	 * 
	 */	
	public class BaseDynamicDataModel extends KylinActor
	{
		/**
		 * 数据对应的id 
		 */		
		protected var dataId:String;
		/**
		 * 数据更新时派送的事件类型 
		 */		
		protected var updateEventType:String;
		
		public function BaseDynamicDataModel()
		{
			super();
		}
		/**
		 * 填充更新自身数据 
		 * @param value
		 * 
		 */		
		public function beFilled(value:Object):void
		{
			if(FillObjectUtil.fillObj(this,value) && updateEventType)
				dispatch(new GameDataUpdateEvent(updateEventType));
		}
	}
}