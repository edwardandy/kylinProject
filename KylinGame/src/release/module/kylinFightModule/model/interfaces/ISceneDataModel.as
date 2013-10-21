package release.module.kylinFightModule.model.interfaces
{
	
	import kylin.echo.edward.gameplay.IKylinGameManager;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.IFightLifecycle;
	import release.module.kylinFightModule.gameplay.oldcore.vo.map.SceneElementVO;

	/**
	 * 战斗场景数据 
	 * @author Edward
	 * 
	 */	
	public interface ISceneDataModel extends IKylinGameManager,IFightLifecycle
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
		/**
		 * 场景初始元素，比如塔基 
		 * @return 
		 * 
		 */		
		function get sceneInitElementsVo():Vector.<SceneElementVO>;
		/**
		 * 场景初始元素，比如塔基 
		 * @param data
		 * 
		 */		
		function updateSceneElements(data:XML):void;
		/**
		 * 更新场景物资
		 * @param value
		 * 
		 */		
		function updateSceneGold(value:int):void;
		/**
		 * 更新场景生命
		 * @param value
		 * 
		 */		
		function updateSceneLife(value:int):void;
		/**
		 * 更新场景积分 
		 * 
		 */		
		function updateSceneScore():void;
	}
}