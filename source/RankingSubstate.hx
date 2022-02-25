package;

import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class RankingSubstate extends MusicBeatSubstate
{
	var pauseMusic:FlxSound;

	var rank:FlxSprite = new FlxSprite(-200, 730);
	var combo:FlxSprite = new FlxSprite(-200, 730);
	var comboRank:String = "N/A";
	var ranking:String = "N/A";
	var rankingNum:Int = 15;

	public function new(x:Float, y:Float)
	{
		super();

		generateRanking();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		// FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		rank = new FlxSprite(-20, 40).loadGraphic(Paths.image('rankings/$ranking'));
		rank.scrollFactor.set();
		add(rank);
		rank.antialiasing = true;
		rank.setGraphicSize(0, 450);
		rank.updateHitbox();
		rank.screenCenter();

		combo = new FlxSprite(-20, 40).loadGraphic(Paths.image('rankings/$comboRank'));
		combo.scrollFactor.set();
		combo.screenCenter();
		combo.x = rank.x - combo.width / 2;
		combo.y = rank.y - combo.height / 2;
		add(combo);
		combo.antialiasing = true;
		combo.setGraphicSize(0, 130);

		var press:FlxText = new FlxText(20, 15, 0, "Press any key to continue.", 32);
		press.scrollFactor.set();
		press.setFormat(Paths.font("vcr.ttf"), 32);
		press.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		press.updateHitbox();
		//add(press);

		var hint:FlxText = new FlxText(20, 15, 0, "You passed. Try getting under 10 misses for SDCB", 32);
		hint.scrollFactor.set();
		hint.setFormat(Paths.font("vcr.ttf"), 32);
		hint.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		hint.updateHitbox();
		add(hint);

		switch (comboRank)
		{
			case 'MFC':
				hint.text = "Congrats! You're perfect!";
			case 'GFC':
				hint.text = "You're doing great! Try getting only sicks for MFC";
			case 'FC':
				hint.text = "Good job. Try getting goods at minimum for GFC.";
			case 'SDCB':
				hint.text = "Nice. Try not missing at all for FC.";
			case 'BOT':
				hint.text = "Score not counted. For a score to be counted, don't use botplay.";
		}

	

		if (PlayState.deathCounter >= 5)
		{
			hint.text = "Maybe try dying less.";
		}

		hint.screenCenter(X);

		hint.alpha = press.alpha = 0;

		press.screenCenter();
		press.y = 670 - press.height;

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(press, {alpha: 1, y: 690 - press.height}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(hint, {alpha: 1, y: 645 - hint.height}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		//if (FlxG.keys.pressed.ANY){
		//	close();
		//}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function destroy()
	{
		pauseMusic.destroy();
		super.destroy();
	}

	function generateRanking():String
	{
		if (PlayState.rankMisses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
			comboRank = "MFC";
		else if (PlayState.rankMisses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			comboRank = "GFC";
		else if (PlayState.rankMisses == 0) // Regular FC
			comboRank = "FC";
		else if (PlayState.rankMisses < 10) // Single Digit Combo Breaks
			comboRank = "SDCB";
		if (PlayState.botPlay)
			comboRank = 'BOT';

		// WIFE TIME :)))) (based on Wife3)
		var accuracy:Float = PlayState.rankPercent;
		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // P
			accuracy >= 99.980, // X
			accuracy >= 99.950, // X-
			accuracy >= 99.90, // SS+
			accuracy >= 99.80, // SS
			accuracy >= 99.70, // SS-
			accuracy >= 99.50, // S+
			accuracy >= 99, // S
			accuracy >= 96.50, // S-
			accuracy >= 93, // A+
			accuracy >= 90, // A
			accuracy >= 85, // A-
			accuracy >= 80, // B
			accuracy >= 70, // C
			accuracy >= 60, // D
			accuracy < 60 // E
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				rankingNum = i;
				switch (i)
				{
					case 0:
						ranking = "P";
					case 1:
						ranking = "X";
					case 2:
						ranking = "X-";
					case 3:
						ranking = "SS+";
					case 4:
						ranking = "SS";
					case 5:
						ranking = "SS-";
					case 6:
						ranking = "S+";
					case 7:
						ranking = "S";
					case 8:
						ranking = "S-";
					case 9:
						ranking = "A+";
					case 10:
						ranking = "A";
					case 11:
						ranking = "A-";
					case 12:
						ranking = "B";
					case 13:
						ranking = "C";
					case 14:
						ranking = "D";
					case 15:
						ranking = "E";
				}

				if (PlayState.deathCounter >= 30 || accuracy == 0)
					ranking = "F";
				if (PlayState.botPlay) {
					ranking = "N/A"; }
				break;
			}
		}
		return ranking;
	}
}
