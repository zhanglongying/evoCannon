package com.dull.genes 
{
	import com.dull.evoCannon;
	import com.dull.evoLevel;
	
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoRangeGene extends evoGene 
	{
		
		public function evoRangeGene(c:evoCannon, l:evoLevel) 
		{
			super(c, l);
			
		}
		
		
		public override function init_gene(){
			
			_cannon._fire_range+= _gene_level*2;
			
		}
		
		public override function getIntro():String{
			
			
			
			return "射程+1\n";
			
		}
		
		public override function getName():String{
			
			
			return "range";
			
		}
		
	}

}