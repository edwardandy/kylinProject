package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import com.shinezone.towerDefense.fight.manager.applicationManagers.GamePreloadResMgr;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.item.ItemData;
	import framecore.structure.model.user.item.ItemInfo;
	import framecore.structure.model.user.item.ItemTemplateInfo;
	import framecore.tools.GameStringUtil;
	
	public class ItemPreLoad extends BasicPreLoad
	{
		public function ItemPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var itemTemp:ItemTemplateInfo = TemplateDataFactory.getInstance().getItemTemplateById(id);
			if(!itemTemp)
				return;
			
			if(1 == itemTemp.effectType)
			{
				var param:Object = GameStringUtil.deserializeString(itemTemp.effectValue);
				if(param && param.hasOwnProperty("magic"))
					preloadMagicRes(param.magic);
			}
		}
	}
}