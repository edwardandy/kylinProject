package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	import com.greensock.TweenLite;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GraphicsUtil;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchSubWaveVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchWaveVO;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import framecore.main.TextDataManager;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.monster.MonsterTemplateInfo;
	import framecore.tools.getText;
	import framecore.tools.tips.ToolTipConst;
	import framecore.tools.tips.ToolTipEvent;
	import framecore.tools.tips.ToolTipManager;

	public class MarchMonsterFlag extends BasicView
	{
		private static const GAP:Number = 5;
		
		private var _marchMonsterFlagBg:MarchMonsterFlagBg;
		private var _flagMask:Shape;
		private var _heartBeatTween:TweenLite;
		
		private var _arrowAngle:Number = 0;
		private var _flyable:Boolean = false;
		
		public var roadIdx:int;
		
		public function MarchMonsterFlag()
		{
			super();
			
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
		/**
		 * 设置下一波怪是否可飞行 
		 * @param value
		 * 
		 */		
		public function set flyable( value:Boolean ):void
		{
			_flyable = value;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_marchMonsterFlagBg = new MarchMonsterFlagBg();
			addChild(_marchMonsterFlagBg);
			_flagMask = new Shape;
			_marchMonsterFlagBg.addChild(_flagMask);
			_marchMonsterFlagBg.flag.mask = _flagMask;
			
			ToolTipManager.getInstance().registGameToolTipTarget( this, ToolTipConst.MARCH_MONSTER );
			this.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTip );
		}
		
		protected function showTip(event:ToolTipEvent ):void
		{
			// TODO Auto-generated method stub
			//var data:String = TextDataManager.getInstance().getPanelConfigXML("tip").marchMonster + " [Z]";
			var data:Array = [];
			try
			{
				var wave:MonsterMarchWaveVO = GameAGlobalManager.getInstance().gameDataInfoManager.getNextWaveVO();
			}
			catch(e:Error)
			{
				return;
			}
			if(!wave)
				return;
			
			for(var monsterId:* in wave.waveMonsterSumInfos[roadIdx])
			{
				var temp:MonsterTemplateInfo = TemplateDataFactory.getInstance().getMonsterTemplateById(monsterId);
				if(!temp)
					continue;
				var name:String = temp.getName();
				var cnt:int = wave.waveMonsterSumInfos[roadIdx][monsterId];
				data.push(/*(data.length>0?"\n":"")+*/name+" * "+cnt);
			}

			event.toolTip.data = data;
		}
		
		private function onHeartBeatTweenEndHandler():void
		{
			_heartBeatTween.reverse();
		}
		
		private function onHeartBeatTweenReverseEndHandler():void
		{
			_heartBeatTween.play();
		}
		
		override protected function onAddToStage():void
		{
			var xFrom:Number = 0;
			var yFrom:Number = 0;
			var xTo:Number = 0;
			var yTo:Number = 0;
			
			_marchMonsterFlagBg.wing.visible = _flyable;
			
			if(_arrowAngle >= 45 && _arrowAngle < 135)
			{
				_marchMonsterFlagBg.arrow.gotoAndStop("down");
				
				xFrom = 0;
				yFrom = -GAP;
				xTo = 0;
				yTo = GAP;
			}
			else if(_arrowAngle >= 135 && _arrowAngle < 225)
			{
				_marchMonsterFlagBg.arrow.gotoAndStop("left");
				
				xFrom = GAP;
				yFrom = 0;
				xTo = -GAP;
				yTo = 0;
			}
			else if(_arrowAngle >= 225 && _arrowAngle < 315)
			{
				_marchMonsterFlagBg.arrow.gotoAndStop("top");
				
				xFrom = 0;
				yFrom = GAP;
				xTo = 0;
				yTo = -GAP;
			}
			else
			{
				_marchMonsterFlagBg.arrow.gotoAndStop("right");
				
				xFrom = -GAP;
				yFrom = 0;
				xTo = GAP;
				yTo = 0;
			}
			
			_marchMonsterFlagBg.x = xFrom;
			_marchMonsterFlagBg.y = yFrom;
			
			if(_heartBeatTween != null)
			{
				_heartBeatTween.kill();
				_heartBeatTween = null;
			}
			
			_heartBeatTween = TweenLite.to(_marchMonsterFlagBg, 0.4, 
				{
					x:xTo, y:yTo,
					paused:true, 
					onComplete:onHeartBeatTweenEndHandler,
					onReverseComplete:onHeartBeatTweenReverseEndHandler
				});
			
			_heartBeatTween.restart();
			drawFlagMask(0);
		}
		
		override protected function onRemoveFromStage():void
		{
			super.onRemoveFromStage();
			
			_heartBeatTween.kill();
			_heartBeatTween = null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeChild(_marchMonsterFlagBg);
			_marchMonsterFlagBg = null;
		}
		
		//这里要分成4个方向就可以了
		public function setArrowRotation(value:Number):void
		{
			_arrowAngle = GameMathUtil.adjustRadianBetween0And360(value);
		}
		
		public function setProgress(value:Number):void
		{
			value = GameMathUtil.adjustProgressValue(value);
			//_marchMonsterFlagBg.flag.gotoAndStop(int(value * 100));
			drawFlagMask(value);
		}
		
		private function drawFlagMask(value:Number):void
		{
			_flagMask.graphics.clear();
			_flagMask.graphics.beginFill(0xffffff);
			if(0 == value)
				_flagMask.graphics.drawCircle(0,0,30);
			else
				GraphicsUtil.drawSector(_flagMask.graphics,0,0,30,360*(1-value),360*value-90);
			_flagMask.graphics.endFill();
		}
	}
}