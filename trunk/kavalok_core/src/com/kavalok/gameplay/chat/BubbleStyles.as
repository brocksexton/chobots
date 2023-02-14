package com.kavalok.gameplay.chat
{
	import flash.filters.GlowFilter;
	
	public class BubbleStyles
	{
		static public const DEFAULT:String = 'D';
		static public const CITIZEN:String = 'C';
		static public const MODERATOR:String = 'M';
		static public const AGENT:String = 'A';
		static public const CITIZEN_AGENT:String = 'CA';
		static public const PROMOTION:String = 'P';
		static public var BUBBLEARRAY:Array = [
			{name:'fusion',val:'FUS'},
		   	{name:'blublastr',val:'BLBS'},
		   	{name:'spring',val:'SPR'},
			{name:'salmon',val:'SA'},
			{name:'puryel',val:'PUY'},
		   	{name:'black',val:'BLA'},
		   	{name:'futuristic',val:'FUT'},
		   	{name:'gia',val:'GI'},
		   	{name:'PinkGreen',val:'PG'},
		   	{name:'ethan',val:'EM'},
		   	{name:'royal',val:'RY'},
		   	{name:'ora_stripes',val:'ORG'},
		   	{name:'turquoise',val:'TUR'},
		   	{name:'polka',val:'PK'},
		   	{name:'neon',val:'NE'},
		   	{name:'silver',val:'SI'},
		   	{name:'red_stripes',val:'RS'},
		   	{name:'blue_stripes',val:'BS'},
		   	{name:'rainbow',val:'RB'},
		   	{name:'purple',val:'PU'},
		   	{name:'dgrey',val:'DG'},
		   	{name:'orange',val:'O'},
		   	{name:'pink',val:'PI'},
		   	{name:'glowblue',val:'GLOB'},
		   	{name:'pinkpur',val:'PIPU'},
		   	{name:'whiteblue',val:'WIB'},
		   	{name:'pets',val:'PET'},
		   	{name:'caramel',val:'CAR'},
		    {name:'abstrgreen',val:'AGR'},
		   	{name:'whiteblue',val:'WIB'},
		   	{name:'nicho',val:'NC'},
		    {name:'army',val:'AR'},
		    {name:'red_sand',val:'RS'},
		    {name:'fire', val:'FR'},
		    {name:'circles', val:'CRC'},
		    {name:'stars', val:'ST'},
		    {name:'redDia', val:'RD'},
		    {name:'cfiber', val:'CF'},
		    {name:'glassWork', val:'GW1'},
		    {name:'candyCane', val:'CDC'},
		    {name:'bloodRed', val:'BR'},
		    {name:'greenBlack', val:'GB'},
		    {name:'ocean', val:'OC'},
		    {name:'lepord', val:'BRO'},
		    {name:'rainbow2', val:'RAN'},
		    {name:'space', val:'SPA'},
		    {name:'roses', val:'ROS'},
		    {name:'smiley', val:'SMI'},
		    {name:'beach', val:'BCH'}
										   ];
		static private var _styles:Object;
		
		static public function getStyle(styleName:String):BubbleStyle
		{
			if (!_styles)
				initializeStyles();
			
			return _styles[styleName];
		}
		
		static private function initializeStyles():void
		{
			_styles = {};
			_styles[DEFAULT] = new BubbleStyle(12, 1, 120);
			_styles['EM'] = new BubbleStyle(15, 3, 150, "0xFFFFFF", "red");
			_styles[CITIZEN] = new BubbleStyle(15, 2, 150);
			_styles['PG'] = new BubbleStyle(13, 15, 120);
			_styles[MODERATOR] = new BubbleStyle(15, 3, 150);
			_styles[AGENT] = new BubbleStyle(12, 4, 120);
			_styles[CITIZEN_AGENT] = new BubbleStyle(15, 4, 120);
			_styles[PROMOTION] = new BubbleStyle(16, 5, 120);
			_styles['PU'] = new BubbleStyle(15, 6, 120);
			_styles['O'] = new BubbleStyle(15, 7, 120);
			_styles['PI'] = new BubbleStyle(15, 8, 120);
			_styles['DG'] = new BubbleStyle(15, 9, 120);
			_styles['SA'] = new BubbleStyle(15, 10, 120);
			_styles['BS'] = new BubbleStyle(15, 11, 120)
			_styles['RS'] = new BubbleStyle(15, 12, 120);
			_styles['RB'] = new BubbleStyle(14, 13, 120);
			_styles['SI'] = new BubbleStyle(14, 14, 120);
			_styles['PG'] = new BubbleStyle(14, 15, 120);
			_styles['RY'] = new BubbleStyle(14, 16, 120);
			_styles['PK'] = new BubbleStyle(14, 17, 120);
			_styles['NE'] = new BubbleStyle(14, 18, 120);
			_styles['ORG'] = new BubbleStyle(14, 19, 120);
			_styles['NC'] = new BubbleStyle(14, 20, 120, "0xFFFFFF");
			_styles['TUR'] = new BubbleStyle(14, 21, 120);
			_styles['BLA'] = new BubbleStyle(14, 22, 120, "0xFFFFFF");
			_styles['JAKEY'] = new BubbleStyle(16, 23, 150, "0x00FF00", "red");
			_styles['ZH'] = new BubbleStyle(12, 4, 120, "0xFF0000", "green");
			_styles['GI'] = new BubbleStyle(14, 24, 120, "0xFF0000");
			_styles['FUT'] = new BubbleStyle(14, 25, 120, "0xFFFFFF", "black");
			_styles['PUY'] = new BubbleStyle(14, 26, 120, "0xFFFF00");
			_styles['FUS'] = new BubbleStyle(14, 27, 120, "0xFFFFFF", "black");
			_styles['SPR'] = new BubbleStyle(15, 29, 120);
			_styles['GLOB'] = new BubbleStyle(15, 30, 120, "0x151D8A", "white");
			_styles['BLBS'] = new BubbleStyle(14, 31, 120, "0xFFFFFF");
			_styles['AR'] = new BubbleStyle(14, 32, 120, "0xFFFFFF");
			_styles['AGR'] = new BubbleStyle(14, 33, 120, "0xFFFFFF");
			_styles['CAR'] = new BubbleStyle(14, 34, 120);
			_styles['PET'] = new BubbleStyle(14, 35, 120);
			_styles['PIPU'] = new BubbleStyle(14, 36, 120);
			_styles['WIB'] = new BubbleStyle(14, 37, 120);
			_styles['RS'] = new BubbleStyle(15, 38, 120, "0x151D8A", "white");
			_styles['ST'] = new BubbleStyle(14, 39, 120, "0xFFFFFF", "black");
			_styles['CRC'] = new BubbleStyle(14, 40, 120, "0xFFFFFF");
			_styles['FR'] = new BubbleStyle(15, 41, 120, "0xFFFFFF", "black");
			_styles['RD'] = new BubbleStyle(14, 42, 120, "0xFFFFFF", "white");
			_styles['CF'] = new BubbleStyle(14, 43, 120, "0xFFFFFF", "white");
			_styles['GW1'] = new BubbleStyle(14, 44, 120);
			_styles['CDC'] = new BubbleStyle(14, 45, 120);
			_styles['GB'] = new BubbleStyle(14, 46, 120, "0xFFFFFF");
			_styles["OC"] = new BubbleStyle(14,47,120);
			 _styles["BR"] = new BubbleStyle(14,48,120);
			 _styles["BRO"] = new BubbleStyle(14,49,120,"0xFFFFFF","black");
			 _styles["RAN"] = new BubbleStyle(14,50,120,"0xFFFFFF","white2");
			 _styles["SPA"] = new BubbleStyle(14,51,120,"0xFFFFFF","white2");
			 _styles["ROS"] = new BubbleStyle(14,52,120,"0xFFFFFF","white2");
			 _styles["SMI"] = new BubbleStyle(14,53,120);
			 _styles["BCH"] = new BubbleStyle(14,54,120);
		}
		
		static public function get defaultStyle():BubbleStyle
		{
			return getStyle(DEFAULT);
		}
		
		static public function get modStyle():BubbleStyle
		{
			return getStyle(MODERATOR);
		}
	
	}
}