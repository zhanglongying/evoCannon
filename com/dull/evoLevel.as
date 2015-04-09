package com.dull 
{
	/**
	 * ...
	 * @author longying.zhang
	 */
	
	import com.dull.waves.evoVortexBossWave;
	import com.dull.waves.evoVortexWave;
	import com.dull.waves.evoWalkWave;
	import com.dull.waves.evoWave;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
 
	 
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
	
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import com.dull.genes.*;
	import com.dull.waves.*;
	
	public class evoLevel extends evoGameState
	{
		
		public function evoLevel() 
		{
			
		}
		
		public override function Init(){
			
			
			
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0,0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			m_world = new b2World(gravity, doSleep);
			m_world.SetGravity(gravity);
			m_world.SetContactListener(_contactListener);

			initDebugDraw();
			//createCircle(400/pixel_per_meter, 400/pixel_per_meter, 5);
			

			
			
			
			Main.gameMain._mainStage.addEventListener(MouseEvent.MOUSE_DOWN, selectCannon);
			Main.gameMain._mainStage.addEventListener(MouseEvent.MOUSE_MOVE, turnCannon);
			
			//init info view
			cannoInfo = new CannoInfoView();
			cannoInfo.x = 260;
			cannoInfo.y = 444;
			cannoInfo.visible = false;
			this.addView(cannoInfo);
			
			
			//for test ai angent
			
			testEnemy = createEnemy(200, 200);
			
			testEnemy.seek(new b2Vec2(300 / pixel_per_meter, 300 / pixel_per_meter));
			
						

			//
			_action_bar.x = 400;
			_action_bar.y = 30;
			addView(_action_bar);
			
			addView(_txt);
			
			_ap_not_enough_bar = new ap_not_enough();
			_ap_not_enough_bar.x = 400;
			_ap_not_enough_bar.y = 300;
			_ap_not_enough_bar.stop();
			_ap_not_enough_bar.visible = false;
			addView(_ap_not_enough_bar);
			_txt.x = 600;
			_txt.y = 50;
			_txt.textColor = 0xff0000;
			_txt.wordWrap = true;
			_txt.height = 100;
			_txt.width = 300;			
			
			
			init_gene_config();
			
			
			
			
			initCannonPosAndCannon();
			initWave();
			
			setStatus("wave_waiting");


		}
		
		
		public function initWave(){
			
						
			_waves_list = new Array();
			_waves_list.push(new evoVortexWave (this))
			_waves_list.push(new evoWalkWave(this))

			//_cur_wave =_waves_list[0] ;
			//_cur_wave.init();
			_boss_wave = new evoVortexBossWave(this);
			
		}
		
		
		
		public function initCannonPosAndCannon(){
			
			
						
			//位置网格网格
			for (var m:Number = 0; m < 1600;m++ ){
				
				_cannon_pos_array.push(m);
			}
			
			for (var n:Number = 0; n < 4;n++ ){
				createCannon();
			
			}
			
		}
		
		
		public function selectCannon(e:MouseEvent){
			
			//trace(e.target);
			
			
			
			
			if (e.target is CannoView) {
				
				if(_action_power>25){
					selectedCannon = e.target.parent;
					e.target.gotoAndPlay(11);
				
					if(cannoInfo.currentFrame==1){
						cannoInfo.gotoAndPlay(2);
					}
					//selectedCannon.fire();
					selectedCannon.setIsSelected (true);
					cannoInfo.ep1.gotoAndStop(selectedCannon._ep);
					//trace(t1);
					//_txt.text = "abc";
					//selectedCannon.setEp(100);
				
					_action_power -= 25;
					pause();
				}
				else{
					
					_ap_not_enough_bar.play();
					_ap_not_enough_bar.visible = true;
					
				}

			}
			else{
				if(selectedCannon!=null){
					selectedCannon.setIsSelected (false);
					unpause();
				}
				selectedCannon = null;
				if(cannoInfo.currentFrame!=1){
					cannoInfo.gotoAndPlay(10);
				}

			}
		//
			//testEnemy.stopAllTask();
			//testEnemy.walk(new b2Vec2( Main.gameMain._mainContainer.mouseX / pixel_per_meter, Main.gameMain._mainContainer.mouseY / pixel_per_meter));
			
			//testCannon.fire();
			
		}
	
		public function turnCannon(e:MouseEvent):void{
			
			
			if (selectedCannon!=null) {
				
				
				
				var dx:Number = Main.gameMain._mainContainer.mouseX - selectedCannon.x;
				var dy:Number = Main.gameMain._mainContainer.mouseY - selectedCannon.y;		
				selectedCannon.rotation =Math.atan2(dy,dx)*180/Math.PI;				
				
			
			}
			
			testEnemy.seek(new b2Vec2( Main.gameMain._mainContainer.mouseX / pixel_per_meter, Main.gameMain._mainContainer.mouseY / pixel_per_meter));
			
			//testEnemy.seek(new b2Vec2( Main.gameMain._mainContainer.mouseX / pixel_per_meter, Main.gameMain._mainContainer.mouseY / pixel_per_meter));

		}
	
		
		
		public override function update(deltaTime:int){
			
			
			if(_isPause){
				
				return;
			}
			
			//trace("inLevel update!");
			m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			m_world.ClearForces();
			m_world.DrawDebugData();

			//testCannon.update(deltaTime);
		
			for (var i:Number = 0; i < liveCannons.length; i++){
			
				liveCannons[i].update(deltaTime);
			
			
			}
			
			
			for (var i:Number = 0; i < bulletsArray.length; i++){
			
				bulletsArray[i].update(deltaTime);
			
			
			}
			
			
			for (var i:Number = 0; i < enemiesArray.length; i++){
			
				enemiesArray[i].update(deltaTime);
			
			
			}
			


			
			
			//体力条
			
			if(frameCounter%24*5==0){
				
				_action_power++;
				
			}
			
			
			//玩家行动力的条
			if(_action_power>100){				
				_action_power = 100;				
			}
			if(_action_power<0){				
				_action_power < 0;
			}
			if(_action_bar.currentFrame>_action_power){
				
				_action_bar.gotoAndStop(_action_bar.currentFrame-1);
			}
			if(_action_bar.currentFrame < _action_power){
				
				_action_bar.gotoAndStop(_action_bar.currentFrame+1);
			}
			
			
			frameCounter++;
			if(frameCounter>1000000){
				frameCounter = 0;				
			}
			
			if("start_waiting" ==_status){
				
				start_waiting(deltaTime);
				
			}
			else if("waving" == _status){
				
				waving(deltaTime);
				
			}
			else if("wave_waiting" == _status){
				
				wave_waiting(deltaTime);
				
			}
			else if("boss_fighting" == _status){
				
				boss_fighting(deltaTime);
				
			}
			else if("winning" == _status){
				
				winning(deltaTime);
				
			}
			else if("losing" == _status){
				
				
				losing(deltaTime);
				
			}
			
			
			gameOverCheck();
			
			checkOutOfBorder();
			
			clearEverything();
		}
		
		
		
				
		/*
		 * 关卡的状态机
		 * 
		 * start_waiting 刚开始倒计时
		 * 
		 * waving,一波 一波怪的状态
		 * 
		 * wave_waiting, 每一波之间的等待动画
		 * 
		 * boss_fighting,打boss的状态
		 * 
		 * winning,关卡胜利
		 * 
		 * losing,关卡失败
		 */
		
		
		public function start_waiting(deltaTime:int):void{
			
			
			
			
		}
		
		//waving
		public function waving(deltaTime:int):void{
			
			
			if(_cur_wave){
				_cur_wave.update(deltaTime);
			}
			
		}
		
		
		//wave_waiting				
		public function wave_waiting(deltaTime:int){
			
			
			
				
			_cur_wave_num++;
			if(_cur_wave_num < _waves_list.length){
				
				if(_cur_wave){
					_cur_wave.destory();
				}
				_cur_wave = _waves_list[_cur_wave_num];
				_cur_wave.init();
				setStatus("waving");
					
			}
			else {
				if(_cur_wave){
					_cur_wave.destory();
				
				}
				_boss_wave.init();
				setStatus("boss_fighting");
			}
			
			
			
		}
		

		
		
		
		//boss_fighting
		public function boss_fighting(deltaTime:int) {
			if(_boss_wave){
				_boss_wave.update(deltaTime);
			}
		}
		
		//winning
		public function winning(deltaTime:int){
			
			
			
		}
		
		//losing
		public function losing(deltaTime:int){
			
			
			
			
		}
		
		
		
		public function gameOverCheck(){
			
			
			if(liveCannons.length==0&&_status!="losing"){
				
				_gameOverView = new GameOver();
				_gameOverView.x = 400;
				_gameOverView.y = 400;
				addView(_gameOverView);
				setStatus("losing");

			}
			
			
		}
		
		public function gameWin(){
			
			if (_status != "winning") {
				_gameWinView = new GameWin()
				_gameWinView.x = 400;
				_gameWinView.y = 400;
				addView(_gameWinView);
				setStatus("winning");
				
			}
			
		}
		
		
		
		//暂时用作清除对象
		public function checkOutOfBorder(){
			
			
			
			for (var bb:b2Body = m_world.GetBodyList(); bb; bb = bb.GetNext()){
				
				if(bb.GetWorldCenter().x < 850/pixel_per_meter && bb.GetWorldCenter().y < 850/pixel_per_meter && bb.GetWorldCenter().x > -50/pixel_per_meter&&bb.GetWorldCenter().y > -50/pixel_per_meter){
					
					
				}
				else {
					if(bb.GetUserData() is evoBullet){
						bb.GetUserData().setClear();
					}
					else if(bb.GetUserData() is evoEnemy ){
						bb.GetUserData().setClear();
					}
				}
			}
			

			
			
		}
		
		
		
		public function clearEverything(){
			
			
			
			for (var m:Number = liveCannons.length-1; m >= 0 ; m--){
			
				if(liveCannons[m].isNeedClear()){
					
					//todo 清除死亡的cannon
					delView(liveCannons[m]);
					//delView(liveCannons[m]._epbar);
					//m_world.DestroyBody(liveCannons[m].getPhysBody());
					//最后移除，不然会造成bug
					liveCannons.splice(liveCannons.indexOf(liveCannons[m]), 1);				
				}

			}
			
			//bullets
			for (var i:Number = bulletsArray.length-1; i >= 0; i--){
			
				if (bulletsArray[i].isNeedClear()) {
					delView(bulletsArray[i]);
					m_world.DestroyBody(bulletsArray[i].getPhysBody());
					//最后移除，不然会造成bug
					bulletsArray.splice(bulletsArray.indexOf(bulletsArray[i]), 1);

				}
			
			
			}
			
			//enemies
			for (var j:Number = enemiesArray.length-1; j >= 0; j--){
			
				if(enemiesArray[j].isNeedClear()){
				
					createBoomView(enemiesArray[j].getPhysBody().GetWorldCenter().x*pixel_per_meter, enemiesArray[j].getPhysBody().GetWorldCenter().y*pixel_per_meter);
					delView(enemiesArray[j]);
					m_world.DestroyBody(enemiesArray[j].getPhysBody());


					//最后移除，不然会造成bug
					enemiesArray.splice(enemiesArray.indexOf(enemiesArray[j]), 1);
				}				

			}
			//清除 爆炸效果mc
			for (var n:Number = boomViewsArray.length - 1; n >= 0; n-- ){
				//trace(boomViewsArray[n].currentFrame);
				if(boomViewsArray[n].currentFrame==12){
					delView(boomViewsArray[n]);
					boomViewsArray.splice(boomViewsArray.indexOf(boomViewsArray[n]), 1);
				}
			}
			
		}
		
		
		
		public override function Destroy(){
			
			for (var m:Number = liveCannons.length-1; m >= 0 ; m--){
			
				liveCannons[m].setClear();				
				

			}
			
			//bullets
			for (var i:Number = bulletsArray.length-1; i >= 0; i--){
			
				bulletsArray[i].setClear();			
			
			}
			
			//enemies
			for (var j:Number = enemiesArray.length-1; j >= 0; j--){
			
				enemiesArray[j].setClear();

			}
			
			_cur_wave.destory();
			clearEverything();
			
			//清除 爆炸效果mc
			for (var n:Number = boomViewsArray.length - 1; n >= 0; n-- ){
				delView(boomViewsArray[n]);
				boomViewsArray.splice(boomViewsArray.indexOf(boomViewsArray[n]), 1);
			}	
			
			
			
			
		}
		
		
		public function addView(view:DisplayObject){
			
			this.addChild(view);
			//Main.gameMain._mainContainer.addChild(view);
		}
		
		
		public function delView(view:DisplayObject){
			
			this.removeChild(view);
			//Main.gameMain._mainContainer.removeChild(view);
		}		
		
		
		public function initDebugDraw(){
			
			 //set debug draw
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			
			addView(debug_sprite); 
			
			debugDraw.SetSprite(debug_sprite);
			debugDraw.SetDrawScale(pixel_per_meter);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			m_world.SetDebugDraw(debugDraw);
			m_world.DrawDebugData();
	
			
			
			
		}
		
		
		
		public function createCircle(x:Number, y:Number, radius:Number,userData:*=null):b2Body {
			
			var circleBody:b2Body;
			var circleDef:b2BodyDef;
			var circleShape:b2CircleShape;
			
			
			circleDef = new b2BodyDef();
			circleDef.type = b2Body.b2_dynamicBody;
			circleDef.position.Set(x, y);
			
			if(userData){
				circleDef.userData=userData;
			}
			
		
			//形状
			circleShape = new b2CircleShape();
			circleShape.SetRadius(radius);
	
			//夹具
			var circleFixtureDef:b2FixtureDef = new b2FixtureDef();
			circleFixtureDef.shape = circleShape;
			circleFixtureDef.density = 1;
			circleFixtureDef.restitution = 0.2;
			circleFixtureDef.friction = 0.5;
		
			
			
			
			circleBody = m_world.CreateBody(circleDef);
			circleBody.CreateFixture(circleFixtureDef);	
			
			return circleBody;
			
			
		}
		
		
		
		public function addBullet(bullet:evoBullet){
			
			bulletsArray.push(bullet);
			this.addView(bullet);
			
		}
		
		public function createEnemy(x:Number, y:Number,_p_radius:Number=9):evoEnemy {
			
			var enemy:evoEnemy = new evoEnemy(this);
			
			var enemy_body:b2Body  = createCircle(x / pixel_per_meter, y / pixel_per_meter,_p_radius/pixel_per_meter, enemy);
			
			enemy.setPhysBody(enemy_body);
			
			enemiesArray.push(enemy);
			
			this.addView(enemy);
			
			return enemy;
			
		}
		
		public function createBoomView(px:Number,py:Number){
			
			var view:MovieClip = new boomView();
				
			//trace(view.currentFrame);
			view.x = px;
			view.y = py;
			this.addView(view);
			view.gotoAndPlay(0);
			boomViewsArray.push(view);
			
		}
		
		
		
		public function createCannon(fatherCannon:evoCannon=null,pos_num:Number=-1):evoCannon{
			
			
		
			
			if (pos_num == -1) {
				
				pos_num = findCannoPos();
			}
			
			if(_cannon_pos_array.indexOf(pos_num)!=-1){
				var col = pos_num / 40;
				var row = pos_num % 40;
			 
				var newCannon:evoCannon = new evoCannon(this,pos_num);
			
				newCannon.x = row * 20;
				newCannon.y = col * 20;
				newCannon.rotation = Math.random() * 360;
				newCannon.setEp(50);
				newCannon.setStatus("growing");
				if(fatherCannon){
					newCannon.setCannonFahter(fatherCannon);
					//突变和进化
					birth_logic(newCannon);

				}
				liveCannons.push(newCannon);
				this.addView(newCannon);
				
				_cannon_pos_array.splice(_cannon_pos_array.indexOf(pos_num), 1);
				return newCannon;
			}
			return null;
		}
		
		public function findCannoPos():Number{
			
			 var random:int=Math.random() * _cannon_pos_array.length;			

			 return _cannon_pos_array[random];
			
			 
			 
		}
		
		//cannon 死去
		public function deleteCannon(cannon:evoCannon ){
			
			cannon.setClear();
			_cannon_pos_array.push(cannon.getPosGridNum());
			
		}
		
		
		public function init_gene_config():void{
			
			
			_genge_mutations_config['eye'] = 0.3;
			_genge_mutations_config['wait_time'] = 0.3;
			_genge_mutations_config['range'] = 0.4;
			
		}
		
		public function getMutationsGene(canno:evoCannon):evoGene{
			
			var r_num = Math.random();
			var sum = 0;
			
			for(var  key:String in _genge_mutations_config){
				
				if(r_num <sum+_genge_mutations_config[key]){
					
					return evoGene.getGeneClassByName(key,canno,this);
				}
				sum+=_genge_mutations_config[key]
				
			}
			return null;
			
		}
		
		
		
		public function birth_logic(canno:evoCannon){
			
			var evo_ratio:Number = Math.random();
			
			canno._main_fire_gene = evoGene.getGeneClassByName(canno._fatherCannon._main_fire_gene.getName(),canno,this);
			canno._main_fire_gene._gene_level= canno._fatherCannon._main_fire_gene._gene_level;
			
			if(canno._fatherCannon._eye_gene){
				canno._eye_gene = evoGene.getGeneClassByName(canno._fatherCannon._eye_gene.getName(),canno,this);
				canno._eye_gene._gene_level = canno._fatherCannon._eye_gene._gene_level;			
			}
			
			 for (var i:int = 0; i < canno._fatherCannon._power_genes.length;i++){				 
				 var tmp:evoGene = canno._fatherCannon._power_genes[i];
				 var gene:evoGene = evoGene.getGeneClassByName(tmp.getName(),canno,this);
				 gene._gene_level = tmp._gene_level;
				 canno._power_genes.push(gene);				 
			 }
			
			var evoArray:Array = new Array();				
				evoArray=canno._power_genes.slice(0,canno._power_genes.length);
				evoArray.push(canno._main_fire_gene);
			if(canno._eye_gene){					
				evoArray.push(canno._eye_gene);
			}
			var theNum:int =Math.floor((Math.random() * evoArray.length)) ;
			
			
			
			if(evo_ratio<_evo_ratio){
			//进化	
				evoArray[theNum]._gene_level += 1;				
				_txt.appendText(canno._canno_name+"发生进化,基因:" + evoArray[theNum].getName()+"\n");
				_txt.appendText("---" + (evoArray[theNum]._gene_level - 1) + ">>>" + evoArray[theNum]._gene_level+"\n");
				_txt.scrollV++;
				_txt.scrollV++;


			}
			else{
			//突变 可能导致退化
				var m_g:evoGene = getMutationsGene(canno);
				
				_txt.appendText(canno._canno_name+ "发生突变获得"+m_g.getName()+"\n");
				_txt.scrollV++;

				if ("eye"==m_g.getName()){
					
					canno._eye_gene = m_g as evoEyeGene;
				}
				else if("normal_fire"==m_g.getName()){
					
					
				}
				else{
					canno._power_genes.splice(canno._power_genes.indexOf(evoArray[theNum]), 1);
					canno._power_genes.push(m_g);
					
				}
			
			}
			//生成属性
			canno.powerOfGene();
			
		}
		
		
		
		public function setStatus(status:String){
			
			
			_status = status;
		}
		
		public function nextWave(){
			
			setStatus("wave_waiting");
			
		}
		
	
		public function pause(){
			
			_isPause = true;
		}
		
		public function unpause(){
			
			_isPause = false;
			
		}
		
		
		public var m_world:b2World;
		public var m_velocityIterations:int = 5;
		public var m_positionIterations:int = 5;
		public var m_timeStep:Number = 1.0 /24;
		public var pixel_per_meter = 30;
		public var _contactListener = new evoContactListener();
	
		
		public var selectedCannon:evoCannon;
		
		public var liveCannons:Array = new Array();
		public var bulletsArray:Array = new Array();
		public var enemiesArray:Array = new Array();

		public var boomViewsArray:Array = new Array();
		
		public var cannoInfo:MovieClip;
		

		public var frameCounter:Number = 0; //todo  修改成timer形式
		
		public var testEnemy:evoEnemy;
		
		//40*40的网格 这个array有 160个位置
		public var _cannon_pos_array:Array = new Array();
					
		
		
		//行动力
		public var _action_power:Number = 100;
		public var _action_bar:MovieClip = new ActionBar();
		
		public var _txt:TextField = new TextField();
		
		
		public var _genge_mutations_config:Dictionary = new Dictionary();
		
		public var _evo_ratio:Number = 0.5;
		public var _mutations_ratio:Number = 0.5;
		
		
		/*
		 * 关卡的状态机
		 * 
		 * start_waiting 刚开始倒计时
		 * 
		 * waving,一波 一波怪的状态
		 * 
		 * wave_waiting, 每一波之间的等待动画
		 * 
		 * boss_fighting,打boss的状态
		 * 
		 * winning,关卡胜利
		 * 
		 * losing,关卡失败
		 */
		
		public var _status:String = "start_waiting";
		
		
		//暂停状态
		
		public var _isPause:Boolean=false;
		
		//waving 状态下的
		
		public var _cur_wave:evoWave;
		public var _cur_wave_num:Number = -1;
		
		public var _boss_wave:evoWave;
		
		public var _waves_list:Array;
		
		
		public var _gameOverView:MovieClip;
		
		public var _gameWinView:MovieClip;
		public var _ap_not_enough_bar:MovieClip;

		
	}

}