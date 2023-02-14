package away3d.animators.skin
{
    import away3d.containers.*;
    import away3d.core.math.*;
	
    public class Channel
    {
    	public var name:String;
        public var target:Bone;
        
        public var type:Array;
		
		public var param:Array;
		public var inTangent:Array;
        public var outTangent:Array;
        
        public var times:Array;
        public var interpolations:Array;
		
        public function Channel(name:String):void
        {
        	this.name = name;
        	
        	type = [];
        	
            param = [];
            inTangent = [];
            outTangent = [];
			times = [];
			
            interpolations = [];
        }

        public function update(time:Number):void
        {
			var index:uint;
			var i:uint;
			
            if (!target)
                return;
				
            if (time < times[0]) {
            	i = 0;
            	while (i < type.length) {
	                target[type[i]] = param[0][i];
            		i++;
            	}
            } else if (time > times[times.length-1]) {
            	i = 0;
            	while (i < type.length) {
	                target[type[i]] = param[times.length-1][i];
            		i++;
            	}
            } else {
				index = 0;
				for each(var _time:Number in times) {
					if (_time <= time && time <= times[index + 1]) {
						i = 0;
						while (i < type.length) {
							if (type[i] == "transform") {
								target.transform = param[index][i];
							} else {
								target[type[i]] = ((time - _time) * param[index + 1][i] + (times[index + 1] - time) * param[index][i]) / (times[index + 1] - _time);
							}
							i++;
						}
					}
					index++;
				}
			}
        }
        
        public function clone(object:ObjectContainer3D):Channel
        {
        	var channel:Channel = new Channel(name);
        	
        	channel.target = object.getBoneByName(name);
        	channel.type = type.concat();
        	channel.param = param.concat();
        	channel.inTangent = inTangent.concat();
        	channel.outTangent = outTangent.concat();
        	channel.times = times.concat();
        	channel.interpolations = interpolations.concat();
        	
        	return channel;
        }
    }
}
