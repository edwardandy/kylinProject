package release.module.kylinFightModule.model.interfaces
{
	
	import kylin.echo.edward.gameplay.IKylinGameManager;

	/**
	 * 战斗场景数据 
	 * @author Edward
	 * 
	 */	
	public interface ISceneDataModel extends IKylinGameManager
	{
		/**
		 * 场景类型 :SceneTypeConst常量值
		 * @return 
		 * 
		 */		
		function get sceneType():int;
		/**
		 * 场景总生命值 
		 * @return 
		 * 
		 */		
		function get sceneTotalLife():int;
		/**
		 * 场景当前生命值 
		 * @return 
		 * 
		 */		
		function get sceneLife():int;
		function set sceneLife(value:int):void;
		/**
		 * 场景当前物资数 
		 * @return 
		 * 
		 */		
		function get sceneGoods():int;
		function set sceneGoods(value:int):void;
	}
}