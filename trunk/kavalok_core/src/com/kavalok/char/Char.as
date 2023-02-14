package com.kavalok.char
{
	import com.kavalok.Global;
	import com.kavalok.dto.pet.PetTO;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.remoting.DataObject;
	
	public class Char extends DataObject
	{
		public var id:String;
		public var userId:Number;
		public var blogURL:String;
		public var challenges:String;
		public var isCitizen:Boolean;
		public var isMerchant:Boolean;
		public var isModerator:Boolean;
		public var publicLocation:Boolean;
		public var isTest:Boolean;
		public var isAgent:Boolean;
		public var isParent:Boolean;
		public var isGuest:Boolean;
		public var isScout:Boolean;
		public var isStaff:Boolean;
		public var hasBody:Boolean;
		public var isNinja:Boolean;
		public var team:String;
		public var isDev:Boolean;
		public var isDes:Boolean;
		public var isSupport:Boolean;
		public var status:String;
		public var isArtist:Boolean;
		public var isForumer:Boolean;
		public var isJournalist:Boolean;
		public var isEliteJournalist:Boolean;
		public var locale:String;
		public var chatEnabled:Boolean;
		public var chatEnabledByParent:Boolean;
		public var enabled:Boolean;
		public var acceptRequests:Boolean;
		public var acceptNight:Boolean;
		public var age:Number;
		public var server:String;
		public var hasRobot:Boolean;
		public var isNotActivated:Boolean;
		public var spinAmount:int;
		public var check1:int;
		public var check2:int;
		public var check3:int;
	///	public var chatLog:String;
		public var teamName:String;
		public var teamColor:int;
		public var experience:int;
		public var twitterName:String;
		public var permissions:String;
		public var achievements:String;
		public var charLevel:int;
		public var trackerLocation:Boolean;
		public var location:String;
		public var shareLocation:Boolean;
		public var purchasedBubbles:String;
		public var purchasedBodies:String;
		public var outfits:String;
		//	public var accessToken:String;
		//	public var accessTokenSecret:String;
		public var citizenTryCount:Boolean;
		public var isOnline:Boolean;
		public var moodId:String;
		
		public var body:String = CharManager.DEFAULT_BODY;
		public var blogLink:String = '';
		public var gender:String;
		public var color:int = 0xAAAAAA;
		public var tool:String;
		public var clothes:Array /*of String*/ = [];
		public var pet:PetTO;
		public var playerCard:StuffItemLightTO;
		
		public function get isUser():Boolean
		{
			return (id == Global.charManager.charId);
		}

		public function get blogTitle():String
		{
			if(permissions.indexOf("&&") != -1){
			var part1:String = permissions.split("&&")[1];
			var part2:String = part1.split("%%")[0];
			return part2;
		} else {
			return "No Blog";
		}
		}
		
		public function get hasBlog():Boolean
		{
			if (Global.charManager.blogLink.length > 1)
			{
				return true;
			}
			else
			{
				return false;
			}
		
		}
		
		public function Char(data:Object = null)
		{
		
			super(data);
			
			if (data)
			{
				if ('agent' in data)
					this.isAgent = data.agent;
				if ('moderator' in data)
					this.isModerator = data.moderator;
				if ('publicLocation' in data)
				    this.publicLocation = data.publicLocation;
				if ('test' in data)
					this.isTest = data.test;
				if ('citizen' in data)
					this.isCitizen = data.citizen;
				if ('merchant' in data)
			        this.isMerchant = data.merchant;
				if ('guest' in data)
					this.isGuest = data.guest;
			
				if ('online' in data)
					this.isOnline = data.online;
				if ('parent' in data)
					this.isParent = data.parent;
				if ('staff' in data)
					this.isStaff = data.staff;
				if ('ninja' in data)
					this.isNinja = data.ninja;
				if ('dev' in data)
					this.isDev = data.dev;
				if ('des' in data)
					this.isDes = data.des;
				if ('support' in data)
					this.isSupport = data.support;
				if('scout' in data)
					this.isScout = data.scout;
				if('forumer' in data)
					this.isForumer = data.forumer;
				if ('artist' in data)
					this.isArtist = data.artist;
				if ('journalist' in data)
					this.isJournalist = data.journalist;
				if('eliteJournalist' in data)
					this.isEliteJournalist = data.eliteJournalist;
				if ('blogLink' in data)
					this.blogLink = data.blogLink;

					//this.isCitizen = true;
			}
		
		}
	
	}
}