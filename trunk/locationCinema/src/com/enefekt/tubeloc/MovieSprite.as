import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.media.StageWebView;
import some.package.PlayerReadyEvent;
import some.package.MovieStateChangeEvent;

public class YoutubeExample extends Sprite {

    private var webView:StageWebView;
    private var player:Object;
    private var ytHeight:Number = stage.stageHeight;
    private var ytWidth:Number = stage.stageWidth;
    private var lastVolumeSet:Number = 100;
    private var lastStateUpdate:MovieStateChangeEvent;
    private var waitingForUnload:Boolean = false;

    public function YoutubeExample() {
        webView = new StageWebView();
        webView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        webView.loadURL("https://www.youtube.com/embed/M7lc1UVf-VE?list=PLB_zuMqcN6UcON6MGd_oZ_zjG73FtrJc2&autoplay=1");
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        webView.stage = stage;
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        initPlayer();
    }

    private function initPlayer():void {
        if (!player) {
            player = new YT.Player("player", {
                height: ytHeight,
                width: ytWidth,
                videoId: "",
                events: {
                    onReady: onPlayerReady,
                    onStateChange: onPlayerStateChange
                }
            });
        }
    }

    private function onPlayerReady(event:Object):void {
        var readyEvent:PlayerReadyEvent = new PlayerReadyEvent();
        dispatchEvent(readyEvent);
    }

    private function onPlayerStateChange(event:Object):void {
        if (event.data == YT.PlayerState.ENDED && waitingForUnload) {
            waitingForUnload = false;
            unloadPlayerSWF();
        } else {
            var stateChangeEvent:MovieStateChange
			Event = new MovieStateChangeEvent();
            stateChangeEvent.stateCode = event.data;
            lastStateUpdate = stateChangeEvent;
            dispatchEvent(stateChangeEvent);
        }
    }

    public function seekTo(seconds_p:Number):void {
        player.seekTo(seconds_p, true);
    }

    public function setVolume(volume_p:Number):void {
        player.setVolume(volume_p);
        lastVolumeSet = volume_p;
    }

    public function getVolume():Number {
        return lastVolumeSet;
    }

    public function unMute():void {
        player.unMute();
    }

    public function mute():void {
        player.mute();
    }

    public function setSize(width_p:Number, height_p:Number):void {
        player.setSize(width_p, height_p);
    }

    public function loadVideoById(videoId_p:String, startSeconds_p:Number = 0):void {
        player.loadVideoById({
            videoId: videoId_p,
            startSeconds: startSeconds_p
        });
    }

    public function cueVideoById(videoId_p:String, startSeconds_p:Number = 0):void {
        player.cueVideoById({
            videoId: videoId_p,
            startSeconds: startSeconds_p
        });
    }

    public function stopVideo():void {
        player.stopVideo();
    }

    public function playVideo():void {
        player.playVideo();
    }

    public function pauseVideo():void {
        player.pauseVideo();
    }

    public function getStateDescription():String {
        var desc:String;

        if (!lastStateUpdate) {
            return "No state reported yet";
        }

        switch (lastStateUpdate.stateCode) {
            case YT.PlayerState.UNSTARTED:
                desc = "Unstarted";
                break;
            case YT.PlayerState.ENDED:
                desc = "Ended";
                break;
            case YT.PlayerState.PLAYING:
                desc = "Playing";
                break;
            case YT.PlayerState.PAUSED:
                desc = "Paused";
                break;
            case YT.PlayerState.BUFFERING:
                desc = "Buffering";
                break;
            case YT.PlayerState.CUED:
                desc = "Cued";
                break;
            default:
                desc = "Unknown";
                break;
        }

        return desc;
    }

    public function unloadPlayerSWF():void {
        if (player) {
            player.destroy();
            player = null;
        }
    }
}

