package release.module.kylinFightModule.gameplay.oldcore.display.uiView.TreasureBoxOpen
{	
	import com.greensock.TweenLite;
	import com.shinezone.core.structure.controls.GameEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import framecore.structure.controls.battleCommand.Battle_CMD_Const;
	import framecore.structure.model.constdata.GameConst;
	import framecore.structure.model.constdata.HttpConst;
	import framecore.structure.model.constdata.IconConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.item.ItemData;
	import framecore.structure.model.user.item.ItemTemplateInfo;
	import framecore.structure.model.varMoudle.GameVar;
	import framecore.structure.views.mapPanel.components.BezierTween;
	import framecore.tools.icon.IconUtil;
	import framecore.tools.logger.log;
	import framecore.tools.txts.TextFlyEffect;
	import framecore.tools.txts.TextFlyEffectMgr;

	public class OpenTreasureBoxEff
	{
		//金币,
		private static const GOOD_POSITION:Point = new Point(80,30);
		private static const ITEM_POSITION:Point = new Point(700,590);
		
		private var _itemId:uint;
		private var _num:int;
		private var _idx:int;
		private var _icon:Sprite;
		private var _startPt:Point;
		private var _endPt:Point;
		private var _itemInfo:ItemTemplateInfo;
		
		public function OpenTreasureBoxEff(id:uint,cnt:int,ix:int,iy:int,idx:int)
		{
			_itemInfo = TemplateDataFactory.getInstance().getItemTemplateById(id);
			if(!_itemInfo)
			{
				log("OpenTreasureBoxEff no item info: "+id);
				return;
			}
			_itemId = id;
			_num = cnt;
			_idx = idx;
			_startPt = new Point(ix,iy);
			init();
		}
		
		private function init():void
		{
			initIconContent();
			scaleIcon();
			
		}
		
		private function initIconContent():void
		{
			_icon = new Sprite;
			_icon.mouseChildren = false;
			_icon.mouseEnabled = false;
			_icon.x = _startPt.x;
			_icon.y = _startPt.y;
			_icon.scaleX = _icon.scaleY = 0;
			IconUtil.loadIcon(_icon,IconConst.ICON_TYPE_ITEM,_itemId,IconConst.ICON_SIZE_SMALL, ".png", false );
			GameAGlobalManager.getInstance().game.addChild(_icon);
		}
		
		private function scaleIcon():void
		{
			TweenLite.to(_icon,0.5,{scaleX:1,scaleY:1,rotation:720,onComplete:flyIcon});
		}
		
		private function flyIcon():void
		{
			new BezierTween(_icon,0.8,_startPt,getFlyTweenCP(),_endPt,{onComplete:onIconFlyEnd});
		}
		
		private function getFlyTweenCP():Point
		{
			var itemTempInfo:ItemTemplateInfo = TemplateDataFactory.getInstance().getItemTemplateById(_itemId);
			_endPt = getEndPosByType(itemTempInfo.effectType);
			var cp:Point = new Point((_startPt.x + _endPt.x) / 2,(_startPt.y + _endPt.y) / 2);
			var signX:int = _endPt.x > _startPt.x ? 1 : -1;
			var signY:int = _endPt.y > _startPt.y ? -1 : 1;
			cp.x += signX * 150 * Math.random();
			cp.y += signY * 150 * Math.random();
			return cp;
		}
		
		private function getEndPosByType(type:int):Point
		{
			switch(type)
			{
				case 5:
					return GameVar.coinSpPos;
				case 10:
					return GameVar.diamondSpPos;
				case 13:
					return GOOD_POSITION;
				default:
					return ITEM_POSITION;
			}
		}
		
		private function onIconFlyEnd():void
		{
			var itemTempInfo:ItemTemplateInfo = TemplateDataFactory.getInstance().getItemTemplateById(_itemId);
			var name:String;
			switch(itemTempInfo.effectType)
			{
				case 5:
					name = "Gold + ";
					UserData.getInstance().userBaseInfo.uGold += _num;
					break;
				case 10:
					name = "Diamond + ";
					UserData.getInstance().userBaseInfo.uMoney += _num;
					break;
				case 13:
					name = "Goods + ";
					GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneGold(_num);
					break;
				default:
					name = itemTempInfo.getName()+" + ";
					ItemData.getInstance().putItemIds([_itemId],_num);
					break;
			}
			
			//new TextFlyEffect(name + _num,_icon.parent,_icon.x,_icon.y);
			TextFlyEffectMgr.instance.genTextFlyEffect(name + _num,_icon.parent,_icon.x,_icon.y);
			_icon.parent && _icon.parent.removeChild(_icon);
			
			GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_TREASURE_DROP, [HttpConst.HTTP_REQUEST, _idx, GameAGlobalManager.getInstance().gameDataInfoManager.gameFightId]);
		}
	}
}