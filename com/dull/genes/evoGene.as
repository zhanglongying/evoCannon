package com.dull.genes 
{
	/**
	 * ...
	 * @author longying.zhang
	 */
	
	import com.dull.*;
	 
	public class evoGene 
	{
		
		public function evoGene(c:evoCannon,l:evoLevel) 
		{
			_cannon = c;
			_level = l;
			
		}
		
		
		//基因需要初始化的值
		public virtual function init_gene(){
			
			
			
		}
		
		
		public virtual function finding(){
			
			
			
		}
		
		
		public virtual function firing(){
			
			
			
		}
		
		public virtual function waiting(){
			
			
			
		}
		
		
		public virtual function getIntro():String{
			
			
			return "";
		}
		
		
		public virtual function getName():String {
		
			
			
			
			return "";
			
		}
		
		public static function getGeneClassByName(name:String,cannon:evoCannon,level:evoLevel){
			
			if("eye"==name){
				
				
				return new evoEyeGene(cannon,level);
				
			}
			else if("range"==name){
				
				
				return new evoRangeGene(cannon,level);
				
			}
			else if("wait_time"==name){
				
				return new evoWaitTimeGene(cannon,level);
				
			}
			else if("normal_fire"==name){
				
				
				return new evoNormalFireGene(cannon,level);
			}
	
			
			
		}
		
		
		public var _cannon:evoCannon;
		public var _level:evoLevel;
		public var _gene_level:Number = 1;
		
		
	}

}