package mainModule.controller.netCmds.httpCmds.cmds
{
	import mainModule.controller.netCmds.httpCmds.HttpCmd;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	import mainModule.service.netServices.httpServices.HttpRequestDataFormat;

	/**
	 * 请求游戏初始化的后台数据 
	 * @author Edward
	 * 
	 */	
	public class HttpGameInitCmd extends HttpCmd
	{
		[Inject]
		public var heroData:IHeroDynamicDataModel;
		
		public function HttpGameInitCmd()
		{
			super();
		}
		
		override protected function initRequestParam():void
		{
			super.initRequestParam();
			requestParam.vecData.push(new HttpRequestDataFormat("game","init",[]));
			requestParam.bVirtual = true;
			requestParam.bNeedRespon = true;
		}
		
		override protected function request():void
		{
			super.request();
		}
		
		override protected function get virtualResponData():Array
		{
			var dynamicData:Object = {};
			//携带的英雄
			heroData.arrHeroIdsInFight.length = 0;
			heroData.arrHeroIdsInFight.push(180001,180002,180003);
			var heroObj:Object = {};
			dynamicData[DynamicDataNameConst.HeroData] = heroObj;
			heroObj.dynamicItems = {180001:{id:180001,level:1},180002:{id:180002,level:1},180003:{id:180003,level:1}};
			//拥有的魔法
			var magicObj:Object = {};
			dynamicData[DynamicDataNameConst.MagicSkillData] = magicObj;
			magicObj.dynamicItems = {210101:{id:210101,level:1},210401:{id:210401,level:1},210701:{id:210701,level:1}};
			//拥有的塔
			var towerObj:Object = {};
			dynamicData[DynamicDataNameConst.TowerData] = towerObj;
			towerObj.dynamicItems = {111001:{id:111001,level:1},112007:{id:112007,level:1},113013:{id:113013,level:1},114019:{id:114019,level:1}};
			towerObj.towerLevels = {1:1,2:1,3:1,4:1};
			//拥有的道具
			var itemObj:Object = {};
			dynamicData[DynamicDataNameConst.ItemData] = itemObj;
			itemObj.dynamicItems = {1000001:{id:1000001,itemId:131063,num:99},1000002:{id:1000002,itemId:131127,num:99}
				,1000003:{id:1000003,itemId:131124,num:99},1000004:{id:1000004,itemId:131125,num:99}};
			
			return [{dynamic:dynamicData}];
		}
	}
}