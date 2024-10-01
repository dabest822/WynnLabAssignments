This is my (Wynn Casadona's) submission for Lab 1 in Video Game Design.
I took a liking to the Godot engine, so I did a bit more than the assignment required, using the help of AI for some of the advanced GDScript coding elements.
But, I did all the research, finding sprites/images, creating animations, Collision Shapes, TileMaps, etc. myself.
This is something I could develop into a full 2D platformer type of game with enemies individually, but I think for my upcoming group project it's best to go with a type of game we can all agree on. 
I might bring it up during brainstorming, but if we want to make one from scratch, that's a different type, etc. I'll be OK with that as well.

To describe this project briefly, you control Link, who can walk, run, jump, and attack, or a combination of any of those actions together, like jumping and then attacking while mid-air.
The attacks don't have any real purpose yet, since I did not have time to develop a heart/health/damage system.
The hearts in the top left are meant to become empty (white-colored) if you get hit by an enemy. 1 heart lost = 1 hit from an enemy, 5 hits and you "die."
You are placed in a forest with a mountainous background, and a platform you can climb over.
Instantly, the enemy (a Gibdo) is slowly walking over to you autonomously.
Ideally, you would jump over the platform and take down the Gibdo, but as of right now, all you can do is run and jump around it.

I learned a lot about Godot and game development in the past couple of weeks; originally inspired by a video series on YouTube of someone attempting to fully rebuild Super Mario World (SNES) in the Godot engine.
It is very complex, but just like anything, practicing it more and more makes it easier. And it's free to use, which is good.
As for questions I still have:
- Is there any simple way to integrate a HealthUI, where if Link gets hit by moving into the attack range/Area2D of the Gibdo, then getting hit by said Gibdo, he loses a heart?
        - And then there's the aspect of the Gibdo having its own health (possibly needing 1-3 hits to be taken down), which would be its own thing to keep track of.
- Is there anything in my current setup (code, scene structure, or logic) that could lead to scaling issues or complications if I add more characters or expand the level in the future?
- Is there a way in Godot to prioritize debug messages or outputs from specific scripts so that I can easily troubleshoot individual nodes?
- How do I properly use signal connections in a dynamic setup to ensure that animations trigger correctly and states update consistently?
- Should I use groups for my Scenes as they increase in number and complexity, or is keeping 1 main Scene with all the primary elements enough, as long as you can keep track of it?
