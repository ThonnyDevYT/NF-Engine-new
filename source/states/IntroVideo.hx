package states;

import states.TitleState;

class IntroVideo extends MusicBeatState
{
    override public function create():Void {
        super.create();

        MusicBeatState.newVideo("Intro");
    }

    override function update(elapsed:Float) {
        if (controls.ACCEPT) {
            MusicBeatState.switchState(new TitleState());
    }

        if (FlxG.keys.justPressed.SPACE) {
            MusicBeatState.video.pause();
        } else if (FlxG.keys.justReleased.SPACE) {
            MusicBeatState.video.resume();
        }
    }
}