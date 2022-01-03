function onCreate()
	-- background shit
	makeLuaSprite('dude', 'dude', -200, -100);
	setScrollFactor('dude', 1, 1);
	

	addLuaSprite('dude', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end