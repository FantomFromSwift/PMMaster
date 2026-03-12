# Asset Description File for PM Master

This file defines the assets used across the PM Master application views. You should add corresponding images to your `Assets.xcassets` matching these exact names. If any asset is missing, a fallback UI element will be rendered, but for the optimal appearance, all assets below should be present.

```
stadium_field_day
Bright football stadium background (used in Onboarding & Fallbacks)

tactical_board
Top view of football tactics board (used in Articles & Training Tasks)

football_players_silhouette
Minimal players silhouettes 

neon_ball
Glowing football ball (Splash View alternative)

defense_wall
Defensive players wall forming a line (Onboarding)

attack_arrows
Tactical attacking arrows overlay on a field (Onboarding)

pass_choices
Player deciding between passing options

lab_sliders
Abstract lab controls graphic

header_art_1
Generic high quality header art for articles

header_art_2
Generic high quality header art for scenarios

coach_room_dark
Dark themed coach laboratory background (Default App Background)

golden_trophy
Glowing golden trophy for rewards/streaks

neon_stadium_bg
Neon-lit futuristic stadium (Neon Stadium theme)

training_cone
Training cone on the field (Tracker & Stats placeholder)
```

**Note:** The application uses modern SF Symbols (`soccerball.inverse`, `shield`, `flag.checkered`, etc.) and system gradients extensively to minimize the need for manual assets. Some assets listed above are explicitly tied to the UI using the `AppImage` enum strictly typed in `Constants_PM.swift`.
