package com.dull 
{
	/**
	 * ...
	 * @author longying.zhang
	 */
	 
	import com.dull.genes.evoEyeGene;
	import com.dull.genes.evoGene;
	import com.dull.genes.evoNormalFireGene;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import flash.geom.Point;
	import flash.events.TimerEvent;
	
 
	 
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import Box2D.Dynamics.Joints.*;
	


	
	public class evoCannon extends Sprite
	{
		
		public function evoCannon(level:evoLevel,posGridNum) 
		{
			
			_level = level;
			_view = new CannoView();
			this.addChild(_view);
			_firePos = new FirePos();
			_firePos.x = 20;
			_firePos.y = 0;
			this.addChild(_firePos);
			_firePos.visible = false;

			
			_epbar = new  cannon_ep_view();
			_epbar.x = -10;
			_epbar.y = 10;
			//_level.addView(_epbar);
			this.addChild(_epbar);
			
			_wait_time_bar = new cannon_view_time();
			_wait_time_bar.x = -10;
			_wait_time_bar.y = 0;
			this.addChild(_wait_time_bar);
			_wait_time_bar.stop();
			
			_fire_harm_baar = new canno_fire_harm();
			_fire_harm_baar.x = -10;
			_fire_harm_baar.y = -20;
			_fire_harm_baar.stop();
			this.addChild(_fire_harm_baar);

			
			_pos_grid_num = posGridNum;
		
			_cannon_wating_timer.addEventListener(TimerEvent.TIMER, waitingTimer);
			_cannon_wating_timer.stop();
			
			_ep_timer.addEventListener(TimerEvent.TIMER, epTimerHandle);
			_ep_timer.start();
			
			
			//_eye_gene = new evoEyeGene(this,_level);
			
			_main_fire_gene = new evoNormalFireGene(this, _level);
			
			var nameNum:int = Math.random() * 10000;
			
			_canno_name+= nameNum;
			_name_txt.text = _canno_name;
			_name_txt.selectable = false;
			//_level.addView(_name_txt);

			
			
		}
		
		
		


		
		//发炮后的等待时间
		public function waitingTimer(e:Event){			

			
			//trace("the waiting time +", _waiting_time);
			_waiting_time+= 0.1;
			
			_wait_time_bar.gotoAndStop(int(11 * _waiting_time / _max_waiting_time));
		}
		
		public function epTimerHandle(e:Event)
		{
			
			
			_ep_reduce_time_counter += 0.1;
			
			if(_ep_reduce_time_counter>=_ep_reduce_time){
				
				_ep_reduce_time_counter = 0;
				_ep--;
			}
		}
		
	
		
		public function addEp(num:Number){
			
			this._ep += num;
			
			if(this._ep>100){
				this._ep = 100;     
				
				
			}
		}
		
		
		public function getViewObj():DisplayObject{
			
	
			
			return _view;
		}
		
		public function update(deltaTime:int):void{
			
			//	
			
		
			//更新ep bar
		
			_epbar.gotoAndStop( int(_ep/10));
			
			_name_txt.x = this.x;
			_name_txt.y = this.y + 20;
			
			
			_fire_harm_baar.gotoAndStop(_main_fire_gene._gene_level > 5?5:_main_fire_gene._gene_level);
			
			
			//ep Check
			
			if(_ep<=0){
				setStatus('deathing');
			}
			
			//进入繁殖状态
			if(_ep>=100&&_status!='reproducing'){
				
				setStatus('reproducing');
				_view.gotoAndPlay(16);

			}
			
			
			
	
			
			//不同的状态不同的update
			if('birthing'==_status){
				
				
				birthing(deltaTime);
			}
			else if('growing'==_status){
				
				growing(deltaTime);
				
			}
			else if("finding"==_status){
				
				finding(deltaTime);
				
			}
			else if("firing"==_status){
				
				firing(deltaTime);
				
			}
			
			else if ("waiting" == _status) {
				
				waiting(deltaTime);
				
				
			}
			else if("reproducing"==_status){
				
				reproducing(deltaTime);				
				
			}
			else if("deathing"==_status){
				
				deathing(deltaTime);
				
				_ep = 0;
				_level.deleteCannon(this)
			}
			
			
		}
		
		/*
		 * 
		 * birthing 刚出生的时候，不可见。
		 * growing  生长阶段，目前的设计仅仅为了播放长大动画。
		 * finding 寻找目标的状态，此状态会调整炮的方向.
		 * firing 开炮，播放开炮动画
		 * waiting 等待状态，完毕后进入finding状态.
		 * reproducing 繁殖状态.完成后进入finding 状态.
		 * deathing 死亡，播放死亡动画
		 */
		
		//出生状态的update函数
		public function birthing(deltaTime:int):void{
			
			this.visible = false;
			this._epbar.visible = false;
			
			
		}
		
		public function growing(deltaTime:int):void{
			
			setStatus("finding");
			
			this.visible = true;
			this._epbar.visible = true;
			
			
		}
		
		
		public function finding(deltaTime:int):void{
			
			
			if(_eye_gene!=null){
				
				_eye_gene.finding();
				if(_eye_bar_view==null){
					
					_eye_bar_view = new cannon_eye_view();
					this.addChild(_eye_bar_view);
				}
				
			}
			else{
				
				setStatus("firing");
				
			}
			
		}
		
		public function waiting(deltaTime:int):void{
			
			
			if(_waiting_time>_max_waiting_time){
				setStatus("finding");
				_cannon_wating_timer.stop();
				_waiting_time = 0;
			}
			
		}
		
		public function firing(deltaTime:int):void{			
			
			//trace("firing");
			//fire();
			//setStatus("waiting");
			//_cannon_wating_timer.start();
			_main_fire_gene.firing();
		
		}
		
		public function reproducing(deltaTime:int):void{
			
						
			//播放完繁殖动画
			if (_view.currentFrame == 25) {
				
				c_child = birthNextG();
				if(c_child){
					c_child.setStatus('birthing');
					createSeed();
					_seed.seek(new b2Vec2(c_child.x, c_child.y));
					_level.addView(_seed)
				}
				
			}
			
			
			if(_seed){
				
				_seed.update(deltaTime);
				
				if(_seed.getView().currentFrame==14){
					
					c_child.setStatus('growing');
					c_child.visible = true;
					c_child._epbar.visible = true;
					_level.delView(_seed);
					_seed = null;
					c_child = null;
					setStatus('finding');

				}
			}		
			
		}
		
		public function deathing(deltaTime:int){
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		public function setIsSelected(s:Boolean){
			
			_isSelected = s;
			_frameCounter = 0;
		}
		public function setClear(clear:Boolean = true){
			
			_isNeedClear = true;
		}
		
		
		public function isNeedClear():Boolean{
			
			return _isNeedClear;
		}
				
		
		//获得编号位置
		public function getPosGridNum():Number{
			
			
			return _pos_grid_num;
		}
		
		
		public function setCannonFahter(fahter:evoCannon){
			
			
			_fatherCannon = fahter;
		}
		
		public function getCannonFather():evoCannon{
			
			
			return _fatherCannon;
		}
			
		public function setEp(ep:Number){
			
			_ep = ep;
			
		}
		
		
		public function birthNextG():evoCannon{
			
			
			var n_child = _level.createCannon(this);
			this.setEp(50);
			
			return n_child;
		}
		
		public function setStatus(b:String='normal'){
			
			_status = b;
			
		}
		
		public function createSeed(){
			
			_seed = new evoSeed();
			
			_seed.x = this.x;
			_seed.y = this.y;
	
			
		}
		
		
		
		public function getIntroOfGene():String{
			
			var str:String = "";
			
			if(_eye_gene){
				str += _eye_gene.getIntro();
			}
			return str;
				
		}
		
		
		public function powerOfGene(){
			
			for (var i:int = 0; i<_power_genes.length; i++){
				
				_power_genes[i].init_gene();
				
			}
			
		}
		
		public var _torward:Number;
		
		
		public var _view:MovieClip;
		
		public var _level:evoLevel;
		public var _bulletSpeed:Number = 5;
		public var _firePos:DisplayObject;
		public var _epbar:MovieClip;
		
		public var _wait_time_bar:MovieClip;
		
		public var _fire_harm_baar:MovieClip;
		
		public var _eye_bar_view:MovieClip;
		
		
		public var _ep = 50;
		
		public var _frameCounter = 0;
		
		public var _isSelected = false;
		
		public var _isNeedClear:Boolean = false;
		
		public var _pos_grid_num = 0;
		
		public var _fatherCannon:evoCannon;
		
		
		//三种 状态 zero finding normal birth reproduce
		/*
		 * 炮的生命周期为
		 * birthing 刚出生的时候，不可见。
		 * growing  生长阶段，目前的设计仅仅为了播放长大动画。
		 * finding 寻找目标的状态，此状态会调整炮的方向.
		 * fire 开炮，播放开炮动画
		 * waiting 等待状态，完毕后进入finding状态.
		 * reproducing 繁殖状态.完成后进入finding 状态.
		 * deathing 死亡播放死亡动画
		 * 
		 */
		public var _status:String = "birthing";
		
		public var _seed:evoSeed;
		
		public var c_child:evoCannon;
		
		public var _cannon_wating_timer:Timer = new Timer(100, 0);
		
		public var _waiting_time:Number = 0;
		
		public var _max_waiting_time:Number = 2; //以秒为单位
		
		
		public var _ep_timer:Timer = new Timer(100, 0);
		
		public var _ep_reduce_time_counter = 0;
		public var _ep_reduce_time:Number = 1;
		
		
		public var _fire_range = 5;
		
		
		public var _eye_gene:evoEyeGene;
		
		public var _main_fire_gene:evoGene;
		
		public var _power_genes:Array = new Array();
		
		public var _canno_name:String = "cannon ";
		
		public var _name_txt:TextField = new TextField();
		
		public var _canno_bullet_harm = 50;

		
	}

}