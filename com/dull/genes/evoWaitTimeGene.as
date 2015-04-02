package com.dull.genes 
{
	import com.dull.genes.evoGene;
	import com.dull.evoCannon;
	import com.dull.evoLevel;
	import com.dull.*;
	import Box2D.Common.Math.*;
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoWaitTimeGene extends evoGene 
	{
		
		public function evoWaitTimeGene(c:evoCannon, l:evoLevel) 
		{
			super(c, l);
			
		}
		
		public override function init_gene(){
			
			_cannon._max_waiting_time-= _gene_level * 0.2;
			if(_cannon._max_waiting_time<0.1){
				_cannon._max_waiting_time = 0.1;
			}
			
		}
		
		public override function getName():String{
			
			
			return "wait_time";
			
		}
	}

}