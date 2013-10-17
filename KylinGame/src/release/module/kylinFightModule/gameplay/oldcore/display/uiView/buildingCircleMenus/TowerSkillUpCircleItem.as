package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import release.module.kylinFightModule.gameplay.oldcore.core.ILifecycleObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.skill.SkillTemplateInfo;
	import framecore.structure.model.user.tower.TowerData;
	import framecore.structure.model.user.tower.TowerInfo;
	import framecore.tools.tips.ToolTipEvent;
	import framecore.tools.tips.towerMenu.TowerMenuToolTip;
	import framecore.tools.tips.towerMenu.TowerMenuToolTipDataVO;

	public class TowerSkillUpCircleItem extends BasicBuildingCircleItem implements ILifecycleObject
	{
		private var _skillTemp:SkillTemplateInfo;
		private var _skillId:uint;
		private var _lvl:int = 0;
		private var _towerId:uint = 0;
		
		public function TowerSkillUpCircleItem(skillId:uint,towerId:uint,
												clickCallback:Function,
											   buildingCircleMenu:BasicBuildingCircleMenu)
		{
			super(clickCallback, buildingCircleMenu);
			_skillId = skillId;
			_towerId = towerId;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
		}
		
		//激活
		public function notifyLifecycleActive():void
		{
			if(0 == _skillId)
			{
				_skillTemp = null;
				setIsLock(true);
				//myItemBGView.gotoAndStop("lock");
				myItemBGView.itemTextSkin.visible = false;
				updateUIByCurrentState();
				return;
			}
			var info:TowerInfo = TowerData.getInstance().getTowerInfoByTowerId(_towerId);
			if(info && -1 == info.skillIds.indexOf(_skillId.toString()))
			{
				_skillTemp = TemplateDataFactory.getInstance().getSkillTemplateById(_skillId);	
				_lvl = -1;
				setIsLock(false);
				setIsEnable(false);
				myItemBGView.itemTextSkin.visible = false;
				myItemBGView.gotoAndStop("TS_"+_skillId);	
				(myItemBGView.getChildByName("skillstate") as MovieClip).visible = false;
				updateUIByCurrentState();
				return;
			}
			
			_lvl = 0;
			_skillTemp = TemplateDataFactory.getInstance().getSkillTemplateById(_skillId);	
			setIsLock(false);
			myItemBGView.itemTextSkin.visible = true;
			myItemBGView.gotoAndStop("TS_"+_skillId);	
			(myItemBGView.getChildByName("skillstate") as MovieClip).visible = true;
			(myItemBGView.getChildByName("skillstate") as MovieClip).gotoAndStop(1);
			myItemBGView.itemTextSkin.goldTextField.text = _skillTemp.buyGold.toString();
			updateUIByCurrentState();
		}
		
		override protected function onShowToolTipHandler(event:ToolTipEvent):void
		{
			var data:TowerMenuToolTipDataVO = new TowerMenuToolTipDataVO();
			if ( myIsLock )
			{
				data.status = TowerMenuToolTip.STATUS_LOCKED;
			}
			else
			{
				var info:TowerInfo = TowerData.getInstance().getTowerInfoByTowerId(_towerId);
				
				var lv:int = _lvl;
				var skillTmp:SkillTemplateInfo = TemplateDataFactory.getInstance().getSkillTemplateById( _skillId );
				data.towerName = skillTmp.getName() + (lv == 0 ? "" : lv == 1 ? "I" : lv == 2 ? "II" : lv == 3 ? "III" : "" );
				data.desText = skillTmp.getDesc();
				data.status = myIsEnable ? (lv > 3 ? TowerMenuToolTip.STATUS_FULL_LV : TowerMenuToolTip.STATUS_UPGRADE)
					: (info && info.skillIds.indexOf(_skillId.toString()) == -1 ) ? TowerMenuToolTip.STATUS_NOT_RESEARCH
					: TowerMenuToolTip.STATUS_MATERIALS_NOT_ENOUGH;
			}
			
			event.toolTip.data = data;
		}
		
		//冻结
		public function notifyLifecycleFreeze():void
		{
			
		}
		
		public function notifySceneGoldUpdate():void
		{
			checkIsValideByMoney();
		}
		
		public function setSkillId(id:uint):void
		{
			_skillId = id;
		}
		
		private function checkIsValideByMoney():void
		{
			if(_lvl<3 && _lvl>=0 && _skillId != 0)
				this.setIsEnable(GameAGlobalManager.getInstance().gameDataInfoManager.sceneGold >= _skillTemp.buyGold);
		}
		
		override protected function onShow():void
		{
			super.onShow();
			checkIsValideByMoney();
		}
		
		override protected function excuteClickCallback():void
		{
			if(_lvl>=3)  
				return;
			++_lvl;
			GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneGold(-_skillTemp.buyGold);
			GameAGlobalManager.getInstance().gameFightInfoRecorder.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_UPGRADE_TOWER_SKILL, _skillId );
			
			(myItemBGView.getChildByName("skillstate") as MovieClip).gotoAndStop(1+_lvl);
			if(_lvl<3)
			{
				_skillTemp = TemplateDataFactory.getInstance().getSkillTemplateById(uint(_skillId.toString()+_lvl));
				myItemBGView.itemTextSkin.goldTextField.text = _skillTemp.buyGold.toString();
				checkIsValideByMoney();
			}
			else
				myItemBGView.itemTextSkin.goldTextField.text = "Max";
			
			myClickCallback(_skillId,_lvl);	
		}
		
		override protected function updateUIByCurrentState():void
		{
			super.updateUIByCurrentState();
			
			if(myIsEnable)
			{
				TextField(myItemBGView.itemTextSkin.goldTextField).textColor = 0xFFFF00;
			}
			else
			{
				TextField(myItemBGView.itemTextSkin.goldTextField).textColor = 0x999999;
			}
		}
		
		override public function isClickToDisfocusBuilding():Boolean
		{
			return false;
		}
	}
}